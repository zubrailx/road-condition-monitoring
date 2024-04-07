from kafka import KafkaConsumer

import common.model.gen.monitoring.monitoring_pb2 as monitoring

consumer = KafkaConsumer(
    "monitoring",
    bootstrap_servers=["localhost:9092"],
    auto_offset_reset="latest",
    enable_auto_commit=True,
    group_id="guessr-group",
)

for message in consumer:
    data = monitoring.Monitoring()
    data.ParseFromString(message.value)
    print('Offset:', message.offset)
