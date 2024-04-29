import pickle
import numpy as np

class Predictor:
  def __init__(self, model_fpath: str):
    with open(model_fpath, "rb") as file:
      self.clf = pickle.load(file)

  def predict_one(self, inputs: np.array):
    return self.clf.predict([inputs])[0]
  
  def predict(self, X):
    return self.clf.predict(X)