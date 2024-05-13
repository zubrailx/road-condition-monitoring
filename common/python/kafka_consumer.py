from typing import Optional
import kafka
from dataclasses import dataclass
from kafka import errors as kafka_errors
import signal
import time
import logging
import multiprocessing.pool as mp_pool

log = logging.getLogger("kafka_consumer")

@dataclass
class KafkaConsumerCfg:
    auto_offset_reset: str
    topics: list[str]
    servers: str
    group_id: str
    pool_size: int
    shutdown_timeout: int
    pool_cache_limit: int = 100


class LimitedMultiprocessingPool(mp_pool.Pool):
    def get_pool_cache_size(self):
        return len(self._cache)


class KafkaConsumer:
    def __init__(self, cfg: KafkaConsumerCfg, consumer_func, initializer, callback):
        self.consumer_func = consumer_func

        self.consumer = kafka.KafkaConsumer(
            *cfg.topics,
            auto_offset_reset=cfg.auto_offset_reset,
            enable_auto_commit=False,
            bootstrap_servers=cfg.servers,
            group_id=cfg.group_id,
        )

        self.stop_processing = False
        self.pool = LimitedMultiprocessingPool(processes=cfg.pool_size, initializer=initializer)
        self.callback = callback
        self.shutdown_timeout = cfg.shutdown_timeout
        self.pool_cache_limit = cfg.pool_cache_limit

        signal.signal(signal.SIGTERM, self.set_stop_processing)

    def set_stop_processing(self, *args, **kwargs):
        self.stop_processing = True

    def handle_pool_cache_excess(self):
        size = self.pool.get_pool_cache_size()
        while size >= self.pool_cache_limit:
            log.debug(f'waiting until {size} >= {self.pool_cache_limit}')
            time.sleep(0.2) # if cache exceeds - sleep

    def main_loop(self):
        while not self.stop_processing:
            for msg in self.consumer:
                if self.stop_processing:
                    break

                self.handle_pool_cache_excess()
                log.debug("data read from topic 'msg.topic'")
                self.pool.apply_async(self.consumer_func, (msg,), callback=self.callback)

                try:
                    self.consumer.commit()
                # on rebalance
                except kafka_errors.CommitFailedError:
                    continue

    def graceful_shutdown(self):
        try:
            self.consumer.close()
            self.pool.close()
        except Exception as ex:
            self.pool.terminate()
            raise ex
        finally:
            self.pool.join()
            self.set_stop_processing()
