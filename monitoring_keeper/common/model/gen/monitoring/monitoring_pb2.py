# -*- coding: utf-8 -*-
# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: monitoring/monitoring.proto
# Protobuf Python Version: 4.25.3
"""Generated protocol buffer code."""
from google.protobuf import descriptor as _descriptor
from google.protobuf import descriptor_pool as _descriptor_pool
from google.protobuf import symbol_database as _symbol_database
from google.protobuf.internal import builder as _builder
# @@protoc_insertion_point(imports)

_sym_db = _symbol_database.Default()


import util_pb2 as util__pb2


DESCRIPTOR = _descriptor_pool.Default().AddSerializedFile(b'\n\x1bmonitoring/monitoring.proto\x12\nmonitoring\x1a\nutil.proto\"/\n\x0bUserAccount\x12\x12\n\naccound_id\x18\x01 \x01(\t\x12\x0c\n\x04name\x18\x02 \x01(\t\"\\\n\x13\x41\x63\x63\x65lerometerRecord\x12\x18\n\x04time\x18\x01 \x01(\x0b\x32\n.Timestamp\x12\t\n\x01x\x18\x0b \x01(\x02\x12\t\n\x01y\x18\x0c \x01(\x02\x12\t\n\x01z\x18\r \x01(\x02\x12\n\n\x02ms\x18\x15 \x01(\x05\"X\n\x0fGyroscopeRecord\x12\x18\n\x04time\x18\x01 \x01(\x0b\x32\n.Timestamp\x12\t\n\x01x\x18\x0b \x01(\x02\x12\t\n\x01y\x18\x0c \x01(\x02\x12\t\n\x01z\x18\r \x01(\x02\x12\n\n\x02ms\x18\x15 \x01(\x05\"h\n\tGpsRecord\x12\x18\n\x04time\x18\x01 \x01(\x0b\x32\n.Timestamp\x12\x10\n\x08latitude\x18\x0b \x01(\x01\x12\x11\n\tlongitude\x18\x0c \x01(\x01\x12\x10\n\x08\x61\x63\x63uracy\x18\r \x01(\x01\x12\n\n\x02ms\x18\x15 \x01(\x05\"\xda\x01\n\nMonitoring\x12>\n\x15\x61\x63\x63\x65lerometer_records\x18\x01 \x03(\x0b\x32\x1f.monitoring.AccelerometerRecord\x12\x36\n\x11gyroscope_records\x18\x02 \x03(\x0b\x32\x1b.monitoring.GyroscopeRecord\x12*\n\x0bgps_records\x18\x03 \x03(\x0b\x32\x15.monitoring.GpsRecord\x12(\n\x07\x61\x63\x63ount\x18\x0b \x01(\x0b\x32\x17.monitoring.UserAccountb\x06proto3')

_globals = globals()
_builder.BuildMessageAndEnumDescriptors(DESCRIPTOR, _globals)
_builder.BuildTopDescriptorsAndMessages(DESCRIPTOR, 'monitoring.monitoring_pb2', _globals)
if _descriptor._USE_C_DESCRIPTORS == False:
  DESCRIPTOR._options = None
  _globals['_USERACCOUNT']._serialized_start=55
  _globals['_USERACCOUNT']._serialized_end=102
  _globals['_ACCELEROMETERRECORD']._serialized_start=104
  _globals['_ACCELEROMETERRECORD']._serialized_end=196
  _globals['_GYROSCOPERECORD']._serialized_start=198
  _globals['_GYROSCOPERECORD']._serialized_end=286
  _globals['_GPSRECORD']._serialized_start=288
  _globals['_GPSRECORD']._serialized_end=392
  _globals['_MONITORING']._serialized_start=395
  _globals['_MONITORING']._serialized_end=613
# @@protoc_insertion_point(module_scope)