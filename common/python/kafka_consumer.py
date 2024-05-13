from threading import Semaphore
from typing import Optional
import kafka
from dataclasses import dataclass
from kafka import errors as kafka_errors
import signal
import time
import logging
import multiprocessing
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

def with_semaphore(func):
    def execute(semaphore, *args):
        semaphore.acquire()
        func(*args)
        semaphore.release()
    return execute

class LimitedMultiprocessingPool(mp_pool.Pool):
    pass

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
        self.semaphore = multiprocessing.Semaphore(cfg.pool_cache_limit)
        self.callback = callback
        self.shutdown_timeout = cfg.shutdown_timeout

        signal.signal(signal.SIGTERM, self.set_stop_processing)

    def set_stop_processing(self, *args, **kwargs):
        self.stop_processing = True

    def callback_release(self):
        def release(*args):
            self.callback(*args)
            self.semaphore.release()
        return release

    def error_callback_release(self):
        def release(*args):
            log.error(args)
            self.semaphore.release()
        return release

    def main_loop(self):
        while not self.stop_processing:
            for msg in self.consumer:
                if self.stop_processing:
                    break

                log.debug("data read from topic 'msg.topic'")

                self.semaphore.acquire()
                print('received')

                self.pool.apply_async(
                    self.consumer_func, 
                    (msg,), 
                    callback=self.callback_release(),
                    error_callback=self.error_callback_release()
                )

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
