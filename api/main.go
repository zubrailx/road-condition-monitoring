package main

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"math"
	"net/http"
	"os"
	"os/signal"
	"strconv"
	"time"

	"github.com/ClickHouse/clickhouse-go/v2"
	"github.com/ClickHouse/clickhouse-go/v2/lib/driver"
	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
)

type PredictionPoint struct {
	Time       time.Time `json:"time"`
	Latitude   float64   `json:"latitude"`
	Longitude  float64   `json:"longitude"`
	Prediction float32   `json:"prediction"`
}

var opts struct {
	clickhouseServers string
	listener          string
}

var (
	conn *driver.Conn
)

func processEnvironment() error {
	if len(os.Args) < 3 {
		return fmt.Errorf("arg len should be equal 3")
	}

	opts.clickhouseServers = os.Args[1]
	opts.listener = os.Args[2]
	return nil
}

func newClickhouseConn(ctx context.Context) (*driver.Conn, error) {
	conn, err := clickhouse.Open(&clickhouse.Options{
		Addr: []string{opts.clickhouseServers},
		ClientInfo: clickhouse.ClientInfo{
			Products: []struct {
				Name    string
				Version string
			}{
				{Name: "points-consumer-go", Version: "0.1"},
			},
		},
		Debugf: func(format string, v ...interface{}) {
			fmt.Printf(format, v)
		},
	})

	if err != nil {
		return nil, err
	}

	if err := conn.Ping(ctx); err != nil {
		if exception, ok := err.(*clickhouse.Exception); ok {
			log.Printf("Exception [%d] %s \n%s\n", exception.Code, exception.Message, exception.StackTrace)
		}
		return nil, err
	}

	log.Println("clickhouse connection established")

	return &conn, nil
}

func main() {
	ctx, cancel := signal.NotifyContext(context.Background(), os.Interrupt)
	defer cancel()

	err := processEnvironment()
	if err != nil {
		log.Fatalf("failed to process environment: %s", err)
	}

	conn, err = newClickhouseConn(ctx)
	if err != nil {
		log.Fatal("error when obtaining connection:", err)
	}

	r := chi.NewRouter()

	r.Use(middleware.Logger)

	r.Get("/ping", handlePingGet)
	r.Get("/points/{z:[0-9]+}/{x:[0-9]+}/{y:[0-9]+}", handlePointsGet)

	log.Println("ready to listen")

	http.ListenAndServe(opts.listener, r)

	<-ctx.Done()
	log.Println("interrupt signal received. shutdown")
}

func handlePingGet(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("pong"))
}

func fromPointTile(x, y, z int) (float64, float64) {
	n := math.Pow(2, float64(z))
	fmt.Println(n)

	longitude := float64(x)/n*360.0 - 180.0
	latitudeRad := math.Atan(math.Sinh(math.Pi * (1.0 - 2.0*float64(y)/n)))
	latitude := latitudeRad * 180.0 / math.Pi

	return longitude, latitude
}

func handlePointsGet(w http.ResponseWriter, r *http.Request) {
	ctx := context.Background()

	z, err := strconv.Atoi(chi.URLParam(r, "z"))
	if err != nil {
    w.WriteHeader(http.StatusBadRequest);
		w.Write([]byte("z should be integer"))
		return
	}

	x, err := strconv.Atoi(chi.URLParam(r, "x"))
	if err != nil {
    w.WriteHeader(http.StatusBadRequest);
		w.Write([]byte("x should be integer"))
		return
	}

	y, err := strconv.Atoi(chi.URLParam(r, "y"))
	if err != nil {
    w.WriteHeader(http.StatusBadRequest);
		w.Write([]byte("y should be integer"))
		return
	}

	longitudeMin, latitudeMax := fromPointTile(x, y, z)
	longitudeMax, latitudeMin := fromPointTile(x+1, y+1, z)

	rows, err := (*conn).Query(ctx,
		"SELECT time, latitude, longitude, prediction FROM points WHERE (latitude > ?) AND (latitude < ?) AND (longitude > ?) AND (longitude < ?)",
		latitudeMin, latitudeMax, longitudeMin, longitudeMax,
	)
	if err != nil {
    w.WriteHeader(http.StatusInternalServerError);
		w.Write([]byte(err.Error()))
		return
	}
	defer rows.Close()

	points := []PredictionPoint{}

	for rows.Next() {
		point := PredictionPoint{}
		if err := rows.Scan(&point.Time, &point.Latitude, &point.Longitude, &point.Prediction); err != nil {
      w.WriteHeader(http.StatusInternalServerError);
			log.Println(err.Error())
			return
		}
		points = append(points, point)
	}

	res, err := json.Marshal(points)
	if err != nil {
    w.WriteHeader(http.StatusInternalServerError);
		log.Println(err.Error())
		return
	}
  w.WriteHeader(http.StatusOK);
	w.Write(res)
}
