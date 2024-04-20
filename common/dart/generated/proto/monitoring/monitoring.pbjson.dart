//
//  Generated code. Do not modify.
//  source: monitoring/monitoring.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use userAccountDescriptor instead')
const UserAccount$json = {
  '1': 'UserAccount',
  '2': [
    {'1': 'accound_id', '3': 1, '4': 1, '5': 9, '10': 'accoundId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `UserAccount`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userAccountDescriptor = $convert.base64Decode(
    'CgtVc2VyQWNjb3VudBIdCgphY2NvdW5kX2lkGAEgASgJUglhY2NvdW5kSWQSEgoEbmFtZRgCIA'
    'EoCVIEbmFtZQ==');

@$core.Deprecated('Use accelerometerRecordDescriptor instead')
const AccelerometerRecord$json = {
  '1': 'AccelerometerRecord',
  '2': [
    {'1': 'time', '3': 1, '4': 1, '5': 11, '6': '.Timestamp', '10': 'time'},
    {'1': 'x', '3': 11, '4': 1, '5': 2, '10': 'x'},
    {'1': 'y', '3': 12, '4': 1, '5': 2, '10': 'y'},
    {'1': 'z', '3': 13, '4': 1, '5': 2, '10': 'z'},
    {'1': 'ms', '3': 21, '4': 1, '5': 5, '10': 'ms'},
  ],
};

/// Descriptor for `AccelerometerRecord`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List accelerometerRecordDescriptor = $convert.base64Decode(
    'ChNBY2NlbGVyb21ldGVyUmVjb3JkEh4KBHRpbWUYASABKAsyCi5UaW1lc3RhbXBSBHRpbWUSDA'
    'oBeBgLIAEoAlIBeBIMCgF5GAwgASgCUgF5EgwKAXoYDSABKAJSAXoSDgoCbXMYFSABKAVSAm1z');

@$core.Deprecated('Use gyroscopeRecordDescriptor instead')
const GyroscopeRecord$json = {
  '1': 'GyroscopeRecord',
  '2': [
    {'1': 'time', '3': 1, '4': 1, '5': 11, '6': '.Timestamp', '10': 'time'},
    {'1': 'x', '3': 11, '4': 1, '5': 2, '10': 'x'},
    {'1': 'y', '3': 12, '4': 1, '5': 2, '10': 'y'},
    {'1': 'z', '3': 13, '4': 1, '5': 2, '10': 'z'},
    {'1': 'ms', '3': 21, '4': 1, '5': 5, '10': 'ms'},
  ],
};

/// Descriptor for `GyroscopeRecord`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gyroscopeRecordDescriptor = $convert.base64Decode(
    'Cg9HeXJvc2NvcGVSZWNvcmQSHgoEdGltZRgBIAEoCzIKLlRpbWVzdGFtcFIEdGltZRIMCgF4GA'
    'sgASgCUgF4EgwKAXkYDCABKAJSAXkSDAoBehgNIAEoAlIBehIOCgJtcxgVIAEoBVICbXM=');

@$core.Deprecated('Use gpsRecordDescriptor instead')
const GpsRecord$json = {
  '1': 'GpsRecord',
  '2': [
    {'1': 'time', '3': 1, '4': 1, '5': 11, '6': '.Timestamp', '10': 'time'},
    {'1': 'latitude', '3': 11, '4': 1, '5': 1, '10': 'latitude'},
    {'1': 'longitude', '3': 12, '4': 1, '5': 1, '10': 'longitude'},
    {'1': 'accuracy', '3': 13, '4': 1, '5': 1, '10': 'accuracy'},
    {'1': 'ms', '3': 21, '4': 1, '5': 5, '10': 'ms'},
  ],
};

/// Descriptor for `GpsRecord`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gpsRecordDescriptor = $convert.base64Decode(
    'CglHcHNSZWNvcmQSHgoEdGltZRgBIAEoCzIKLlRpbWVzdGFtcFIEdGltZRIaCghsYXRpdHVkZR'
    'gLIAEoAVIIbGF0aXR1ZGUSHAoJbG9uZ2l0dWRlGAwgASgBUglsb25naXR1ZGUSGgoIYWNjdXJh'
    'Y3kYDSABKAFSCGFjY3VyYWN5Eg4KAm1zGBUgASgFUgJtcw==');

@$core.Deprecated('Use monitoringDescriptor instead')
const Monitoring$json = {
  '1': 'Monitoring',
  '2': [
    {
      '1': 'accelerometer_records',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.monitoring.AccelerometerRecord',
      '10': 'accelerometerRecords'
    },
    {
      '1': 'gyroscope_records',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.monitoring.GyroscopeRecord',
      '10': 'gyroscopeRecords'
    },
    {
      '1': 'gps_records',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.monitoring.GpsRecord',
      '10': 'gpsRecords'
    },
    {
      '1': 'account',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.monitoring.UserAccount',
      '10': 'account'
    },
  ],
};

/// Descriptor for `Monitoring`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List monitoringDescriptor = $convert.base64Decode(
    'CgpNb25pdG9yaW5nElQKFWFjY2VsZXJvbWV0ZXJfcmVjb3JkcxgBIAMoCzIfLm1vbml0b3Jpbm'
    'cuQWNjZWxlcm9tZXRlclJlY29yZFIUYWNjZWxlcm9tZXRlclJlY29yZHMSSAoRZ3lyb3Njb3Bl'
    'X3JlY29yZHMYAiADKAsyGy5tb25pdG9yaW5nLkd5cm9zY29wZVJlY29yZFIQZ3lyb3Njb3BlUm'
    'Vjb3JkcxI2CgtncHNfcmVjb3JkcxgDIAMoCzIVLm1vbml0b3JpbmcuR3BzUmVjb3JkUgpncHNS'
    'ZWNvcmRzEjEKB2FjY291bnQYCyABKAsyFy5tb25pdG9yaW5nLlVzZXJBY2NvdW50UgdhY2NvdW'
    '50');
