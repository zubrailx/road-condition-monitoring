import util_pb2 as _util_pb2
from google.protobuf.internal import containers as _containers
from google.protobuf import descriptor as _descriptor
from google.protobuf import message as _message
from typing import ClassVar as _ClassVar, Iterable as _Iterable, Mapping as _Mapping, Optional as _Optional, Union as _Union

DESCRIPTOR: _descriptor.FileDescriptor

class UserAccount(_message.Message):
    __slots__ = ("accound_id", "name")
    ACCOUND_ID_FIELD_NUMBER: _ClassVar[int]
    NAME_FIELD_NUMBER: _ClassVar[int]
    accound_id: str
    name: str
    def __init__(self, accound_id: _Optional[str] = ..., name: _Optional[str] = ...) -> None: ...

class AccelerometerRecord(_message.Message):
    __slots__ = ("time", "x", "y", "z", "ms")
    TIME_FIELD_NUMBER: _ClassVar[int]
    X_FIELD_NUMBER: _ClassVar[int]
    Y_FIELD_NUMBER: _ClassVar[int]
    Z_FIELD_NUMBER: _ClassVar[int]
    MS_FIELD_NUMBER: _ClassVar[int]
    time: _util_pb2.Timestamp
    x: float
    y: float
    z: float
    ms: int
    def __init__(self, time: _Optional[_Union[_util_pb2.Timestamp, _Mapping]] = ..., x: _Optional[float] = ..., y: _Optional[float] = ..., z: _Optional[float] = ..., ms: _Optional[int] = ...) -> None: ...

class GyroscopeRecord(_message.Message):
    __slots__ = ("time", "x", "y", "z", "ms")
    TIME_FIELD_NUMBER: _ClassVar[int]
    X_FIELD_NUMBER: _ClassVar[int]
    Y_FIELD_NUMBER: _ClassVar[int]
    Z_FIELD_NUMBER: _ClassVar[int]
    MS_FIELD_NUMBER: _ClassVar[int]
    time: _util_pb2.Timestamp
    x: float
    y: float
    z: float
    ms: int
    def __init__(self, time: _Optional[_Union[_util_pb2.Timestamp, _Mapping]] = ..., x: _Optional[float] = ..., y: _Optional[float] = ..., z: _Optional[float] = ..., ms: _Optional[int] = ...) -> None: ...

class GpsRecord(_message.Message):
    __slots__ = ("time", "latitude", "longitude", "accuracy", "ms")
    TIME_FIELD_NUMBER: _ClassVar[int]
    LATITUDE_FIELD_NUMBER: _ClassVar[int]
    LONGITUDE_FIELD_NUMBER: _ClassVar[int]
    ACCURACY_FIELD_NUMBER: _ClassVar[int]
    MS_FIELD_NUMBER: _ClassVar[int]
    time: _util_pb2.Timestamp
    latitude: float
    longitude: float
    accuracy: float
    ms: int
    def __init__(self, time: _Optional[_Union[_util_pb2.Timestamp, _Mapping]] = ..., latitude: _Optional[float] = ..., longitude: _Optional[float] = ..., accuracy: _Optional[float] = ..., ms: _Optional[int] = ...) -> None: ...

class Monitoring(_message.Message):
    __slots__ = ("accelerometer_records", "gyroscope_records", "gps_records", "account")
    ACCELEROMETER_RECORDS_FIELD_NUMBER: _ClassVar[int]
    GYROSCOPE_RECORDS_FIELD_NUMBER: _ClassVar[int]
    GPS_RECORDS_FIELD_NUMBER: _ClassVar[int]
    ACCOUNT_FIELD_NUMBER: _ClassVar[int]
    accelerometer_records: _containers.RepeatedCompositeFieldContainer[AccelerometerRecord]
    gyroscope_records: _containers.RepeatedCompositeFieldContainer[GyroscopeRecord]
    gps_records: _containers.RepeatedCompositeFieldContainer[GpsRecord]
    account: UserAccount
    def __init__(self, accelerometer_records: _Optional[_Iterable[_Union[AccelerometerRecord, _Mapping]]] = ..., gyroscope_records: _Optional[_Iterable[_Union[GyroscopeRecord, _Mapping]]] = ..., gps_records: _Optional[_Iterable[_Union[GpsRecord, _Mapping]]] = ..., account: _Optional[_Union[UserAccount, _Mapping]] = ...) -> None: ...
