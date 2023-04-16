import 'package:bip32_ed25519/api.dart';
import 'package:convert/convert.dart';
import 'package:web3dart/credentials.dart';
import 'core/signature.service.dart' as msg;
import 'core/signature.service.dart' as signer;

String genreateEthereumCreationMessage(String nonce, Credentials credentials) {
  var data = {
    'public_address': credentials.address.hexNo0x,
    'chain': "eth",
    'nonce': nonce,
  };
  var rawMsg = msg.encodeMessage(data);
  return signer.signEthMessage(rawMsg, credentials);
}

String generateEthereumDeletionMessage(String nonce, Credentials credentials) {
  var data = {
    "nonce": nonce,
  };
  var rawMsg = msg.encodeMessage(data);
  return signer.signEthMessage(rawMsg, credentials);
}

String genreateShamirCreationMessage(
    String secret, String nonce, ExtendedSigningKey key) {
  var data = {
    'secret': secret,
    'pub_key': hex.encode(key.publicKey),
    'nonce': nonce,
  };
  var rawMsg = msg.encodeMessage(data);
  return signer.signEdMessage(rawMsg, key);
}

String genreateShamirDeletionMessage(
  String nonce,
  ExtendedSigningKey key,
) {
  var data = {
    "nonce": nonce,
  };
  var rawMsg = msg.encodeMessage(data);
  return signer.signEdMessage(rawMsg, key);
}

String generateCloudCreateMessage(
    String fileId, String cloudProvider, String nonce, ExtendedSigningKey key) {
  var data = {
    'provider': cloudProvider,
    'file_id': fileId,
    'nonce': nonce,
  };
  var rawMsg = msg.encodeMessage(data);
  return signer.signEdMessage(rawMsg, key);
}

String generateCloudDeleteMessage(String nonce, ExtendedSigningKey key) {
  var data = {
    "nonce": nonce,
  };
  var rawMsg = msg.encodeMessage(data);
  return signer.signEdMessage(rawMsg, key);
}
