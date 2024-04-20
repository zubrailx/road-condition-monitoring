package main

import (
  "net/http"
	"context"
	"fmt"
	"log"
	"os"
	"os/signal"
)

type Args struct {
	clickhouseServers string
}

func processEnvironment() (Args, error) {
	if len(os.Args) < 2 {
		return Args{}, fmt.Errorf("arg len should be equal 2")
	}

	return Args{
		clickhouseServers: os.Args[1],
	}, nil
}

func main() {
	ctx, cancel := signal.NotifyContext(context.Background(), os.Interrupt)
	defer cancel()

	args, err := processEnvironment()
	if err != nil {
		log.Fatalf("failed to process environment: %s", err)
	}

  mux := http.NewServeMux()

  mux.HandleFunc("GET /")



}
