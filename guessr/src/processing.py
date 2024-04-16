import pandas
import numpy
from scipy.signal import lfilter, iirfilter

tick = 25000
window = 128
slide = 0.5
fs = 1000000 / tick

# TODO: compute based on traning data
filter_N = 2
filter_freq = 10

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

    sensorInterpTimes = numpy.arange(minTime, maxTime, tick)
    # print(sensorInterpTimes, len(sensorInterpTimes), sep="\n")

    gpsInterpTimes = numpy.arange(
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

    acXi = numpy.interp(sensorInterpTimes, acTimes, acX)
    acYi = numpy.interp(sensorInterpTimes, acTimes, acY)
    acZi = numpy.interp(sensorInterpTimes, acTimes, acZ)
    gyXi = numpy.interp(sensorInterpTimes, gyTimes, gyX)
    gyYi = numpy.interp(sensorInterpTimes, gyTimes, gyY)
    gyZi = numpy.interp(sensorInterpTimes, gyTimes, gyZ)

    gpsLat = gpsDf.latitude.to_numpy()
    gpsLon = gpsDf.longitude.to_numpy()

    gpsLoni = numpy.interp(gpsInterpTimes, gpsTimes, gpsLon)
    gpsLati = numpy.interp(gpsInterpTimes, gpsTimes, gpsLat)

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


def reduce_noice(acDf: pandas.DataFrame, gyDf: pandas.DataFrame):
    b, a = iirfilter(filter_N, Wn=filter_freq, fs=fs, btype="low", ftype="butter")

    acX = lfilter(b, a, acDf.x)
    acY = lfilter(b, a, acDf.y)
    acZ = lfilter(b, a, acDf.z)

    gyX = lfilter(b, a, gyDf.x)
    gyY = lfilter(b, a, gyDf.y)
    gyZ = lfilter(b, a, gyDf.z)

    acDf1 = pandas.DataFrame({"time": acDf.time, "x": acX, "y": acY, "z": acZ})
    gyDf1 = pandas.DataFrame({"time": gyDf.time, "x": gyX, "y": gyY, "z": gyZ})

    return (acDf1, gyDf1)
    # acil = (acXil**2 + acYil**2 + acZil**2) ** 0.5
    # gyil = (gyXil**2 + gyYil**2 + gyZil**2) ** 0.5


# compute magnitude on all axis, apply fast fft transformation, 
# get 32 elements of each (accelerometer, gyroscope), max acceleromet, max gyroscope
def extract_features(acDf: pandas.DataFrame, gyDf: pandas.DataFrame):
    pass
