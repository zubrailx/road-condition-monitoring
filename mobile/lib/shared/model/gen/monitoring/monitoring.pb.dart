//
//  Generated code. Do not modify.
//  source: monitoring/monitoring.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../google/protobuf/timestamp.pb.dart' as $0;

class UserAccount extends $pb.GeneratedMessage {
  factory UserAccount({
    $core.String? accoundId,
    $core.String? name,
  }) {
    final $result = create();
    if (accoundId != null) {
      $result.accoundId = accoundId;
    }
    if (name != null) {
      $result.name = name;
    }
    return $result;
  }
  UserAccount._() : super();
  factory UserAccount.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UserAccount.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UserAccount', package: const $pb.PackageName(_omitMessageNames ? '' : 'monitoring'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'accoundId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UserAccount clone() => UserAccount()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UserAccount copyWith(void Function(UserAccount) updates) => super.copyWith((message) => updates(message as UserAccount)) as UserAccount;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserAccount create() => UserAccount._();
  UserAccount createEmptyInstance() => create();
  static $pb.PbList<UserAccount> createRepeated() => $pb.PbList<UserAccount>();
  @$core.pragma('dart2js:noInline')
  static UserAccount getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UserAccount>(create);
  static UserAccount? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get accoundId => $_getSZ(0);
  @$pb.TagNumber(1)
  set accoundId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAccoundId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccoundId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);
}

class AccelerometerRecord extends $pb.GeneratedMessage {
  factory AccelerometerRecord({
    $0.Timestamp? time,
    $core.double? x,
    $core.double? y,
    $core.double? z,
    $core.int? ms,
  }) {
    final $result = create();
    if (time != null) {
      $result.time = time;
    }
    if (x != null) {
      $result.x = x;
    }
    if (y != null) {
      $result.y = y;
    }
    if (z != null) {
      $result.z = z;
    }
    if (ms != null) {
      $result.ms = ms;
    }
    return $result;
  }
  AccelerometerRecord._() : super();
  factory AccelerometerRecord.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AccelerometerRecord.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AccelerometerRecord', package: const $pb.PackageName(_omitMessageNames ? '' : 'monitoring'), createEmptyInstance: create)
    ..aOM<$0.Timestamp>(1, _omitFieldNames ? '' : 'time', subBuilder: $0.Timestamp.create)
    ..a<$core.double>(11, _omitFieldNames ? '' : 'x', $pb.PbFieldType.OF)
    ..a<$core.double>(12, _omitFieldNames ? '' : 'y', $pb.PbFieldType.OF)
    ..a<$core.double>(13, _omitFieldNames ? '' : 'z', $pb.PbFieldType.OF)
    ..a<$core.int>(21, _omitFieldNames ? '' : 'ms', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AccelerometerRecord clone() => AccelerometerRecord()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AccelerometerRecord copyWith(void Function(AccelerometerRecord) updates) => super.copyWith((message) => updates(message as AccelerometerRecord)) as AccelerometerRecord;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AccelerometerRecord create() => AccelerometerRecord._();
  AccelerometerRecord createEmptyInstance() => create();
  static $pb.PbList<AccelerometerRecord> createRepeated() => $pb.PbList<AccelerometerRecord>();
  @$core.pragma('dart2js:noInline')
  static AccelerometerRecord getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AccelerometerRecord>(create);
  static AccelerometerRecord? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Timestamp get time => $_getN(0);
  @$pb.TagNumber(1)
  set time($0.Timestamp v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasTime() => $_has(0);
  @$pb.TagNumber(1)
  void clearTime() => clearField(1);
  @$pb.TagNumber(1)
  $0.Timestamp ensureTime() => $_ensure(0);

  @$pb.TagNumber(11)
  $core.double get x => $_getN(1);
  @$pb.TagNumber(11)
  set x($core.double v) { $_setFloat(1, v); }
  @$pb.TagNumber(11)
  $core.bool hasX() => $_has(1);
  @$pb.TagNumber(11)
  void clearX() => clearField(11);

  @$pb.TagNumber(12)
  $core.double get y => $_getN(2);
  @$pb.TagNumber(12)
  set y($core.double v) { $_setFloat(2, v); }
  @$pb.TagNumber(12)
  $core.bool hasY() => $_has(2);
  @$pb.TagNumber(12)
  void clearY() => clearField(12);

  @$pb.TagNumber(13)
  $core.double get z => $_getN(3);
  @$pb.TagNumber(13)
  set z($core.double v) { $_setFloat(3, v); }
  @$pb.TagNumber(13)
  $core.bool hasZ() => $_has(3);
  @$pb.TagNumber(13)
  void clearZ() => clearField(13);

  @$pb.TagNumber(21)
  $core.int get ms => $_getIZ(4);
  @$pb.TagNumber(21)
  set ms($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(21)
  $core.bool hasMs() => $_has(4);
  @$pb.TagNumber(21)
  void clearMs() => clearField(21);
}

class GyroscopeRecord extends $pb.GeneratedMessage {
  factory GyroscopeRecord({
    $0.Timestamp? time,
    $core.double? x,
    $core.double? y,
    $core.double? z,
    $core.int? ms,
  }) {
    final $result = create();
    if (time != null) {
      $result.time = time;
    }
    if (x != null) {
      $result.x = x;
    }
    if (y != null) {
      $result.y = y;
    }
    if (z != null) {
      $result.z = z;
    }
    if (ms != null) {
      $result.ms = ms;
    }
    return $result;
  }
  GyroscopeRecord._() : super();
  factory GyroscopeRecord.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GyroscopeRecord.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GyroscopeRecord', package: const $pb.PackageName(_omitMessageNames ? '' : 'monitoring'), createEmptyInstance: create)
    ..aOM<$0.Timestamp>(1, _omitFieldNames ? '' : 'time', subBuilder: $0.Timestamp.create)
    ..a<$core.double>(11, _omitFieldNames ? '' : 'x', $pb.PbFieldType.OF)
    ..a<$core.double>(12, _omitFieldNames ? '' : 'y', $pb.PbFieldType.OF)
    ..a<$core.double>(13, _omitFieldNames ? '' : 'z', $pb.PbFieldType.OF)
    ..a<$core.int>(21, _omitFieldNames ? '' : 'ms', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GyroscopeRecord clone() => GyroscopeRecord()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GyroscopeRecord copyWith(void Function(GyroscopeRecord) updates) => super.copyWith((message) => updates(message as GyroscopeRecord)) as GyroscopeRecord;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GyroscopeRecord create() => GyroscopeRecord._();
  GyroscopeRecord createEmptyInstance() => create();
  static $pb.PbList<GyroscopeRecord> createRepeated() => $pb.PbList<GyroscopeRecord>();
  @$core.pragma('dart2js:noInline')
  static GyroscopeRecord getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GyroscopeRecord>(create);
  static GyroscopeRecord? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Timestamp get time => $_getN(0);
  @$pb.TagNumber(1)
  set time($0.Timestamp v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasTime() => $_has(0);
  @$pb.TagNumber(1)
  void clearTime() => clearField(1);
  @$pb.TagNumber(1)
  $0.Timestamp ensureTime() => $_ensure(0);

  @$pb.TagNumber(11)
  $core.double get x => $_getN(1);
  @$pb.TagNumber(11)
  set x($core.double v) { $_setFloat(1, v); }
  @$pb.TagNumber(11)
  $core.bool hasX() => $_has(1);
  @$pb.TagNumber(11)
  void clearX() => clearField(11);

  @$pb.TagNumber(12)
  $core.double get y => $_getN(2);
  @$pb.TagNumber(12)
  set y($core.double v) { $_setFloat(2, v); }
  @$pb.TagNumber(12)
  $core.bool hasY() => $_has(2);
  @$pb.TagNumber(12)
  void clearY() => clearField(12);

  @$pb.TagNumber(13)
  $core.double get z => $_getN(3);
  @$pb.TagNumber(13)
  set z($core.double v) { $_setFloat(3, v); }
  @$pb.TagNumber(13)
  $core.bool hasZ() => $_has(3);
  @$pb.TagNumber(13)
  void clearZ() => clearField(13);

  @$pb.TagNumber(21)
  $core.int get ms => $_getIZ(4);
  @$pb.TagNumber(21)
  set ms($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(21)
  $core.bool hasMs() => $_has(4);
  @$pb.TagNumber(21)
  void clearMs() => clearField(21);
}

class GpsRecord extends $pb.GeneratedMessage {
  factory GpsRecord({
    $0.Timestamp? time,
    $core.double? latitude,
    $core.double? longitude,
    $core.double? accuracy,
    $core.int? ms,
  }) {
    final $result = create();
    if (time != null) {
      $result.time = time;
    }
    if (latitude != null) {
      $result.latitude = latitude;
    }
    if (longitude != null) {
      $result.longitude = longitude;
    }
    if (accuracy != null) {
      $result.accuracy = accuracy;
    }
    if (ms != null) {
      $result.ms = ms;
    }
    return $result;
  }
  GpsRecord._() : super();
  factory GpsRecord.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GpsRecord.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GpsRecord', package: const $pb.PackageName(_omitMessageNames ? '' : 'monitoring'), createEmptyInstance: create)
    ..aOM<$0.Timestamp>(1, _omitFieldNames ? '' : 'time', subBuilder: $0.Timestamp.create)
    ..a<$core.double>(11, _omitFieldNames ? '' : 'latitude', $pb.PbFieldType.OD)
    ..a<$core.double>(12, _omitFieldNames ? '' : 'longitude', $pb.PbFieldType.OD)
    ..a<$core.double>(13, _omitFieldNames ? '' : 'accuracy', $pb.PbFieldType.OD)
    ..a<$core.int>(21, _omitFieldNames ? '' : 'ms', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GpsRecord clone() => GpsRecord()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GpsRecord copyWith(void Function(GpsRecord) updates) => super.copyWith((message) => updates(message as GpsRecord)) as GpsRecord;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GpsRecord create() => GpsRecord._();
  GpsRecord createEmptyInstance() => create();
  static $pb.PbList<GpsRecord> createRepeated() => $pb.PbList<GpsRecord>();
  @$core.pragma('dart2js:noInline')
  static GpsRecord getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GpsRecord>(create);
  static GpsRecord? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Timestamp get time => $_getN(0);
  @$pb.TagNumber(1)
  set time($0.Timestamp v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasTime() => $_has(0);
  @$pb.TagNumber(1)
  void clearTime() => clearField(1);
  @$pb.TagNumber(1)
  $0.Timestamp ensureTime() => $_ensure(0);

  @$pb.TagNumber(11)
  $core.double get latitude => $_getN(1);
  @$pb.TagNumber(11)
  set latitude($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(11)
  $core.bool hasLatitude() => $_has(1);
  @$pb.TagNumber(11)
  void clearLatitude() => clearField(11);

  @$pb.TagNumber(12)
  $core.double get longitude => $_getN(2);
  @$pb.TagNumber(12)
  set longitude($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(12)
  $core.bool hasLongitude() => $_has(2);
  @$pb.TagNumber(12)
  void clearLongitude() => clearField(12);

  @$pb.TagNumber(13)
  $core.double get accuracy => $_getN(3);
  @$pb.TagNumber(13)
  set accuracy($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(13)
  $core.bool hasAccuracy() => $_has(3);
  @$pb.TagNumber(13)
  void clearAccuracy() => clearField(13);

  @$pb.TagNumber(21)
  $core.int get ms => $_getIZ(4);
  @$pb.TagNumber(21)
  set ms($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(21)
  $core.bool hasMs() => $_has(4);
  @$pb.TagNumber(21)
  void clearMs() => clearField(21);
}

class Monitoring extends $pb.GeneratedMessage {
  factory Monitoring({
    $core.Iterable<AccelerometerRecord>? accelerometerRecords,
    $core.Iterable<GyroscopeRecord>? gyroscopeRecords,
    $core.Iterable<GpsRecord>? gpsRecords,
    UserAccount? account,
  }) {
    final $result = create();
    if (accelerometerRecords != null) {
      $result.accelerometerRecords.addAll(accelerometerRecords);
    }
    if (gyroscopeRecords != null) {
      $result.gyroscopeRecords.addAll(gyroscopeRecords);
    }
    if (gpsRecords != null) {
      $result.gpsRecords.addAll(gpsRecords);
    }
    if (account != null) {
      $result.account = account;
    }
    return $result;
  }
  Monitoring._() : super();
  factory Monitoring.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Monitoring.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Monitoring', package: const $pb.PackageName(_omitMessageNames ? '' : 'monitoring'), createEmptyInstance: create)
    ..pc<AccelerometerRecord>(1, _omitFieldNames ? '' : 'accelerometerRecords', $pb.PbFieldType.PM, subBuilder: AccelerometerRecord.create)
    ..pc<GyroscopeRecord>(2, _omitFieldNames ? '' : 'gyroscopeRecords', $pb.PbFieldType.PM, subBuilder: GyroscopeRecord.create)
    ..pc<GpsRecord>(3, _omitFieldNames ? '' : 'gpsRecords', $pb.PbFieldType.PM, subBuilder: GpsRecord.create)
    ..aOM<UserAccount>(11, _omitFieldNames ? '' : 'account', subBuilder: UserAccount.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Monitoring clone() => Monitoring()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Monitoring copyWith(void Function(Monitoring) updates) => super.copyWith((message) => updates(message as Monitoring)) as Monitoring;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Monitoring create() => Monitoring._();
  Monitoring createEmptyInstance() => create();
  static $pb.PbList<Monitoring> createRepeated() => $pb.PbList<Monitoring>();
  @$core.pragma('dart2js:noInline')
  static Monitoring getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Monitoring>(create);
  static Monitoring? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<AccelerometerRecord> get accelerometerRecords => $_getList(0);

  @$pb.TagNumber(2)
  $core.List<GyroscopeRecord> get gyroscopeRecords => $_getList(1);

  @$pb.TagNumber(3)
  $core.List<GpsRecord> get gpsRecords => $_getList(2);

  @$pb.TagNumber(11)
  UserAccount get account => $_getN(3);
  @$pb.TagNumber(11)
  set account(UserAccount v) { setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasAccount() => $_has(3);
  @$pb.TagNumber(11)
  void clearAccount() => clearField(11);
  @$pb.TagNumber(11)
  UserAccount ensureAccount() => $_ensure(3);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
