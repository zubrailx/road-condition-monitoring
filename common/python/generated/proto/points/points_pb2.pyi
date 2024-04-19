import util_pb2 as _util_pb2
from google.protobuf.internal import containers as _containers
from google.protobuf import descriptor as _descriptor
from google.protobuf import message as _message
from typing import ClassVar as _ClassVar, Iterable as _Iterable, Mapping as _Mapping, Optional as _Optional, Union as _Union

DESCRIPTOR: _descriptor.FileDescriptor

class PointRecord(_message.Message):
    __slots__ = ("time", "latitude", "longitude", "prediction")
    TIME_FIELD_NUMBER: _ClassVar[int]
    LATITUDE_FIELD_NUMBER: _ClassVar[int]
    LONGITUDE_FIELD_NUMBER: _ClassVar[int]
    PREDICTION_FIELD_NUMBER: _ClassVar[int]
    time: _util_pb2.Timestamp
    latitude: float
    longitude: float
    prediction: float
    def __init__(self, time: _Optional[_Union[_util_pb2.Timestamp, _Mapping]] = ..., latitude: _Optional[float] = ..., longitude: _Optional[float] = ..., prediction: _Optional[float] = ...) -> None: ...

class Points(_message.Message):
    __slots__ = ("point_records",)
    POINT_RECORDS_FIELD_NUMBER: _ClassVar[int]
    point_records: _containers.RepeatedCompositeFieldContainer[PointRecord]
    def __init__(self, point_records: _Optional[_Iterable[_Union[PointRecord, _Mapping]]] = ...) -> None: ...
