import 'package:web3dart/web3dart.dart';
import '../../../constants/network.dart';
import 'package:http/http.dart';

Future<Web3Client> getSafeConnection(Network network) async {
  final client = getEvmClient(network);
  final isValid = await validateEvmConnection(client, network);
  if (isValid) {
    return client;
  } else {
    throw Exception("Invalid connection");
  }
}

Web3Client getEvmClient(Network network) {
  return Web3Client(network.rpc, Client());
}

Future<bool> validateEvmConnection(Web3Client client, Network network) async {
  try {
    final rpcChainId = await client.getChainId();
    return rpcChainId == BigInt.from(network.chainId);
  } catch (_) {
    return false;
  }
}
