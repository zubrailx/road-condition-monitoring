#!/bin/bash

/etc/confluent/docker/run &

cub kafka-ready -b kafka1:9092 1 20 && \
   kafka-topics --bootstrap-server PLAINTEXT://kafka1:9092 --create --if-not-exists --partitions 1 --replication-factor 1 --topic monitoring

tail -f /dev/null
