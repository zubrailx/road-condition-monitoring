import time
from dataclasses import dataclass
import multiprocessing as mp
import multiprocessing.pool as mp_pool
import signal

import confluent_kafka


@dataclass
class KafkaConsumerCfg:
    topic: str
    servers: str
    group_id: str
    client_id: str
    pool_size: int
    shutdown_timeout: int


class LimitedMultiprocessingPool(mp_pool.Pool):
    pass


class KafkaConsumer:
    def __init__(self, consumer_func, cfg: KafkaConsumerCfg):
        self.consumer_func = consumer_func

        self.consumer = confluent_kafka.Consumer(
            {
                "bootstrap.servers": cfg.servers,
                "group.id": cfg.group_id,
                "auto.offset.reset": "earliest",
            }
        )

        self.stop_processing = False
        self.pool = LimitedMultiprocessingPool(processes=cfg.pool_size)
        self.shutdown_timeout = cfg.shutdown_timeout

        signal.signal(signal.SIGTERM, self.set_stop_processing)

        self.consumer.subscribe([cfg.topic])

    def set_stop_processing(self, *args, **kwargs):
        self.stop_processing = True

    def main_loop(self):
        while not self.stop_processing:
            msg = self.consumer.poll(1.0)

            if msg is None:
                continue

            if msg.error():
                print("consumer error", msg.error)

            print('msg', msg)
            self.pool.apply_async(self.consumer_func, (msg,))

    def graceful_shutdown(self):
        try:
            self.consumer.close()
            self.pool.close()
            graceful_shutdown_end = time.time() + self.shutdown_timeout
            while graceful_shutdown_end > time.time():
                active_child_proc_num = len(mp.active_children())
                if active_child_proc_num == 0:
                    break
                time.sleep(0.1)
            else:
                raise
        except Exception as ex:
            self.pool.terminate()
            raise ex
        finally:
            self.pool.join()
            self.set_stop_processing()
