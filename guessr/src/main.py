import sys
import socket
import pandas
import logging
from datetime import datetime, timezone
from lib.kafka_consumer import KafkaConsumer, KafkaConsumerCfg
from lib.kafka_producer import KafkaProducer, KafkaProducerCfg
import processing
from collections import namedtuple

import lib.proto.monitoring.monitoring_pb2 as monitoring
from lib.proto.monitoring.monitoring_pb2 import (
    Monitoring,
    AccelerometerRecord,
    GyroscopeRecord,
    GpsRecord,
)
from lib.proto.util_pb2 import Timestamp
from lib.proto.points.points_pb2 import Points, PointRecord


InputArgs = namedtuple("InputArgs", ["bootstrap_servers"])

logger: logging.Logger
producer: KafkaProducer


def kafka_to_timestamp(date):
    # .replace(microsecond=date%1000*1000)
    return datetime.fromtimestamp(date // 1000, tz=timezone.utc)


def get_pretty_kafka_log(message, data: monitoring.Monitoring, time, topic):
    string = f"NETWORK[{time}]: Topic '{topic}'"
    string += f"\n\toffset: {message.offset}, size: {len(message.value)} bytes"
    string += f"\n\tAccount id: {data.account.accound_id}, name: {data.account.name}"
    string += f"\n\tAccelerometer: {len(data.accelerometer_records)} recs"
    string += f"\n\tGyroscope: {len(data.gyroscope_records)} recs"
    string += f"\n\tGps: {len(data.gps_records)} recs"
    return string


def string_to_timestamp_int(time):
    return int(datetime.fromisoformat(time).timestamp() * 1000000)


def proto_to_timestamp_int(time: Timestamp):
    return int(time.seconds * 1000000 + time.nanos)


def proto_accelerometer_to_dict(record: AccelerometerRecord):
    return (proto_to_timestamp_int(record.time), record.x, record.y, record.z)


def proto_gyroscope_to_dict(record: GyroscopeRecord):
    return (proto_to_timestamp_int(record.time), record.x, record.y, record.z)


def proto_gps_to_dict(record: GpsRecord):
    return (proto_to_timestamp_int(record.time), record.latitude, record.longitude)


# 1) convert protobuf objects to inputs
# 2) filter inappropriate entries (NOTE: fixed on producers)
def get_raw_filtered_inputs(message: Monitoring):
    acDf = pandas.DataFrame.from_records(
        map(proto_accelerometer_to_dict, message.accelerometer_records),
        columns=["time", "x", "y", "z"],
    )
    gyDf = pandas.DataFrame.from_records(
        map(proto_gyroscope_to_dict, message.gyroscope_records),
        columns=["time", "x", "y", "z"],
    )
    gpsDf = pandas.DataFrame.from_records(
        map(proto_gps_to_dict, message.gps_records),
        columns=["time", "latitude", "longitude"],
    )

    return (acDf, gyDf, gpsDf)


def consumer_func(msg):
    try:
        time = kafka_to_timestamp(msg.timestamp)

        proto = Monitoring()
        proto.ParseFromString(msg.value)
        # logger.debug(get_pretty_kafka_log(msg, proto, time, "monitoring"))

        (acDf, gyDf, gpsDf) = get_raw_filtered_inputs(proto)
        (acDfn, gyDfn) = processing.reduce_noice(acDf, gyDf)
        (acDfi, gyDfi, gpsDfi) = processing.interpolate(acDfn, gyDfn, gpsDf)

        # print(acDfi, gyDfi, gpsDfi, sep="\n")
        # print("\n\n")

        pointArray = gpsDf.to_dict("records")
        points = Points()
        points.point_records.extend(map(dict_to_point_record, pointArray))
        produce(points)

    except Exception as e:
        logger.error(e)


def dict_to_point_record(d):
    point = PointRecord()
    point.latitude = d["latitude"]
    point.longitude = d["longitude"]
    point.prediction = 0.2
    point.time.seconds = d["time"] // 1000000
    point.time.nanos = d["time"] % 1000000
    return point


def produce(points: Points):
    producer.send(points.SerializeToString())
    producer.flush()


def process_arguments() -> InputArgs:
    if len(sys.argv) < 2:
        print("bootstrap servers are not passed")
        exit(-1)

    return InputArgs(bootstrap_servers=sys.argv[1])


if __name__ == "__main__":
    logging.basicConfig()
    logger = logging.getLogger("main")
    logger.setLevel(logging.DEBUG)

    args = process_arguments()

    cfg = KafkaConsumerCfg(
        topic="monitoring",
        servers=args.bootstrap_servers,
        group_id="guessr-group",
        client_id=socket.gethostname(),
        pool_size=1,
        shutdown_timeout=10,
    )

    producer_cfg = KafkaProducerCfg(
        topic="points",
        servers=args.bootstrap_servers.split(","),
    )

    producer = KafkaProducer(producer_cfg)
    produce(Points())
    consumer = KafkaConsumer(consumer_func, cfg)

    consumer.main_loop()
