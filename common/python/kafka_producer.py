from dataclasses import dataclass
import logging
import kafka

log = logging.getLogger("kafka_producer")


@dataclass
class KafkaProducerCfg:
    topic: str
    servers: list[str]


def on_send_success(record_metadata):
    log.debug(
        f"Send SUCCESS: "
        f"topic {record_metadata.topic}, partition {record_metadata.partition}, offset {record_metadata.offset}"
    )


def on_send_error(excp):
    log.debug("Send ERROR: I am an errback", excp)


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
