enum Coin { ethereum, bitcoin, solana }

extension ChainExtension on Coin {
  String get value {
    switch (this) {
      case Coin.ethereum:
        return "60'";
      case Coin.bitcoin:
        return "0'";
      case Coin.solana:
        return "501'";
      default:
        throw Exception("Unknown chain: $this");
    }
  }
}

extension StringExtension on String {
  Coin toChain() {
    switch (this) {
      case "ethereum":
        return Coin.ethereum;
      case "bitcoin":
        return Coin.bitcoin;
      case "solana":
        return Coin.solana;
      default:
        throw Exception("Unknown chain: $this");
    }
  }
}

String constructPath(Coin coin, int index) {
  if (!isValidIndex(index)) {
    throw Exception('Invalid index');
  }
  return "m/44'/${coin.value}/0'/0/$index";
}

bool isValidIndex(int index) {
  return index >= 0;
}
