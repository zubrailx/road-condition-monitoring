from typing import Any
from paho.mqtt.enums import CallbackAPIVersion
import pymongo
from datetime import datetime
import time
import os
import logging
import paho.mqtt.client as mqtt
import sys
from collections import namedtuple
from lib.proto.monitoring.monitoring_pb2 import Monitoring
from google.protobuf.json_format import ParseDict
import multiprocessing.pool as mp_pool
import multiprocessing as mp


Socket = namedtuple("Socket", "address port")
InputArgs = namedtuple(
    "InputArgs", ["mongo_socket", "username", "password", "mqtt_socket", "pool_size"]
)

logger: logging.Logger
start_time: datetime

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

def pool_initializer():
    global mqtt_client, mongo_client
    mqtt_client = mqtt_get_client(args.mqtt_socket.address, args.mqtt_socket.port)
    mongo_client = mongo_get_client(
        args.mongo_socket.address, args.mongo_socket.port, args.username, args.password
    )

def pool_function(document):
    global mqtt_client, mongo_client
    monitoring = document_to_monitoring(document)
    mqtt_client.publish("/monitoring", monitoring.SerializeToString())
    mongo_client["data"]["monitoring"].update_one(
        {'_id': document['_id']},
        {'$set': {'time_access': start_time}}
    )


def process_arguments() -> InputArgs:
    try:
        username = os.environ.get("MI_MONGO_USERNAME", "admin")
        password = os.environ.get("MI_MONGO_PASSWORD", "pass")
        pool_size = os.environ.get("MI_POOL_SIZE", "4")
        mongo_address, mongo_port = sys.argv[1].split(":")
        mqtt_address, mqtt_port = sys.argv[2].split(":")
    except ValueError:
        raise ValueError(f"Look in process_argument() for valid argument passing")

    return InputArgs(
        mongo_socket=Socket(address=mongo_address, port=int(mongo_port)),
        username=username,
        password=password,
        mqtt_socket=Socket(address=mqtt_address, port=int(mqtt_port)),
        pool_size=int(pool_size)
    )

if __name__ == "__main__":
    logging.basicConfig()
    logger = logging.getLogger("main")
    logger.setLevel(logging.DEBUG)

    args = process_arguments()

    parent_mongo_client = mongo_get_client(
        args.mongo_socket.address, args.mongo_socket.port, args.username, args.password
    )

    start_time = datetime.now()
    print(start_time)

    database = parent_mongo_client["data"]
    collection = database["monitoring"]
    cursor = collection.find({})

    pool = mp_pool.Pool(processes=args.pool_size, initializer=pool_initializer)

    pool.map(pool_function, cursor)

    pool.close()
    pool.join()

    logger.info(f"Successfully inserted messaged to topic monitoring {datetime.now() - start_time}")

