import 'dart:convert';
import 'package:web3dart/web3dart.dart';
import 'transaction.service.dart';

Future<DeployedContract> loadContract(
    String contractAbi, String contractName, String contractAddress) async {
  return DeployedContract(
      ContractAbi.fromJson(jsonEncode(contractAbi), contractName),
      EthereumAddress.fromHex(contractAddress));
}

Future<List<dynamic>> callContract(Web3Client client, DeployedContract contract,
    String functionName, List<dynamic> params) async {
  var function = contract.function(functionName);
  return await client
      .call(
        contract: contract,
        function: function,
        params: params,
      )
      .onError(
          (error, stackTrace) => throw Exception("Error in calling contract: $error"));
}

Transaction callContractTransaction(DeployedContract contract,
    String functionName, List<dynamic> params, BigInt? value,
    [int? maxGas,
    BigInt? gasPrice,
    BigInt? maxFeePerGas,
    BigInt? maxPriorityFeePerGas]) {
  var function = contract.function(functionName);
  return createContractTransaction(contract, function, params, value, maxGas,
      gasPrice, maxFeePerGas, maxPriorityFeePerGas);
}
