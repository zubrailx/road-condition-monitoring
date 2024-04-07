import sys
from kafka import KafkaConsumer

import common.model.gen.monitoring.monitoring_pb2 as monitoring

TOPIC = "monitoring"
GROUP_ID = "guessr-group"
AUTO_OFFSET_RESET = "latest"

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
    data = monitoring.Monitoring()
    data.ParseFromString(message.value)
    print("Offset:", message.offset)
