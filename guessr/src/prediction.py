import pickle
import numpy as np

class Predictor:
  def __init__(self, model_fpath: str):
    self.clf = pickle.load(model_fpath)

  def predict_one(self, inputs: np.array):
    return self.clf.predict([inputs])
  
  def predict(self, X):
    return self.clf.predict(X)