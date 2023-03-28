enum Network {
  ethereumMainnet,
  ethereumSepolia,
  ethereumGoerli,
  polygonMatic,
  polygonMumbai,
}

extension NetworkExtension on Network {
  int get chainId {
    switch (this) {
      case Network.ethereumMainnet:
        return 1;
      case Network.ethereumSepolia:
        return 11155111;
      case Network.ethereumGoerli:
        return 5;
      case Network.polygonMatic:
        return 137;
      case Network.polygonMumbai:
        return 80001;
      default:
        throw Exception("Unknown Network: $this");
    }
  }

  String get rpc {
    switch (this) {
      case Network.ethereumMainnet:
        return "https://mainnet.infura.io/v3/5d158c71773c4d869a97405bef38704f";
      case Network.ethereumSepolia:
        return "https://sepolia.infura.io/v3/5d158c71773c4d869a97405bef38704f";
      case Network.ethereumGoerli:
        return "https://goerli.infura.io/v3/5d158c71773c4d869a97405bef38704f";
      case Network.polygonMatic:
        return "https://rpc-mainnet.maticvigil.com/";
      case Network.polygonMumbai:
        return "https://rpc-mumbai.maticvigil.com/";
      default:
        throw Exception("Unknown Network: $this");
    }
  }

  String get chainName {
    switch (this) {
      case Network.ethereumMainnet:
        return "ethereum-mainnet";
      case Network.ethereumSepolia:
        return "ethereum-sepolia";
      case Network.ethereumGoerli:
        return "ethereum-goerli";
      case Network.polygonMatic:
        return "polygon-matic";
      case Network.polygonMumbai:
        return "polygon-mumbai";
      default:
        throw Exception("Unknown Network: $this");
    }
  }
}

extension StringExtension on String {
  Network toNetwork() {
    switch (this) {
      case "ethereum-mainnet":
        return Network.ethereumMainnet;
      case "ethereum-sepolia":
        return Network.ethereumSepolia;
      case "ethereum-goerli":
        return Network.ethereumGoerli;
      case "polygon-matic":
        return Network.polygonMatic;
      case "polygon-mumbai":
        return Network.polygonMumbai;
      default:
        throw Exception("Unknown Network: $this");
    }
  }
}
