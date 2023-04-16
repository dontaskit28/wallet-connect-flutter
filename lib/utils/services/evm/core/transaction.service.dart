import 'dart:typed_data';
import 'package:web3dart/web3dart.dart';
import '../../../constants/network.dart';

Transaction updateGasOptions(
    Transaction transaction,
    int? maxGas,
    BigInt? gasPrice,
    BigInt? maxFeePerGas,
    BigInt? maxPriorityFeePerGas,
    int? nonce) {
  return transaction.copyWith(
      maxGas: maxGas,
      gasPrice: gasPrice != null
          ? EtherAmount.fromBigInt(EtherUnit.wei, gasPrice)
          : null,
      maxPriorityFeePerGas: maxPriorityFeePerGas != null
          ? EtherAmount.fromBigInt(EtherUnit.wei, maxPriorityFeePerGas)
          : null,
      maxFeePerGas: maxFeePerGas != null
          ? EtherAmount.fromBigInt(EtherUnit.wei, maxFeePerGas)
          : null,
      nonce: nonce);
}

Future<int> getNonce(Web3Client client, EthereumAddress address) async {
  return await client
      .getTransactionCount(address, atBlock: BlockNum.pending())
      .onError(
          (error, stackTrace) => throw Exception("Error in getting nonce: $error"));
}

Future<String> sendTransaction(Web3Client client, Network network,
    Credentials credentials, Transaction transaction) async {
  return await client
      .sendTransaction(credentials, transaction, chainId: network.chainId)
      .onError((error, stackTrace) => 
          throw Exception("Error in sending transaction : $error"));
}

Transaction createTransaction(
    EthereumAddress to, BigInt? value, Uint8List? data,
    [int? maxGas,
    BigInt? gasPrice,
    BigInt? maxFeePerGas,
    BigInt? maxPriorityFeePerGas,
    int? nonce]) {
  return Transaction(
      to: to,
      value:
          value != null ? EtherAmount.fromBigInt(EtherUnit.wei, value) : null,
      data: data,
      maxGas: maxGas,
      gasPrice: gasPrice != null
          ? EtherAmount.fromBigInt(EtherUnit.wei, gasPrice)
          : null,
      maxPriorityFeePerGas: maxPriorityFeePerGas != null
          ? EtherAmount.fromBigInt(EtherUnit.wei, maxPriorityFeePerGas)
          : null,
      maxFeePerGas: maxFeePerGas != null
          ? EtherAmount.fromBigInt(EtherUnit.wei, maxFeePerGas)
          : null,
      nonce: nonce);
}

Transaction createContractTransaction(DeployedContract contract,
    ContractFunction function, List<dynamic> params, BigInt? value,
    [int? maxGas,
    BigInt? gasPrice,
    BigInt? maxFeePerGas,
    BigInt? maxPriorityFeePerGas,
    int? nonce]) {
  final data = function.encodeCall(params);
  return createTransaction(contract.address, value, data, maxGas, gasPrice,
      maxFeePerGas, maxPriorityFeePerGas, nonce);
}

Transaction speedUpTransaction(Transaction transaction) {
  var gasPrice = transaction.gasPrice?.getInWei;
  gasPrice = gasPrice != null ? gasPrice + (gasPrice * BigInt.from(0.25)) : null;
  var maxPriorityFeePerGas = transaction.maxPriorityFeePerGas?.getInWei;
  maxPriorityFeePerGas = maxPriorityFeePerGas != null
      ? maxPriorityFeePerGas + (maxPriorityFeePerGas * BigInt.from(0.1))
      : null;
  var maxFeePerGas = transaction.maxFeePerGas?.getInWei;
  maxFeePerGas =
      maxFeePerGas != null ? maxFeePerGas + (maxFeePerGas * BigInt.from(0.3)) : null;
  return updateGasOptions(transaction, transaction.maxGas, gasPrice, maxFeePerGas, maxPriorityFeePerGas, transaction.nonce);
}

Transaction cancelTransaction(Transaction transaction) {
  var tx = speedUpTransaction(transaction);
  return tx.copyWith(value: EtherAmount.zero(), data: null);
}
