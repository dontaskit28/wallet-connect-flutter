import 'dart:convert';
import 'package:bip32_ed25519/api.dart';

ExtendedSigningKey generateKeys(Uint8List seed) {
  if (!isValidSeed(seed)) {
    throw Exception('Invalid seed');
  }
  if (seed.length == 64) {
    seed = seed.sublist(0, 32);
  }
  return ExtendedSigningKey.fromSeed(seed);
}

SignedMessage signMessage(String message, ExtendedSigningKey key) {
  return key.sign(utf8.encode(message));
}

bool isValidSeed(Uint8List seed) {
  return seed.length == 32 || seed.length == 64;
}
