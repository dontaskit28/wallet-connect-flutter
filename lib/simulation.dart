import 'dart:convert';
import 'utils/constants/network.dart';
import 'package:convert/convert.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

const simulateApiUrl = "https://simulation.devdeg.com";
Future<SimulationResponse> simulate(
    String simulationUrl, SimulationRequest simulationData) async {
  var body = jsonEncode(simulationData);
  final response = await http.post(
    Uri.parse(simulationUrl),
    headers: {
      'Content-Type': 'application/json',
    },
    body: body,
  );
  if (response.statusCode == 200) {
    return SimulationResponse.fromJson(jsonDecode(response.body));
  } else {
    print(response.reasonPhrase);
    throw Exception('Failed to simulate transaction');
  }
}

Future<SimulationResponse> simulateTransaction(
  Network network,
  EthereumAddress from,
  Transaction transaction,
) async {
  var value = transaction.value?.getInWei.toRadixString(16);
  var gas = transaction.maxGas?.toRadixString(16);
  var gasPrice = transaction.gasPrice?.getInWei.toRadixString(16);
  var maxFeePerGas = transaction.maxFeePerGas?.getInWei.toRadixString(16);
  var maxPriorityFeePerGas =
      transaction.maxPriorityFeePerGas?.getInWei.toRadixString(16);

  final simulationRequest = SimulationRequest(
    chain: network.chainName,
    params: [
      SimulationParams(
        from: from.toString(),
        to: transaction.to.toString(),
        value: transaction.value != null ? "0x$value" : null,
        data: transaction.data != null
            ? bytesToHex(transaction.data as List<int>, include0x: true)
            : null,
        gas: transaction.maxGas != null ? "0x$gas" : null,
        gasPrice: transaction.gasPrice != null ? "0x$gasPrice" : null,
        maxFeePerGas:
            transaction.maxFeePerGas != null ? "0x$maxFeePerGas" : null,
        maxPriorityFeePerGas: transaction.maxPriorityFeePerGas != null
            ? "0x$maxPriorityFeePerGas"
            : null,
      )
    ],
  );
  final simulationResponse =
      await simulate("$simulateApiUrl/simulate/assetChange", simulationRequest);
  return simulationResponse;
}

class SimulationRequest {
  final String chain;
  final List<SimulationParams> params;

  SimulationRequest({
    required this.chain,
    required this.params,
  });

  factory SimulationRequest.fromJson(Map<String, dynamic> json) {
    return SimulationRequest(
        chain: json['chain'],
        params: (json['params'] as List)
            .map((e) => SimulationParams.fromJson(e))
            .toList());
  }

  Map<String, dynamic> toJson() {
    return {
      'chain': chain,
      'params': params.map((e) => e.toJson()).toList(),
    };
  }
}

class SimulationParams {
  final String from;
  final String to;
  final String? value;
  final String? data;
  final String? gas;
  final String? gasPrice;
  final String? maxFeePerGas;
  final String? maxPriorityFeePerGas;

  SimulationParams({
    required this.from,
    required this.to,
    this.value,
    this.data,
    this.gas,
    this.gasPrice,
    this.maxFeePerGas,
    this.maxPriorityFeePerGas,
  });

  factory SimulationParams.fromJson(Map<String, dynamic> json) {
    return SimulationParams(
        from: json['from'],
        to: json['to'],
        value: json['value'],
        data: json['data'],
        gas: json['gas'],
        gasPrice: json['gasPrice'],
        maxFeePerGas: json['maxFeePerGas'],
        maxPriorityFeePerGas: json['maxPriorityFeePerGas']);
  }

  Map<String, dynamic> toJson() {
    return {
      'from': from,
      'to': to,
      'value': value,
      'data': data,
      'gas': gas,
      'gasPrice': gasPrice,
      'maxFeePerGas': maxFeePerGas,
      'maxPriorityFeePerGas': maxPriorityFeePerGas,
    };
  }
}

class SimulationResponse {
  final List<SimulationResponseChanges>? changes;
  final String? gasUsed;
  final Map<String, dynamic>? error;

  SimulationResponse({
    this.changes,
    this.gasUsed,
    this.error,
  });

  factory SimulationResponse.fromJson(Map<String, dynamic> json) {
    return SimulationResponse(
        gasUsed: json['gasUsed'],
        error: json['error'],
        changes: json['changes'] != null
            ? (json['changes'] as List)
                .map((e) => SimulationResponseChanges.fromJson(e))
                .toList()
            : null);
  }
}

class SimulationResponseChanges {
  final String assetType;
  final String changeType;
  final String from;
  final String to;
  final String rawAmount;
  final String amount;
  final String symbol;
  final String? contractAddress;
  final String? tokenId;
  final int? decimals;
  final String? name;
  final String? logo;

  SimulationResponseChanges({
    required this.assetType,
    required this.changeType,
    required this.from,
    required this.to,
    required this.rawAmount,
    required this.amount,
    required this.symbol,
    this.contractAddress,
    this.tokenId,
    this.decimals,
    this.name,
    this.logo,
  });

  factory SimulationResponseChanges.fromJson(Map<String, dynamic> json) {
    return SimulationResponseChanges(
        assetType: json['assetType'],
        changeType: json['changeType'],
        from: json['from'],
        to: json['to'],
        rawAmount: json['rawAmount'],
        amount: json['amount'],
        symbol: json['symbol'],
        contractAddress: json['contractAddress'],
        tokenId: json['tokenId'],
        decimals: json['decimals'],
        name: json['name'],
        logo: json['logo']);
  }
}
