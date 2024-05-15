from kafka import KafkaProducer, KafkaConsumer
from kafka.errors import KafkaError

producer = KafkaProducer(bootstrap_servers=['localhost:9092'])
consumer = KafkaConsumer('monitoring', group_id='test-consumer', bootstrap_servers="localhost:9092")


for msg in consumer:
    print(len(msg.value))
    future = producer.send('points', b'some data')
    try:
        record_metadata = future.get(timeout=10)
    except KafkaError:
        print('error')
        pass
