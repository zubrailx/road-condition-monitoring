import sys
import os
import socket
import json
import logging
from typing import Any

import pymongo
from datetime import datetime, timezone
from collections import namedtuple
from google.protobuf.json_format import MessageToDict

from lib.kafka_consumer import KafkaConsumer, KafkaConsumerCfg
from lib.proto.monitoring.monitoring_pb2 import Monitoring

Socket = namedtuple("Socket", "address port")
InputArgs = namedtuple(
    "InputArgs", ["bootstrap_servers", "mongo_socket", "username", "password"]
)

mongo_client: pymongo.MongoClient
database: Any
collection: Any

logger: logging.Logger


def process_arguments() -> InputArgs:
    try:
        username = os.environ.get("MK_MONGO_USERNAME", "admin")
        password = os.environ.get("MK_MONGO_PASSWORD", "pass")
        bootstrap_servers = sys.argv[1]
        mongo_address, mongo_port = sys.argv[2].split(":")
    except ValueError:
        raise ValueError(f"Look in process_argument() for valid argument passing")

    return InputArgs(
        bootstrap_servers=bootstrap_servers,
        mongo_socket=Socket(address=mongo_address, port=int(mongo_port)),
        username=username,
        password=password,
    )


def mongo_get_client(address, port, username, password):
    mongo_connection_str = f"mongodb://{address}:{port}/"
    mongo_client = pymongo.MongoClient(
        mongo_connection_str, username=username, password=password
    )
    return mongo_client


def kafka_to_timestamp(date):
    return datetime.fromtimestamp(date // 1000, tz=timezone.utc).replace(
        microsecond=date % 1000 * 1000
    )


def consumer_func(msg):
    print(msg)
    print(msg.timestamp())
    # try:
        # time = kafka_to_timestamp(msg.timestamp)

        # proto = Monitoring()
        # proto.ParseFromString(msg.value)

        # data = {
        #     "body": MessageToDict(proto),
        #     "time_insert": time,
        #     "time_access": None,
        # }

        # collection.insert_one(data)

    # except Exception as e:
    #     logger.error(e)


if __name__ == "__main__":
    logging.basicConfig()
    logger = logging.getLogger("main")
    logger.setLevel(logging.DEBUG)

    args = process_arguments()

    mongo_client = mongo_get_client(
        args.mongo_socket.address, args.mongo_socket.port, args.username, args.password
    )

    database = mongo_client["data"]
    collection = database["monitoring"]

    collection.create_index(
        {
            "time_insert": 1,  # time of insertion
        }
    )
    collection.create_index(
        {
            "time_access": 1,  # time of last access
            "time_insert": 1
        }
    )

    cfg = KafkaConsumerCfg(
        topic="monitoring",
        servers=args.bootstrap_servers,
        group_id="keeper-group",
        client_id=socket.gethostname(),
        pool_size=2,
        shutdown_timeout=10,
    )

    consumer = KafkaConsumer(consumer_func, cfg)
    consumer.main_loop()
