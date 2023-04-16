import 'package:ntcdcrypto/ntcdcrypto.dart';

List<String> createShares(String safeMnemonic) {
  SSS sss = SSS();
  List<String> shares = sss.create(2, 3, safeMnemonic, true);
  return shares;
}

String combineShares(List<String> shares) {
  SSS sss = SSS();
  if (shares.length < 2) {
    throw Exception('Not enough shares');
  }
  return sss.combine(shares, true);
}
