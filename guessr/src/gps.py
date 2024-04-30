from math import radians, sin, cos, sqrt, atan2
import numpy

import constants

def haversine_m(lat1, lon1, lat2, lon2):
    lat1, lon1, lat2, lon2 = map(radians, [lat1, lon1, lat2, lon2])

    dlat = lat2 - lat1
    dlon = lon2 - lon1
    a = sin(dlat / 2) ** 2 + cos(lat1) * cos(lat2) * sin(dlon / 2) ** 2
    c = 2 * atan2(sqrt(a), sqrt(1 - a))
    distance = 6371000 * c  # Radius of the earth in m
    return distance


def calculate_speed(gpsDf):
  speeds = numpy.zeros(len(gpsDf))
  prevGpsE = None
  for i, gpsE in gpsDf.iterrows():
    if prevGpsE is not None:
      lat1, lon1, lat2, lon2 = prevGpsE['latitude'], prevGpsE['longitude'], gpsE['latitude'], gpsE['longitude']
      distance = haversine_m(lat1, lon1, lat2, lon2)
      
      diff_time_seconds = (gpsE['time'] - prevGpsE['time']) / constants.second
      speed = distance / diff_time_seconds
      speeds[i] = speed
    prevGpsE = gpsE
  
  if len(gpsDf) > 1:
     speeds[0] = speeds[1]

  return speeds