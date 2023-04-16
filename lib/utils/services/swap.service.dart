import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:web3dart/credentials.dart';
import 'package:web3dart/crypto.dart';

const integratorString = "avex";
const fee = "0.1";

Future<Quote> getQuote(
    String apiUrl,
    String fromChain,
    String fromToken,
    String toChain,
    String toToken,
    String fromAmount,
    String fromAddress) async {
  final queryParameters = {
    'fromChain': fromChain,
    'toChain': toChain,
    'fromToken': fromToken,
    'toToken': toToken,
    'fromAmount': fromAmount,
    'fromAddress': fromAddress,
    'integrator': integratorString,
    'fee': fee
  };
  var url = Uri.https(apiUrl, 'v1/quote', queryParameters);
  var response = await http.get(url);
  if (response.statusCode != 200) {
    throw Exception('Failed to load quote');
  }
  final responseJson = jsonDecode(response.body);
  return Quote.fromJson(responseJson);
}

getStatus(String apiUrl, String bridge, String fromChain, String toChain,
    String txHash) async {
  final queryParameters = {
    'bridge': bridge,
    'fromChain': fromChain,
    'toChain': toChain,
    'txHash': txHash
  };
  var url = Uri.https(apiUrl, '/status', queryParameters);
  var response = await http.get(url);
  if (response.statusCode != 200) {
    throw Exception('Failed to load status');
  }
  return response.body;
}

class Quote {
  final String id;
  final String type;
  final String tool;
  final Action action;
  final Estimate? estimate;
  final String? integrator;
  final String? referrer;
  final String? execution;
  final QuoteTransaction? transactionRequest;

  Quote(
      {required this.id,
      required this.type,
      required this.tool,
      required this.action,
      this.estimate,
      this.integrator,
      this.referrer,
      this.execution,
      this.transactionRequest});

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
        id: json['id'],
        type: json['type'],
        tool: json['tool'],
        action: Action.fromJson(json['action']),
        estimate: json['estimate'] != null
            ? Estimate.fromJson(json['estimate'])
            : null,
        integrator: json['integrator'],
        referrer: json['referrer'],
        execution: json['execution'],
        transactionRequest: json['transactionRequest'] != null
            ? QuoteTransaction.fromJson(json['transactionRequest'])
            : null);
  }
}

class Action {
  final int fromChainId;
  final String fromAmount;
  final int toChainId;
  final Token fromToken;
  final Token toToken;
  final double? slippage;

  Action({
    required this.fromChainId,
    required this.fromAmount,
    required this.toChainId,
    required this.fromToken,
    required this.toToken,
    this.slippage,
  });

  factory Action.fromJson(Map<String, dynamic> json) {
    return Action(
      fromChainId: json['fromChainId'],
      fromAmount: json['fromAmount'],
      toChainId: json['toChainId'],
      fromToken: Token.fromJson(json['fromToken']),
      toToken: Token.fromJson(json['toToken']),
      slippage: json['slippage'],
    );
  }
}

class Token {
  final String address;
  final int decimals;
  final String symbol;
  final int chainId;
  final String? coinKey;
  final String name;
  final String? logoURI;
  final String? priceUSD;

  Token({
    required this.address,
    required this.decimals,
    required this.symbol,
    required this.chainId,
    this.coinKey,
    required this.name,
    this.logoURI,
    this.priceUSD,
  });

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      address: json['address'],
      decimals: json['decimals'],
      symbol: json['symbol'],
      chainId: json['chainId'],
      coinKey: json['coinKey'],
      name: json['name'],
      logoURI: json['logoURI'],
      priceUSD: json['priceUSD'],
    );
  }
}

class Estimate {
  final String fromAmount;
  final String toAmount;
  final String toAmountMin;
  final String approvalAddress;
  final List<FeeCosts>? feeCosts; //Chek if need to add optinal here
  final List<GasCost>? gasCosts;
  // data Arbitrary Data field not seems necessary

  Estimate({
    required this.fromAmount,
    required this.toAmount,
    required this.toAmountMin,
    required this.approvalAddress,
    this.feeCosts,
    this.gasCosts,
  });

  factory Estimate.fromJson(Map<String, dynamic> json) {
    return Estimate(
      fromAmount: json['fromAmount'],
      toAmount: json['toAmount'],
      toAmountMin: json['toAmountMin'],
      approvalAddress: json['approvalAddress'],
      feeCosts: json['feeCosts'] != null
          ? (json['feeCosts'] as List).map((i) => FeeCosts.fromJson(i)).toList()
          : null,
      gasCosts: json['gasCosts'] != null
          ? (json['gasCosts'] as List).map((i) => GasCost.fromJson(i)).toList()
          : null,
    );
  }
}

class FeeCosts {
  final String name;
  final String? description;
  final String percentage;
  final Token token;
  final String? amount;
  final String amountUSD;

  FeeCosts({
    required this.name,
    this.description,
    required this.percentage,
    required this.token,
    this.amount,
    required this.amountUSD,
  });

  factory FeeCosts.fromJson(Map<String, dynamic> json) {
    return FeeCosts(
      name: json['name'],
      description: json['description'],
      percentage: json['percentage'],
      token: Token.fromJson(json['token']),
      amount: json['amount'],
      amountUSD: json['amountUSD'],
    );
  }
}

class GasCost {
  final String type;
  final String? price;
  final String? estimate;
  final String? limit;
  final String amount;
  final String? amountUSD;
  final Token token;

  GasCost({
    required this.type,
    this.price,
    this.estimate,
    this.limit,
    required this.amount,
    this.amountUSD,
    required this.token,
  });

  factory GasCost.fromJson(Map<String, dynamic> json) {
    return GasCost(
      type: json['type'],
      price: json['price'],
      estimate: json['estimate'],
      limit: json['limit'],
      amount: json['amount'],
      amountUSD: json['amountUSD'],
      token: Token.fromJson(json['token']),
    );
  }
}

class QuoteTransaction {
  final EthereumAddress? to;
  final EthereumAddress? from;
  final int? gasLimit;
  final BigInt? gasPrice;
  final BigInt? value;
  final Uint8List? data;
  final int? chainId;
  final String? nonce;
  final String? maxFeePerGas;
  final String? maxPriorityFeePerGas;

  QuoteTransaction({
    this.to,
    this.from,
    this.gasLimit,
    this.gasPrice,
    this.value,
    this.data,
    this.chainId,
    this.nonce,
    this.maxFeePerGas,
    this.maxPriorityFeePerGas,
  });

  factory QuoteTransaction.fromJson(Map<String, dynamic> json) {
    return QuoteTransaction(
      to: json['to'] != null ? EthereumAddress.fromHex(json['to']) : null,
      from: json['from'] != null ? EthereumAddress.fromHex(json['from']) : null,
      gasLimit: json['gasLimit'] != null ? hexToDartInt(json['gasLimit']) : null,
      gasPrice: json['gasPrice'] != null ? hexToInt(json['gasPrice']) : null,
      value: json['value'] != null ? hexToInt(json['value']) : null,
      data: json['data'] != null ? hexToBytes(json['data']) : null,
      chainId: json['chainId'],
      nonce: json['nonce'],
      maxFeePerGas: json['maxFeePerGas'],
      maxPriorityFeePerGas: json['maxPriorityFeePerGas'],
    );
  }
}
