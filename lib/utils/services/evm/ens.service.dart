import 'package:ens_dart/ens_dart.dart';
import 'package:web3dart/web3dart.dart';
import '../../constants/network.dart';
import 'core/main.service.dart';

Future<String> getEnsName(EthereumAddress address) async {
  try {
    var ens = Ens(client: await getSafeConnection(Network.ethereumMainnet));
    return await ens.withAddress(address).getName();
  } catch (_) {
    return "Not Found";
  }
}

Future<EthereumAddress> resolveEnsName(String name) async {
  var ens = Ens(client: await getSafeConnection(Network.ethereumMainnet));
  return await ens.withName(name).getAddress();
}
