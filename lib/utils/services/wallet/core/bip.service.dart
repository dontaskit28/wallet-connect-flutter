import 'dart:typed_data';
import 'package:bip39/bip39.dart' as bip39;

String validateMnemonic(String mnemonic) {
  if (!bip39.validateMnemonic(mnemonic)) {
    throw Exception('Invalid mnemonic');
  }
  return mnemonic;
}

Uint8List generateSeed(String mnemonic) {
  validateMnemonic(mnemonic);
  return bip39.mnemonicToSeed(mnemonic);
}

String genreateMnemonic() {
  return bip39.generateMnemonic();
}
