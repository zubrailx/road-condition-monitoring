import sys
import os
import pandas
import logging
import traceback
from datetime import datetime, timezone
from lib.kafka_consumer import KafkaConsumerCfg
from lib.kafka_producer import KafkaProducer, KafkaProducerCfg
import processing, interpolation, prediction, constants, gps
from collections import namedtuple
from lib.proto.points.points_pb2 import Points, PointRecord
import json
import pandas as pd


InputArgs = namedtuple("InputArgs", ["bootstrap_servers", "model_path", "features_path", "points_path"])

logger: logging.Logger
producer: KafkaProducer

selector: processing.FeatureSelector

MODEL_PATH = "model/tree-cart-features-24.pickle"
FEATURE_SELECTION_PATH = "model/selected-features-24.json"
POINTS_PATH = "data/pvs-points/raw"

def get_raw_filtered_inputs(message):
    acDf = pandas.DataFrame.from_records(
        message["accelerometer"],
        columns=["time", "x", "y", "z"],
    )
    gyDf = pandas.DataFrame.from_records(
        message["gyroscope"],
        columns=["time", "x", "y", "z"],
    )
    gpsDf = pandas.DataFrame.from_records(
        [message.gps_records],
        columns=["time", "latitude", "longitude"],
    )

    return (acDf, gyDf, gpsDf)


def point_result_to_record(d):
    point = PointRecord()
    point.prediction = d[0]
    point.latitude = d[1]["latitude"]
    point.longitude = d[1]["longitude"]
    point.time.seconds = d[1]["time"] // constants.second
    point.time.nanos = d[1]["time"] % constants.second
    # print(point.prediction)
    return point

def getenv_or_default(key, default):
    value = os.getenv(key)
    if value is None:
        return default
    return value


def read_entry(entry_fpath):
    with open(entry_fpath) as file:
        data = json.load(file)
        acDf = pd.DataFrame.from_records(data["accelerometer"])
        gyDf = pd.DataFrame.from_records(data["gyroscope"])
        gpsDf = data["gps"]
        prediction = data["prediction"]
        return (acDf, gyDf, gpsDf, prediction)

def process_arguments() -> InputArgs:
    if len(sys.argv) < 2:
        print("bootstrap servers are not passed")
        exit(-1)

    model_path = getenv_or_default("GPI_MODEL_PATH", MODEL_PATH)
    features_path = getenv_or_default("GPI_FEATURE_SELECTION_PATH", FEATURE_SELECTION_PATH)
    points_path = getenv_or_default("GPI_POINTS_PATH", POINTS_PATH)

    return InputArgs(bootstrap_servers=sys.argv[1], model_path=model_path, features_path=features_path, points_path=points_path)


if __name__ == "__main__":
    logging.basicConfig()
    logger = logging.getLogger("main")
    logger.setLevel(logging.DEBUG)

    args = process_arguments()

    selector = processing.FeatureSelector(args.features_path)
    predictor = prediction.Predictor(args.model_path)

    producer_cfg = KafkaProducerCfg(
        topic="points",
        servers=args.bootstrap_servers.split(","),
    )
    producer = KafkaProducer(producer_cfg)

    entry_fpaths = [os.path.join(args.points_path, x) for x in os.listdir(args.points_path)]
    for entry_fpath in entry_fpaths:
        (acDf, gyDf, gpsDf, pred) = read_entry(entry_fpath)
        gpsDf["time"] = int(datetime.now().timestamp()  * constants.second)

        points = Points()
        point_results = []

        acDfn, gyDfn = processing.reduce_noice(acDf, gyDf)
        features = processing.extract_features(acDfn, gyDfn, gpsDf)
        selected_features = selector.select_features(features)
        pred = predictor.predict_one(selected_features)

        # handle bounds
        if pred < 0:
            pred = 0.0
        elif pred > 1:
            pred = 1.0

        point_results.append((pred, gpsDf))

        points.point_records.extend(map(point_result_to_record, point_results))
        producer.send(points.SerializeToString())
