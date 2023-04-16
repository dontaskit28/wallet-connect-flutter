import 'package:web3dart/web3dart.dart';
import 'core/main.service.dart';

Future<EtherAmount> getBalance(
    Web3Client client, EthereumAddress address) async {
  return await client.getBalance(address).onError(
      (error, stackTrace) => throw Exception("Error in getting balance: $error"));
}

Transaction transactionObjectForNativeTokenTransfer(EthereumAddress to, BigInt value,
    [int? maxGas,
    BigInt? gasPrice,
    BigInt? maxFeePerGas,
    BigInt? maxPriorityFeePerGas]) {
  return createTransaction(
      to, value, null, maxGas, gasPrice, maxFeePerGas, maxPriorityFeePerGas);
}
