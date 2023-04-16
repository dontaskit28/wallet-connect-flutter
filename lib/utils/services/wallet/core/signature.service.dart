import 'dart:convert';
import 'package:bip32_ed25519/api.dart';
import 'package:convert/convert.dart';
import 'package:web3dart/web3dart.dart';
import 'ethereum.service.dart' as eth;
import 'eddsa.service.dart' as ed;


String encodeMessage(Map<String, String> message) {
  return jsonEncode(message);
}

String signEthMessage(String rawMessage, Credentials credentials) {
  return hex.encode(eth.signPersonalMessage(rawMessage, credentials));
}

String signEdMessage(String rawMessage, ExtendedSigningKey key) {
  return hex.encode(ed.signMessage(rawMessage, key).signature);
}
