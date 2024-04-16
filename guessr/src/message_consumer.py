import kafka
import time
from dataclasses import dataclass
from kafka import errors as kafka_errors
import multiprocessing as mp
import multiprocessing.pool as mp_pool
import signal


@dataclass
class MsgConsumerCfg:
    topic: str
    servers: str
    group_id: str
    client_id: str
    pool_size: int
    shutdown_timeout: int


class LimitedMultiprocessingPool(mp_pool.Pool):
    pass


class MsgConsumer:
    def __init__(self, consumer_func, cfg: MsgConsumerCfg):
        self.consumer_func = consumer_func

        self.consumer = kafka.KafkaConsumer(
            cfg.topic,
            auto_offset_reset="latest",
            enable_auto_commit=True,
            bootstrap_servers=cfg.servers,
            group_id=cfg.group_id,
            client_id=cfg.client_id,
        )

        self.stop_processing = False
        self.pool = LimitedMultiprocessingPool(processes=cfg.pool_size)
        self.shutdown_timeout = cfg.shutdown_timeout

        signal.signal(signal.SIGTERM, self.set_stop_processing)

    def set_stop_processing(self, *args, **kwargs):
        self.stop_processing = True

    def main_loop(self):
        while not self.stop_processing:
            for msg in self.consumer:
                if self.stop_processing:
                    break

                # only works with top-level functions
                self.pool.apply_async(self.consumer_func, (msg,))

                try:
                    self.consumer.commit()
                # on rebalance
                except kafka_errors.CommitFailedError:
                    continue

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
