from dataclasses import dataclass
import kafka


@dataclass
class KafkaProducerCfg:
    topic: str
    servers: list[str]


def on_send_success(record_metadata):
    print(record_metadata.topic)
    print(record_metadata.partition)
    print(record_metadata.offset)


def on_send_error(excp):
    print("I am an errback", excp)


class KafkaProducer:
    def __init__(self, cfg: KafkaProducerCfg):
        self.producer = kafka.KafkaProducer(bootstrap_servers=cfg.servers)
        self.topic = cfg.topic

    def send(self, data):
        return (
            self.producer.send(self.topic, data)
            .add_callback(on_send_success)
            .add_errback(on_send_error)
        )

    def graceful_shutdown(self):
        try:
            self.producer.close()
        except Exception as ex:
            raise ex

    def flush(self):
        return self.producer.flush()
