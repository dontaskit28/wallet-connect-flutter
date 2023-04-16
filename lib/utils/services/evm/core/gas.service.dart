import 'package:web3dart/web3dart.dart';
import 'package:eip1559/eip1559.dart' as eip1559;

// * Returns MaxPriorityFeePerGas, MaxFeePerGas
Future<List<eip1559.Fee>> getGasFee(Web3Client client) async {
  return await client.getGasInEIP1559().onError(
      (error, stackTrace) => throw Exception("Error in getting gas fee:  $error"));
}

// * Returns Gas Price
Future<EtherAmount> getGasPrice(Web3Client client) async {
  return await client.getGasPrice().onError(
      (error, stackTrace) => throw Exception("Error in getting gas price: $error"));
}

// * Returns Max Gas
Future<BigInt> estimateGas(Web3Client client, Transaction transaction) async {
  return await client
      .estimateGas(
          sender: transaction.from,
          to: transaction.to,
          value: transaction.value,
          data: transaction.data,
          gasPrice: transaction.gasPrice,
          maxFeePerGas: transaction.maxFeePerGas,
          maxPriorityFeePerGas: transaction.maxPriorityFeePerGas)
      .onError((error, stackTrace) =>
          throw Exception("Error in estimating gas fee: $error"));
}
