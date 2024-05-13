from typing import Any
from paho.mqtt.enums import CallbackAPIVersion
import pymongo
from datetime import datetime
import os
import logging
import paho.mqtt.client as mqtt
import sys
from collections import namedtuple
from lib.proto.monitoring.monitoring_pb2 import Monitoring
from google.protobuf.json_format import ParseDict


Socket = namedtuple("Socket", "address port")
InputArgs = namedtuple(
    "InputArgs", ["mongo_socket", "username", "password", "mqtt_socket"]
)

database: Any
collection: Any

logger: logging.Logger


def process_arguments() -> InputArgs:
    try:
        username = os.environ.get("MK_MONGO_USERNAME", "admin")
        password = os.environ.get("MK_MONGO_PASSWORD", "pass")
        mongo_address, mongo_port = sys.argv[1].split(":")
        mqtt_address, mqtt_port = sys.argv[2].split(":")
    except ValueError:
        raise ValueError(f"Look in process_argument() for valid argument passing")

    return InputArgs(
        mongo_socket=Socket(address=mongo_address, port=int(mongo_port)),
        username=username,
        password=password,
        mqtt_socket=Socket(address=mqtt_address, port=int(mqtt_port))
    )


def mongo_get_client(address, port, username, password):
    mongo_connection_str = f"mongodb://{address}:{port}/"
    mongo_client = pymongo.MongoClient(
        mongo_connection_str, username=username, password=password
    )
    return mongo_client

def on_connect(client, userdata, flags, rc):
    print("Mqtt connected with result code " + str(rc))

def mqtt_get_client(address, port):
    client = mqtt.Client(CallbackAPIVersion.VERSION2)
    client.on_connect = on_connect
    client.connect(address, port)
    return client

def document_to_monitoring(data):
    return ParseDict(data['body'], Monitoring())


if __name__ == "__main__":
    logging.basicConfig()
    logger = logging.getLogger("main")
    logger.setLevel(logging.DEBUG)

    args = process_arguments()

    mongo_client = mongo_get_client(
        args.mongo_socket.address, args.mongo_socket.port, args.username, args.password
    )

    mqtt_client = mqtt_get_client(args.mqtt_socket.address, args.mqtt_socket.port)

    database = mongo_client["data"]
    collection = database["monitoring"]

    time = datetime.now()
    print(time)

    cursor = collection.find({})

    cnt = 0
    for document in cursor:
        monitoring = document_to_monitoring(document)
        mqtt_client.publish("/monitoring", monitoring.SerializeToString())
        collection.update_one(
            {'_id': document['_id']},
            {'$set': {'time_access': time}}
        )
        cnt += 1

    logger.info(f"Successfully inserted {cnt} messaged to topic monitoring {time.now() - time}")

