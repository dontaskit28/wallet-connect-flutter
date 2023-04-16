import 'package:bip32_ed25519/api.dart';
import 'package:dart_bip32_bip44/dart_bip32_bip44.dart';
import '../../utils/path.utils.dart';
import 'core/bip.service.dart' as bip;
import 'core/eddsa.service.dart' as ed;
import 'core/ethereum.service.dart' as eth;
import 'package:web3dart/credentials.dart';

Uint8List createWallet(String mnemonic) {
  return bip.generateSeed(mnemonic);
}

ExtendedSigningKey createEdwardsKey(Uint8List seed) {
 return ed.generateKeys(seed);
}
ExtendedKey createEcdsaKey(Uint8List seed, int index) {
  var chain = eth.getChainFromSeed(seed);
  var path = constructPath(Coin.ethereum, index);
  return chain.forPath(path);
}

Credentials createEthereumAccount(ExtendedKey key) {
  return eth.genrateCredentials(key);
}

Credentials createEthereumAccountFromHex(String privateKeyHex) {
  return eth.genrateCredentialsFromHex(privateKeyHex);
}