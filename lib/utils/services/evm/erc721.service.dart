import 'dart:convert';
import 'package:web3dart/web3dart.dart';
import '../../services/evm/core/main.service.dart' as evm;
import '../../services/evm/misc.service.dart' as misc;

Future<DeployedContract> loadErc721Contract(String tokenAddress) {
  return evm.loadContract(jsonEncode(misc.erc721Abi), "ERC721", tokenAddress);
}

Future<bool> checkNftApproval(Web3Client client, String tokenAddress,
    EthereumAddress approvalAddress, BigInt tokenId) async {
  var tokenContract = await loadErc721Contract(tokenAddress);
  var approval =
      await evm.callContract(client, tokenContract, 'getApproved', [tokenId]);
  return (approval.first == approvalAddress);
}

Future<Transaction> transactionObjectForSetApproval(
    String tokenAddress, EthereumAddress approvalAddress, BigInt tokenId,
    [int? maxGas,
    BigInt? gasPrice,
    BigInt? maxFeePerGas,
    BigInt? maxPriorityFeePerGas]) async {
  var tokenContract = await loadErc721Contract(tokenAddress);
  return evm.callContractTransaction(
      tokenContract,
      'approve',
      [approvalAddress, tokenId],
      BigInt.zero,
      maxGas,
      gasPrice,
      maxFeePerGas,
      maxPriorityFeePerGas);
}

Future<Transaction> transactionObjectForNftTransfer(String tokenAddress,
    EthereumAddress from, EthereumAddress to, BigInt tokenId,
    [int? maxGas,
    BigInt? gasPrice,
    BigInt? maxFeePerGas,
    BigInt? maxPriorityFeePerGas]) async {
  var tokenContract = await loadErc721Contract(tokenAddress);
  return evm.callContractTransaction(
      tokenContract,
      'transferFrom',
      [from, to, tokenId],
      BigInt.zero,
      maxGas,
      gasPrice,
      maxFeePerGas,
      maxPriorityFeePerGas);
}
