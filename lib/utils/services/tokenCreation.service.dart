// import 'dart:convert';
// import 'package:web3dart/web3dart.dart';
// import '../constants/network.dart';
// import 'package:cli/services/evm/misc.service.dart' as evm;

// Future<String> deployErc20Contract(
//     Web3Client client,
//     Network network,
//     Credentials credentials,
//     String name,
//     String symbol,
//     String totalSupply) async {
//   var contract = DeployedContract(
//     ContractAbi.fromJson(jsonEncode(tokenFacotryAbi), "Token Factory"),
//     EthereumAddress.fromHex("0x65a4ee9cCC47b1D4eCf93E37C6c4BEe89700DCc3"),
//   );
//   var deployFunc = contract.function('deployToken');
//   var gasOptions = await evm.getGasFee(client);
//   var deployTx = evm.createContractTransaction(
//       contract,
//       deployFunc,
//       [name, symbol, BigInt.parse(totalSupply)],
//       gasOptions[1].maxFeePerGas,
//       gasOptions[1].maxPriorityFeePerGas);
//   return await evm.sendTransaction(client, network, credentials, deployTx);
// }