import pandas
import numpy as np

from constants import *

def get_df_time_range(df: pandas.DataFrame):
    l = len(df.index)
    return (df.iloc[0].time, df.iloc[l - 1].time, l)


def get_diff_time(start: int, end: int):
    return end - start


# get interpolated values:
# - (1_000_000/tick) HZ accelerometer, gyroscope
# - ((tick * window * slide)/1_000_000) seconds period GPS
def interpolate(
    acDf: pandas.DataFrame, gyDf: pandas.DataFrame, gpsDf: pandas.DataFrame
):
    acTse = get_df_time_range(acDf)
    gyTse = get_df_time_range(gyDf)
    gpsTse = get_df_time_range(gpsDf)

    minTime = int(max(acTse[0], gyTse[0], gpsTse[0]))
    maxTime = int(min(acTse[1], gyTse[1], gpsTse[1]))

    sensorInterpTimes = np.arange(minTime, maxTime, tick)
    # print(sensorInterpTimes, len(sensorInterpTimes), sep="\n")

    gpsInterpTimes = np.arange(
        minTime + int(tick * window * slide / 2),
        maxTime + int(tick * window * slide / 2),
        int(tick * window * slide),
    )
    # print(gpsInterpTimes, len(gpsInterpTimes), sep="\n")

    acTimes = acDf.time.to_numpy()
    gyTimes = gyDf.time.to_numpy()
    gpsTimes = gpsDf.time.to_numpy()

    acX = acDf.x.to_numpy()
    acY = acDf.y.to_numpy()
    acZ = acDf.z.to_numpy()

    gyX = gyDf.x.to_numpy()
    gyY = gyDf.y.to_numpy()
    gyZ = gyDf.z.to_numpy()

    acXi = np.interp(sensorInterpTimes, acTimes, acX)
    acYi = np.interp(sensorInterpTimes, acTimes, acY)
    acZi = np.interp(sensorInterpTimes, acTimes, acZ)
    gyXi = np.interp(sensorInterpTimes, gyTimes, gyX)
    gyYi = np.interp(sensorInterpTimes, gyTimes, gyY)
    gyZi = np.interp(sensorInterpTimes, gyTimes, gyZ)

    gpsLat = gpsDf.latitude.to_numpy()
    gpsLon = gpsDf.longitude.to_numpy()

    gpsLoni = np.interp(gpsInterpTimes, gpsTimes, gpsLon)
    gpsLati = np.interp(gpsInterpTimes, gpsTimes, gpsLat)

    acDf1 = pandas.DataFrame(
        {"time": sensorInterpTimes, "x": acXi, "y": acYi, "z": acZi}
    )
    gyDf1 = pandas.DataFrame(
        {"time": sensorInterpTimes, "x": gyXi, "y": gyYi, "z": gyZi}
    )
    gpsDf1 = pandas.DataFrame(
        {"time": gpsInterpTimes, "latitude": gpsLati, "longitude": gpsLoni}
    )

    return (acDf1, gyDf1, gpsDf1)

def get_point_raw_inputs(acDf, gyDf, gpsDf):
  entries = []
  total = len(acDf)
  for i in range(0, len(gpsDf)):
    start_i = i * int(window * slide)
    end_i = start_i + window
    if end_i >= total:
      break
    
    acE = acDf[start_i: end_i]
    gyE = gyDf[start_i: end_i]
    gpsE = gpsDf.iloc[[i]].to_dict('records')[0] # not using Series because of type casts
    entries.append((acE, gyE, gpsE, ))
  return entries