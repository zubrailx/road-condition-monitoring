import sys
from kafka import KafkaConsumer
from datetime import datetime

import common.model.gen.monitoring.monitoring_pb2 as monitoring

TOPIC = "monitoring"
GROUP_ID = "guessr-group"
AUTO_OFFSET_RESET = "latest"

def kafka_to_timestamp(date):
# .replace(microsecond=date%1000*1000)
    return datetime.utcfromtimestamp(date//1000);

def get_pretty_kafka_log(message, data: monitoring.Monitoring):
    string = f"NETWORK[{time}]: Topic '{TOPIC}', offset: {message.offset}, size: {len(message.value)} bytes." 
    string += f"\n\tAccount id: {data.account.accound_id}, name: {data.account.name}."
    string += f"\n\tAccelerometer: {len(data.accelerometer_records)} recs"
    string += f"\n\tGyroscope: {len(data.gyroscope_records)} recs"
    string += f"\n\tGps: {len(data.gps_records)} recs"
    return string


if len(sys.argv) < 2:
    print("host args are not passed")
    exit(-1)

BOOTSTRAP_SERVERS = sys.argv[1] # localhost:9092

consumer = KafkaConsumer(
    TOPIC,
    bootstrap_servers=[BOOTSTRAP_SERVERS],
    auto_offset_reset=AUTO_OFFSET_RESET,
    enable_auto_commit=True,
    group_id=GROUP_ID,
)

for message in consumer:
    time = kafka_to_timestamp(message.timestamp);
    data = monitoring.Monitoring()
    data.ParseFromString(message.value)
    print(get_pretty_kafka_log(message, data))

