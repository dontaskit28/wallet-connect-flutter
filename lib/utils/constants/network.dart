// ! Supported Networks
// * Ethereum [Mainnet, Sepolia, Goerli]
// * Polygon [Mainnet, Mumbai]
// * Avalanche [Mainnet, Fuji]
// * Fantom [Mainnet, Testnet]
// * Arbitrum [Mainnet, Goerli]
// * Optimism [Mainnet, Goerli]
// * Binance Smart Chain [Mainnet, Testnet]
// * Cronos [Mainnet, Testnet]
// * FireChain [EVM, Substrate]

enum Network {
  ethereumMainnet,
  ethereumSepolia,
  ethereumGoerli,
  polygonMainnet,
  polygonMumbai,
  avalancheMainnet,
  avalancheFuji,
  fantomMainnet,
  fantomTestnet,
  arbitrumMainnet,
  arbitrumGoerli,
  optimismMainnet,
  optimismGoerli,
  binanceSmartChainMainnet,
  binanceSmartChainTestnet,
  cronosMainnet,
  cronosTestnet,
  fireChainEvm,
  // fireChainSubstrate
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
      case Network.polygonMainnet:
        return 137;
      case Network.polygonMumbai:
        return 80001;
      case Network.avalancheMainnet:
        return 43114;
      case Network.avalancheFuji:
        return 43113;
      case Network.fantomMainnet:
        return 250;
      case Network.fantomTestnet:
        return 4002;
      case Network.arbitrumMainnet:
        return 42161;
      case Network.arbitrumGoerli:
        return 421613;
      case Network.optimismMainnet:
        return 10;
      case Network.optimismGoerli:
        return 420;
      case Network.binanceSmartChainMainnet:
        return 56;
      case Network.binanceSmartChainTestnet:
        return 97;
      case Network.cronosMainnet:
        return 25;
      case Network.cronosTestnet:
        return 338;
      case Network.fireChainEvm:
        return 997;
      // case Network.fireChainSubstrate:
      //   return 998;
      default:
        throw Exception("Unknown Network: $this");
    }
  }

  bool get isEVM {
    switch (this) {
      case Network.ethereumMainnet:
      case Network.ethereumSepolia:
      case Network.ethereumGoerli:
      case Network.polygonMainnet:
      case Network.polygonMumbai:
      case Network.avalancheMainnet:
      case Network.avalancheFuji:
      case Network.fantomMainnet:
      case Network.fantomTestnet:
      case Network.arbitrumMainnet:
      case Network.arbitrumGoerli:
      case Network.optimismMainnet:
      case Network.optimismGoerli:
      case Network.binanceSmartChainMainnet:
      case Network.binanceSmartChainTestnet:
      case Network.cronosMainnet:
      case Network.cronosTestnet:
      case Network.fireChainEvm:
        return true;
      default:
        return false;
    }
  }

  bool get isTestnet {
    switch (this) {
      case Network.ethereumMainnet:
      case Network.polygonMainnet:
      case Network.avalancheMainnet:
      case Network.fantomMainnet:
      case Network.arbitrumMainnet:
      case Network.optimismMainnet:
      case Network.binanceSmartChainMainnet:
      case Network.cronosMainnet:
      case Network.fireChainEvm:
        return false;
      default:
        return true;
    }
  }

  bool get isEip1559 {
    switch (this) {
      case Network.ethereumMainnet:
      case Network.ethereumSepolia:
      case Network.ethereumGoerli:
      case Network.polygonMainnet:
      case Network.polygonMumbai:
      case Network.avalancheMainnet:
      case Network.avalancheFuji:
      case Network.fantomMainnet:
      case Network.fantomTestnet:
      case Network.arbitrumMainnet:
      case Network.arbitrumGoerli:
      case Network.optimismMainnet:
      case Network.optimismGoerli:
      case Network.binanceSmartChainMainnet:
      case Network.binanceSmartChainTestnet:
      case Network.cronosMainnet:
      case Network.cronosTestnet:
        return true;
      default:
        return false;
    }
  }

  bool get canLend {
    switch (this) {
      case Network.ethereumMainnet:
      case Network.ethereumSepolia:
      case Network.ethereumGoerli:
      case Network.polygonMainnet:
      case Network.polygonMumbai:
      case Network.avalancheMainnet:
      case Network.avalancheFuji:
      case Network.fantomMainnet:
      case Network.fantomTestnet:
      case Network.arbitrumMainnet:
      case Network.arbitrumGoerli:
      case Network.optimismMainnet:
      case Network.optimismGoerli:
        return true;
      default:
        return false;
    }
  }

  bool get canSimulate {
    switch (this) {
      case Network.ethereumMainnet:
      case Network.ethereumGoerli:
      case Network.polygonMainnet:
      case Network.polygonMumbai:
      case Network.arbitrumMainnet:
      case Network.arbitrumGoerli:
        // case Network.optimismMainnet:
        // case Network.optimismGoerli:
        return true;
      default:
        return false;
    }
  }

  bool get isRateLimited {
    switch (this) {
      case Network.fireChainEvm:
        // case Network.fireChainSubstrate:
        return true;
      default:
        return false;
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
      case Network.polygonMainnet:
        return "https://rpc-mainnet.maticvigil.com/";
      case Network.polygonMumbai:
        return "https://rpc-mumbai.maticvigil.com/";
      case Network.avalancheMainnet:
        return "https://api.avax.network/ext/bc/C/rpc";
      case Network.avalancheFuji:
        return "https://api.avax-test.network/ext/bc/C/rpc";
      case Network.fantomMainnet:
        return "https://rpcapi.fantom.network/";
      case Network.fantomTestnet:
        return "https://rpc.testnet.fantom.network/";
      case Network.arbitrumMainnet:
        return "https://arb1.arbitrum.io/rpc";
      case Network.arbitrumGoerli:
        return "https://goerli.arbitrum.io/rpc";
      case Network.optimismMainnet:
        return "https://mainnet.optimism.io/";
      case Network.optimismGoerli:
        return "https://goerli.optimism.io/";
      case Network.binanceSmartChainMainnet:
        return "https://bsc-dataseed.binance.org/";
      case Network.binanceSmartChainTestnet:
        return "https://data-seed-prebsc-1-s1.binance.org:8545/";
      case Network.cronosMainnet:
        return "https://evm.cronos.org";
      case Network.cronosTestnet:
        return "https://evm-t3.cronos.org";
      case Network.fireChainEvm:
        return "https://rpc-testnet.5ire.network";
      // case Network.fireChainSubstrate:
      //   return "wss://rpc-testnet.5ire.network";
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
      case Network.polygonMainnet:
        return "polygon-matic";
      case Network.polygonMumbai:
        return "polygon-mumbai";
      case Network.avalancheMainnet:
        return "avalanche-mainnet";
      case Network.avalancheFuji:
        return "avalanche-fuji";
      case Network.fantomMainnet:
        return "fantom-mainnet";
      case Network.fantomTestnet:
        return "fantom-testnet";
      case Network.arbitrumMainnet:
        return "arbitrum-mainnet";
      case Network.arbitrumGoerli:
        return "arbitrum-goerli";
      case Network.optimismMainnet:
        return "optimism-mainnet";
      case Network.optimismGoerli:
        return "optimism-goerli";
      case Network.binanceSmartChainMainnet:
        return "binance-smart-chain-mainnet";
      case Network.binanceSmartChainTestnet:
        return "binance-smart-chain-testnet";
      case Network.cronosMainnet:
        return "cronos-mainnet";
      case Network.cronosTestnet:
        return "cronos-testnet";
      case Network.fireChainEvm:
        return "firechain-evm";
      // case Network.fireChainSubstrate:
      //   return "firechain-substrate";
      default:
        throw Exception("Unknown Network: $this");
    }
  }
}

extension StringExtension on String {
  Network? toNetwork() {
    switch (this) {
      case "ethereum-mainnet":
        return Network.ethereumMainnet;
      case "ethereum-sepolia":
        return Network.ethereumSepolia;
      case "ethereum-goerli":
        return Network.ethereumGoerli;
      case "polygon-matic":
        return Network.polygonMainnet;
      case "polygon-mumbai":
        return Network.polygonMumbai;
      case "avalanche-mainnet":
        return Network.avalancheMainnet;
      case "avalanche-fuji":
        return Network.avalancheFuji;
      case "fantom-mainnet":
        return Network.fantomMainnet;
      case "fantom-testnet":
        return Network.fantomTestnet;
      case "arbitrum-mainnet":
        return Network.arbitrumMainnet;
      case "arbitrum-goerli":
        return Network.arbitrumGoerli;
      case "optimism-mainnet":
        return Network.optimismMainnet;
      case "optimism-goerli":
        return Network.optimismGoerli;
      case "binance-smart-chain-mainnet":
        return Network.binanceSmartChainMainnet;
      case "binance-smart-chain-testnet":
        return Network.binanceSmartChainTestnet;
      case "cronos-mainnet":
        return Network.cronosMainnet;
      case "cronos-testnet":
        return Network.cronosTestnet;
      case "firechain-evm":
        return Network.fireChainEvm;
      // case "firechain-substrate":
      //   return Network.fireChainSubstrate;
      default:
        return null;
    }
  }
}

extension IntExtension on int {
  Network? toNetwork() {
    switch (this) {
      case 1:
        return Network.ethereumMainnet;
      case 11155111:
        return Network.ethereumSepolia;
      case 5:
        return Network.ethereumGoerli;
      case 137:
        return Network.polygonMainnet;
      case 80001:
        return Network.polygonMumbai;
      case 43114:
        return Network.avalancheMainnet;
      case 43113:
        return Network.avalancheFuji;
      case 250:
        return Network.fantomMainnet;
      case 4002:
        return Network.fantomTestnet;
      case 42161:
        return Network.arbitrumMainnet;
      case 421613:
        return Network.arbitrumGoerli;
      case 10:
        return Network.optimismMainnet;
      case 420:
        return Network.optimismGoerli;
      case 56:
        return Network.binanceSmartChainMainnet;
      case 97:
        return Network.binanceSmartChainTestnet;
      case 25:
        return Network.cronosMainnet;
      case 338:
        return Network.cronosTestnet;
      case 997:
        return Network.fireChainEvm;
      // case 998:
      //   return Network.fireChainSubstrate;
      default:
        return null;
    }
  }
}

enum GasOption {
  fast,
  standard,
  slow,
}

extension GasOptionExtension on GasOption {
  int get multiplier {
    switch (this) {
      case GasOption.fast:
        return 2;
      case GasOption.standard:
        return 1;
      case GasOption.slow:
        return 0;
      default:
        throw Exception("Unknown GasOption: $this");
    }
  }
}
