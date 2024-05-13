import sys
import os
import logging
from typing import Any

import pymongo
from datetime import datetime
from collections import namedtuple
from google.protobuf.json_format import ParseDict

from lib.kafka_producer import KafkaProducer, KafkaProducerCfg
from lib.proto.monitoring.monitoring_pb2 import Monitoring

Socket = namedtuple("Socket", "address port")
InputArgs = namedtuple(
    "InputArgs", ["bootstrap_servers", "mongo_socket", "username", "password"]
)

producer: KafkaProducer
database: Any
collection: Any

logger: logging.Logger


def mongo_get_client(address, port, username, password):
    mongo_connection_str = f"mongodb://{address}:{port}/"
    mongo_client = pymongo.MongoClient(
        mongo_connection_str, username=username, password=password
    )
    return mongo_client


def document_to_monitoring(data):
    return ParseDict(data['body'], Monitoring())


def process_arguments() -> InputArgs:
    try:
        username = os.environ.get("ML_MONGO_USERNAME", "admin")
        password = os.environ.get("ML_MONGO_PASSWORD", "pass")
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

    producer_cfg = KafkaProducerCfg(
        topic="monitoring-loader",
        servers=args.bootstrap_servers.split(","),
    )

    producer = KafkaProducer(producer_cfg)

    time = datetime.now()
    print(time)

    cursor = collection.find({})

    cnt = 0
    for document in cursor:
        monitoring = document_to_monitoring(document)
        producer.send(monitoring.SerializeToString())
        collection.update_one(
            {'_id': document['_id']},
            {'$set': {'time_access': time}}
        )
        cnt += 1

    producer.flush()
    
    logger.info(f"Successfully inserted {cnt} messaged to topic monitoring")


