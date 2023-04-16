import 'dart:convert';
import 'package:convert/convert.dart';
import 'dart:typed_data';
import 'package:dart_bip32_bip44/dart_bip32_bip44.dart';
import 'package:web3dart/web3dart.dart';

Chain getChainFromSeed(Uint8List seed) {
  return Chain.seed(hex.encode(seed));
}

Credentials genrateCredentials(ExtendedKey key) {
  return EthPrivateKey.fromHex(key.privateKeyHex());
}

Credentials genrateCredentialsFromHex(String privateKeyHex) {
  return EthPrivateKey.fromHex(privateKeyHex);
}

Uint8List signPersonalMessage(String message, Credentials credentials) {
  return credentials
      .signPersonalMessageToUint8List(Uint8List.fromList(utf8.encode(message)));
}
