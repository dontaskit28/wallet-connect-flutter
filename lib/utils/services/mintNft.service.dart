// import 'dart:convert';
// import 'package:web3dart/web3dart.dart';
// import '../constants/network.dart';
// import 'package:cli/services/evm/misc.service.dart' as evm;

// Future<String> mintNft(Web3Client client, Network network,
//     Credentials credentials, String uri) async {
//   var contract = DeployedContract(
//     ContractAbi.fromJson(jsonEncode(nftAbi), "Nft"),
//     EthereumAddress.fromHex("0x765d3aE8D7711a9AdC08C09b76cD9488626B26CB"),
//   );
//   var createFunc = contract.function('createNFT');
//   var gasOptions = await evm.getGasFee(client);
//   var deployTx = evm.createContractTransaction(
//       contract,
//       createFunc,
//       [credentials.address, uri],
//       gasOptions[1].maxFeePerGas,
//       gasOptions[1].maxPriorityFeePerGas);
//   return await evm.sendTransaction(client, network, credentials, deployTx);
// }