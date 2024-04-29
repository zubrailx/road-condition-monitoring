import kafka
import concurrent.futures
import time
from dataclasses import dataclass
from kafka import errors as kafka_errors
import multiprocessing as mp
import signal
import logging

log = logging.getLogger("kafka_consumer")

@dataclass
class KafkaConsumerCfg:
    auto_offset_reset: str
    topics: list[str]
    servers: str
    group_id: str
    pool_size: int
    shutdown_timeout: int


class LimitedThreadPool(concurrent.futures.ThreadPoolExecutor):
    pass


class KafkaConsumer:
    def __init__(self, consumer_func, cfg: KafkaConsumerCfg):
        self.consumer_func = consumer_func

        self.consumer = kafka.KafkaConsumer(
            *cfg.topics,
            auto_offset_reset=cfg.auto_offset_reset,
            enable_auto_commit=False,
            bootstrap_servers=cfg.servers,
            group_id=cfg.group_id,
        )

        self.stop_processing = False
        self.pool = LimitedThreadPool(max_workers=cfg.pool_size)
        self.shutdown_timeout = cfg.shutdown_timeout

        signal.signal(signal.SIGTERM, self.set_stop_processing)

    def set_stop_processing(self, *args, **kwargs):
        self.stop_processing = True

    def main_loop(self):
        while not self.stop_processing:
            for msg in self.consumer:
                if self.stop_processing:
                    break

                log.debug("data read from topic 'msg.topic'")
                # only works with top-level functions
                self.pool.submit(self.consumer_func, msg)

                try:
                    self.consumer.commit()
                # on rebalance
                except kafka_errors.CommitFailedError:
                    continue

    def graceful_shutdown(self):
        try:
            self.consumer.close()
            graceful_shutdown_end = time.time() + self.shutdown_timeout
            while graceful_shutdown_end > time.time():
                active_child_proc_num = len(mp.active_children())
                if active_child_proc_num == 0:
                    break
                time.sleep(0.1)
            else:
                raise
        except Exception as ex:
            raise ex
        finally:
            self.pool.shutdown(wait=True)
            self.set_stop_processing()
