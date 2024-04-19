package main

import (
	"context"
	"fmt"
	"log"
	"os"
	"os/signal"
	"strings"
	"sync"
	"time"

	"github.com/google/uuid"
	"github.com/segmentio/kafka-go"
  "google.golang.org/protobuf/proto"
	monitoring "points-consumer/lib/proto/monitoring"
)

type Args struct {
	bootstrapServers string
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
	if len(os.Args) < 2 {
		return Args{}, fmt.Errorf("arg len should be equal 2")
	}

	return Args{
		bootstrapServers: os.Args[1],
	}, nil
}

func newDialer() *kafka.Dialer {
	hostname, err := os.Hostname()
	if err != nil {
		log.Println("error retrieving hostname, using 'default' as defaut host name")
		hostname = uuid.New().String()
	}
	return &kafka.Dialer{
		ClientID: hostname,
		Timeout:  10 * time.Second,
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

func read(ctx context.Context, args Args, groupID, topic string, dialer *kafka.Dialer) {
	wg.Add(1)
	defer wg.Done()

	reader := getKafkaReader(args, groupID, topic, dialer)
	defer reader.Close()

	log.Println("reader reading messages")

	for {
		msg, err := reader.ReadMessage(ctx)
		if err != nil {
			log.Println("error in reader:", err.Error())
			break
		}

		var data monitoring.Monitoring

		err = proto.Unmarshal(msg.Value, &data)
    if err != nil {
      log.Println("error when unmarshalling:", err.Error())
      break
    }

		log.Println(data.String())
	}

}

func main() {
	const groupID = "points-group"
	const topic = "points"

	ctx, cancel := signal.NotifyContext(context.Background(), os.Interrupt)
	defer cancel()

	args, err := processEnvironment()
	if err != nil {
		log.Fatal("failed to process environment:", err)
	}

	dialer := newDialer()
	go read(ctx, args, groupID, topic, dialer)

	<-ctx.Done()
	log.Println("interrupt signal received. graceful shutdown")
	wg.Wait()
	log.Println("done")
}
