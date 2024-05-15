package main

import (
	"context"
	"fmt"
	"log"
	"os"
	"os/signal"
	"strconv"
	"strings"
	"time"

	points "points-consumer/internal/proto/points"

	"github.com/ClickHouse/clickhouse-go/v2"
	"github.com/ClickHouse/clickhouse-go/v2/lib/driver"
	"github.com/google/uuid"
	"github.com/segmentio/kafka-go"
	"golang.org/x/sync/errgroup"
	"google.golang.org/protobuf/proto"
)

type Args struct {
	bootstrapServers  string
	clickhouseServers string
	bufferSize        int
	bufferLogPeriod   time.Duration
	triggerThreshold  int
	triggerPeriod     time.Duration
}

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
	bufferLogPeriod, err := strconv.Atoi(getEnvDefault("PC_BUFFER_LOG_PERIOD", "0"))
	if err != nil {
		return Args{}, fmt.Errorf("error parsing bufferLogPeriod %s", err)
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
		bufferLogPeriod:   time.Duration(bufferLogPeriod) * time.Millisecond,
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

func read(ctx context.Context, args Args, groupID, topic string, dialer *kafka.Dialer, pointsC chan<- *points.PointRecord) error {
	reader := getKafkaReader(args, groupID, topic, dialer)
	defer reader.Close()

	for {
		select {
		case <-ctx.Done():
			return nil
		default:
			msg, err := reader.ReadMessage(ctx)
			if err != nil {
				return err
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
	timer := time.NewTimer(args.triggerPeriod)
	defer timer.Stop()

	batch, err := conn.PrepareBatch(ctx, "INSERT INTO points")
	if err != nil {
		return err
	}

	for {
		isDone := false
		isThreshold := false
		isTimed := false

		select {
		case <-ctx.Done():
			isDone = true

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
				isThreshold = true
			}

		case <-timer.C:
			isTimed = true
		}

		if isTimed || isThreshold || isDone {
			rows := batch.Rows()
			if rows != 0 {
				err := batch.Send()
				if err != nil {
					return fmt.Errorf("error when inserting: %s", err)
				}
				log.Printf("clickhouse: inserted %d rows\n", rows)

				batch, err = conn.PrepareBatch(ctx, "INSERT INTO points")
				if err != nil {
					return err
				}
			}

			if !timer.Stop() && !isTimed {
				<-timer.C
			}
			timer.Reset(args.triggerPeriod)

			if isDone {
				break
			}
		}
	}
	return nil
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
	group, ctx := errgroup.WithContext(ctx)

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
	defer close(pointsC)

	if args.bufferLogPeriod > 0 {
		go func() {
			bufferTicker := time.NewTicker(args.bufferLogPeriod)
			defer bufferTicker.Stop()

			for {
				select {
				case <-ctx.Done():
					return

				case <-bufferTicker.C:
					log.Printf("current buffer size: %d\n", len(pointsC))
					bufferTicker.Reset(args.bufferLogPeriod)
				}
			}
		}()
	}

	// start read and insert goroutines
	group.Go(func() error {
		return read(ctx, args, groupID, topic, dialer, pointsC)
	})

	group.Go(func() error {
		return insert(ctx, args, clickConn, pointsC)
	})

	if err := group.Wait(); err != nil {
		log.Println(err.Error())
    os.Exit(1)
	}
}
