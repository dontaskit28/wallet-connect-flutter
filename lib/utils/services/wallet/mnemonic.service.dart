import 'core/bip.service.dart' as bip;
import 'core/shamir.service.dart' as shamir;

String createNewMnemonic() {
  return bip.genreateMnemonic();
}

String recoverMnemonic(List<String> shares) {
  var recoverdSecret = shamir.combineShares(shares);
  return bip.validateMnemonic(recoverdSecret);
}

String importMnemonic(String unsafeMnemonic) {
  return bip.validateMnemonic(unsafeMnemonic);
}

List<String> createShamirShares(String unsafeMnemonic) {
  var mnemonic = bip.validateMnemonic(unsafeMnemonic);
  return shamir.createShares(mnemonic);
}
