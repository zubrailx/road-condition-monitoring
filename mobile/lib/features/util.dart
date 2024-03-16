import 'package:uuid/data.dart';
import 'package:uuid/rng.dart';
import 'package:uuid/uuid.dart';

String generateUUID() {
  var uuid = const Uuid();
  // Generate a v4 (crypto-random) id
  var v4Crypto = uuid.v4(config: V4Options(null, CryptoRNG()));
  return v4Crypto;
}
