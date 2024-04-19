from dataclasses import dataclass
import confluent_kafka

@dataclass
class KafkaProducerCfg:
    topic: str
    servers: str

def delivery_report(err, msg):
    if err is not None:
        print('Message delivery failed: {}'.format(err))
    else:
        print('Message delivered to {} [{}]'.format(msg.topic(), msg.partition()))


class KafkaProducer:
    def __init__(self, cfg: KafkaProducerCfg):
        self.producer = confluent_kafka.Producer({
            'bootstrap.servers': cfg.servers
            })
        self.topic = cfg.topic

    def send(self, data):
        print('send')
        return self.producer.produce(self.topic, data, callback=delivery_report)

    def graceful_shutdown(self):
        try:
            self.producer.close()
        except Exception as ex:
            raise ex

    def flush(self):
        return self.producer.flush()
