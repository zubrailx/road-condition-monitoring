# -*- coding: utf-8 -*-
# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: points/points.proto
# Protobuf Python Version: 4.25.3
"""Generated protocol buffer code."""
from google.protobuf import descriptor as _descriptor
from google.protobuf import descriptor_pool as _descriptor_pool
from google.protobuf import symbol_database as _symbol_database
from google.protobuf.internal import builder as _builder
# @@protoc_insertion_point(imports)

_sym_db = _symbol_database.Default()


import util_pb2 as util__pb2


DESCRIPTOR = _descriptor_pool.Default().AddSerializedFile(b'\n\x13points/points.proto\x12\x06points\x1a\nutil.proto\"`\n\x0bPointRecord\x12\x18\n\x04time\x18\x01 \x01(\x0b\x32\n.Timestamp\x12\x10\n\x08latitude\x18\x0b \x01(\x01\x12\x11\n\tlongitude\x18\x0c \x01(\x01\x12\x12\n\nprediction\x18\x15 \x01(\x02\"4\n\x06Points\x12*\n\rpoint_records\x18\x01 \x03(\x0b\x32\x13.points.PointRecordb\x06proto3')

_globals = globals()
_builder.BuildMessageAndEnumDescriptors(DESCRIPTOR, _globals)
_builder.BuildTopDescriptorsAndMessages(DESCRIPTOR, 'points.points_pb2', _globals)
if _descriptor._USE_C_DESCRIPTORS == False:
  DESCRIPTOR._options = None
  _globals['_POINTRECORD']._serialized_start=43
  _globals['_POINTRECORD']._serialized_end=139
  _globals['_POINTS']._serialized_start=141
  _globals['_POINTS']._serialized_end=193
# @@protoc_insertion_point(module_scope)
