import 'dart:convert';
import 'package:web3dart/web3dart.dart';
import '../../services/evm/core/main.service.dart' as evm;
import '../../services/evm/misc.service.dart' as misc;

Future<DeployedContract> loadErc20Contract(String tokenAddress) {
  return evm.loadContract(
      jsonEncode(misc.erc20Abi), "ERC20", tokenAddress);
}

Future<bool> checkAllowance(Web3Client client, Credentials credentials,
    String tokenAddress, EthereumAddress approvalAddress, BigInt amount) async {
  if (tokenAddress == '0x0000000000000000000000000000000000000000') return true;
  var tokenContract = await loadErc20Contract(tokenAddress);
  var allowance = await evm.callContract(client, tokenContract, 'allowance',
      [credentials.address, approvalAddress]);
  return (allowance.first >= amount);
}

Future<Transaction> transactionObjectForSetAllowance(
    String tokenAddress, EthereumAddress approvalAddress, BigInt amount,
    [int? maxGas,
    BigInt? gasPrice,
    BigInt? maxFeePerGas,
    BigInt? maxPriorityFeePerGas]) async {
  var tokenContract = await loadErc20Contract(tokenAddress);
  return evm.callContractTransaction(
      tokenContract,
      'approve',
      [approvalAddress, amount],
      BigInt.zero,
      maxGas,
      gasPrice,
      maxFeePerGas,
      maxPriorityFeePerGas);
}

Future<Transaction> transactionObjectForTokenTransfer(
    String tokenAddress, EthereumAddress to, BigInt amount,
    [int? maxGas,
    BigInt? gasPrice,
    BigInt? maxFeePerGas,
    BigInt? maxPriorityFeePerGas]) async {
  var tokenContract = await loadErc20Contract(tokenAddress);
  return evm.callContractTransaction(
      tokenContract,
      'transfer',
      [to, amount],
      BigInt.zero,
      maxGas,
      gasPrice,
      maxFeePerGas,
      maxPriorityFeePerGas);
}
