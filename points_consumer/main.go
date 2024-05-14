package main

import (
	"context"
	"fmt"
	"log"
	"os"
	"os/signal"
	"strconv"
	"strings"
	"sync"
	"time"

	"github.com/ClickHouse/clickhouse-go/v2"
	"github.com/ClickHouse/clickhouse-go/v2/lib/driver"
	"github.com/google/uuid"
	"github.com/segmentio/kafka-go"
	"google.golang.org/protobuf/proto"
	points "points-consumer/internal/proto/points"
)

type Args struct {
	bootstrapServers  string
	clickhouseServers string
	bufferSize        int
	triggerThreshold  int
	triggerPeriod     time.Duration
}

var wg sync.WaitGroup

func getEnvDefault(k string, fallback string) string {
	v, found := os.LookupEnv(k)
	if found {
		return v
	}
	return fallback
}

func processEnvironment() (Args, error) {
	if len(os.Args) < 3 {
		return Args{}, fmt.Errorf("arg len should be equal 3")
	}

	bufferSize, err := strconv.Atoi(getEnvDefault("PC_BUFFER_SIZE", "2000"))
	if err != nil {
		return Args{}, fmt.Errorf("error parsing bufferSize %s", err)
	}
	triggerThreshold, err := strconv.Atoi(getEnvDefault("PC_TRIGGER_THRESHOLD", "1000"))
	if err != nil {
		return Args{}, fmt.Errorf("error parsing triggerThreshold %s", err)
	}
	triggerPeriod, err := strconv.Atoi(getEnvDefault("PC_TRIGGER_PERIOD", "5000")) // in milliseconds
	if err != nil {
		return Args{}, fmt.Errorf("error parsing triggerPeriod %s", err)
	}

	return Args{
		bootstrapServers:  os.Args[1],
		clickhouseServers: os.Args[2],
		bufferSize:        bufferSize,
		triggerThreshold:  triggerThreshold,
		triggerPeriod:     time.Duration(triggerPeriod) * time.Millisecond,
	}, nil
}

func newDialer() *kafka.Dialer {
	hostname, err := os.Hostname()
	if err != nil {
		log.Println("error retrieving hostname, using 'default' as defaut host name")
		hostname = uuid.New().String()
	}
	return &kafka.Dialer{
		ClientID:  hostname,
		Timeout:   10 * time.Second,
		DualStack: true,
	}
}

func getKafkaReader(args Args, groupID, topic string, dialer *kafka.Dialer) *kafka.Reader {
	return kafka.NewReader(kafka.ReaderConfig{
		Brokers: strings.Split(args.bootstrapServers, ","),
		GroupID: groupID,
		Topic:   topic,
		Dialer:  dialer,
	})
}

func read(ctx context.Context, args Args, groupID, topic string, dialer *kafka.Dialer, pointsC chan<- *points.PointRecord) {
	wg.Add(1)
	defer wg.Done()

	reader := getKafkaReader(args, groupID, topic, dialer)
	defer reader.Close()

	log.Println("reader ready to read messages")

	for {
		select {
		case <-ctx.Done():
			log.Println("ctx in reader is done")
			return
		default:
			msg, err := reader.ReadMessage(ctx)
			if err != nil {
				log.Println("error in reader:", err.Error())
				continue
			}

			var points points.Points
			err = proto.Unmarshal(msg.Value, &points)
			if err != nil {
				log.Println("error when unmarshalling:", err.Error())
				continue
			}
			for _, point := range points.PointRecords {
				pointsC <- point
			}
		}
	}
}

// insert data in clickhouse when
func insert(ctx context.Context, args Args, conn driver.Conn, pointsC <-chan *points.PointRecord) error {
	insertC := make(chan struct{})
	defer close(insertC)

	ticker := time.NewTicker(args.triggerPeriod)
	defer ticker.Stop()

	batch, err := conn.PrepareBatch(ctx, "INSERT INTO points")
	if err != nil {
		return err
	}
	defer batch.Abort()

	go func() {
		for {
			select {
			case <-insertC:
				rows := batch.Rows()
				if rows != 0 {
					err := batch.Send()
					if err != nil {
						log.Println("error when inserting: ", err)
					}
					log.Printf("clickhouse: inserted %d rows\n", rows)

					batch, err = conn.PrepareBatch(ctx, "INSERT INTO points")
					if err != nil {
						log.Println("error in batch: ", err)
					}
					defer batch.Abort()
				}
				ticker.Reset(args.triggerPeriod)
			}
		}
	}()

	for {
		select {
		case <-ctx.Done():
			insertC <- struct{}{}
			log.Println("ctx in inserter is done")
			return nil

		case point := <-pointsC:
			err := batch.Append(
				point.Time.Seconds,
				point.Latitude,
				point.Longitude,
				point.Prediction,
			)
			if err != nil {
				return err
			}
			if batch.Rows() >= args.triggerThreshold {
				insertC <- struct{}{}
			}

		case <-ticker.C:
			insertC <- struct{}{}
		}
	}
}

func newClickhouseConn(ctx context.Context, args Args) (driver.Conn, error) {
	conn, err := clickhouse.Open(&clickhouse.Options{
		Addr: []string{args.clickhouseServers},
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

	log.Println("clickhouse: connection established")

	return conn, nil
}

func main() {
	const groupID = "points-group"
	const topic = "points"

	ctx, cancel := signal.NotifyContext(context.Background(), os.Interrupt)
	defer cancel()

	args, err := processEnvironment()
  log.Println(fmt.Sprintf("%+v", args))
	if err != nil {
		log.Fatal("failed to process environment:", err)
	}

	dialer := newDialer()

	clickConn, err := newClickhouseConn(ctx, args)
	if err != nil {
		log.Fatal("error when creating connection:", err)
	}
  defer clickConn.Close()

	pointsC := make(chan *points.PointRecord, args.bufferSize)

	// start read and insert goroutines
	go read(ctx, args, groupID, topic, dialer, pointsC)
	go insert(ctx, args, clickConn, pointsC)

	<-ctx.Done()
	log.Println("interrupt signal received. graceful shutdown")
	wg.Wait()
	log.Println("done")
}
