// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously
import 'dart:convert';
import 'dart:math';
import 'package:eip1559/eip1559.dart';
import 'package:eth_sig_util/eth_sig_util.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_wallet/simulation.dart';
import 'package:wallet_connect/wallet_connect.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'network.dart';
import 'review.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wallet Connect',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: const ColorScheme.dark(),
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

const rpcUri = 'https://goerli.infura.io/v3/04487b56429746eda260c75599f9747a';

class _MyHomePageState extends State<MyHomePage> {
  late WCClient _wcClient;
  late SharedPreferences _prefs;
  late String walletAddress, privateKey;
  Web3Client _web3client = Web3Client(rpcUri, http.Client());
  bool isprefs = false;
  bool isconnected = false;

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  _initialize() async {
    _wcClient = WCClient(
      onSessionRequest: _onSessionRequest,
      onFailure: _onSessionError,
      onDisconnect: _onSessionClosed,
      onEthSign: _onSign,
      onEthSignTransaction: _onSignTransaction,
      onEthSendTransaction: _onSendTransaction,
      onCustomRequest: (_, __) {},
      onConnect: _onConnect,
      onWalletSwitchNetwork: _onSwitchNetwork,
    );
    walletAddress = "0x9f8a6ae7D45D46B7Ff502A7a3A70b646470422Fc";
    privateKey = "";
    _prefs = await SharedPreferences.getInstance();
    if (_prefs.getKeys().length == 1) {
      final key = _prefs.getString('session');
      var session = WCSessionStore.fromJson(jsonDecode(key!));
      await _wcClient.connectFromSessionStore(session);
    }
    setState(() {
      isprefs = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wallet Connect"),
        actions: [
          IconButton(
            onPressed: () async {
              var response = await FlutterBarcodeScanner.scanBarcode(
                '#ff6666',
                'Cancel',
                true,
                ScanMode.QR,
              );
              _qrScanHandler(response);
            },
            icon: const Icon(Icons.qr_code_scanner),
          ),
          const SizedBox(width: 15),
        ],
      ),
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 6,
            child: isprefs
                ? ListView.builder(
                    itemCount: _prefs.getKeys().length,
                    itemBuilder: (context, index) {
                      final key = _prefs.getString('session');
                      var session = WCSessionStore.fromJson(jsonDecode(key!));
                      return ListTile(
                        title: Text(session.remotePeerMeta.name),
                        subtitle: Text(session.remotePeerMeta.url),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            session.remotePeerMeta.icons.first,
                          ),
                        ),
                        trailing: _wcClient.peerId == session.peerId
                            ? TextButton(
                                onPressed: () async {
                                  _wcClient.killSession();
                                },
                                child: const Text('Disconnect'),
                              )
                            : TextButton(
                                onPressed: () async {
                                  await _wcClient.connectFromSessionStore(
                                    session,
                                  );
                                },
                                child: const Text('Connect'),
                              ),
                      );
                    },
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
        ],
      ),
    );
  }

  _qrScanHandler(String value) {
    if (value.contains('bridge') && value.contains('key')) {
      final session = WCSession.from(value);
      debugPrint('session $session');
      final peerMeta = WCPeerMeta(
        name: "Apex Wallet",
        url: "https://apex.wallet",
        description: "Apex Wallet",
        icons: [
          "https://gblobscdn.gitbook.com/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png"
        ],
      );
      _wcClient.connectNewSession(session: session, peerMeta: peerMeta);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid URL"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  _onConnect() {
    setState(() {
      isconnected = true;
    });
  }

  _onSwitchNetwork(int id, int chainId) async {
    await _wcClient.updateSession(chainId: chainId);
    _wcClient.approveRequest<void>(id: id, result: null);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Changed network to $chainId.'),
    ));
  }

  _onSessionRequest(int id, WCPeerMeta peerMeta) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (_) {
        return Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      if (peerMeta.icons.isNotEmpty)
                        Container(
                          height: 100.0,
                          width: 100.0,
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Image.network(peerMeta.icons.first),
                        ),
                      const SizedBox(height: 10.0),
                      Text(peerMeta.name),
                    ],
                  ),
                  if (peerMeta.description.isNotEmpty)
                    Column(
                      children: [
                        const SizedBox(height: 10.0),
                        Text(peerMeta.description),
                      ],
                    ),
                  if (peerMeta.url.isNotEmpty)
                    Column(
                      children: [
                        const SizedBox(height: 10.0),
                        Text(peerMeta.url),
                      ],
                    ),
                  const SizedBox(height: 40.0),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            _wcClient.rejectSession();
                            Navigator.pop(context);
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Text('REJECT'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            _wcClient.approveSession(
                              accounts: [walletAddress],
                              chainId: Network.ethereumGoerli.chainId,
                            );
                            _web3client = Web3Client(
                              Network.ethereumGoerli.rpc,
                              http.Client(),
                            );

                            await _prefs.setString(
                              'session',
                              jsonEncode(_wcClient.sessionStore.toJson()),
                            );

                            setState(() {
                              isconnected = true;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Connected"),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.pop(context);
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 10,
                            ),
                            child: Text('APPROVE'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  _onSessionError(dynamic message) {
    showDialog(
      context: context,
      builder: (_) {
        return SimpleDialog(
          title: const Text("Error"),
          contentPadding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 16.0),
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text('Some Error Occured. $message'),
            ),
            Row(
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('CLOSE'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  _onSessionClosed(int? code, String? reason) {
    _prefs.remove('session');
    setState(() {
      isconnected = false;
    });

    showDialog(
      context: context,
      builder: (_) {
        return SimpleDialog(
          title: const Text("Session Ended"),
          contentPadding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 16.0),
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text('Some Error Occured. ERROR CODE: $code'),
            ),
            if (reason != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text('Failure Reason: $reason'),
              ),
            Row(
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('CLOSE'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  _onSignTransaction(
    int id,
    WCEthereumTransaction ethereumTransaction,
  ) {
    _onTransaction(
      id: id,
      ethereumTransaction: ethereumTransaction,
      title: 'Sign Transaction',
      onConfirm: () async {
        final creds = EthPrivateKey.fromHex(privateKey);
        final tx = await _web3client.signTransaction(
          creds,
          _wcEthTxToWeb3Tx(ethereumTransaction),
          chainId: _wcClient.chainId!,
        );
        _wcClient.approveRequest<String>(
          id: id,
          result: bytesToHex(tx),
        );
        Navigator.pop(context);
      },
      onReject: () {
        _wcClient.rejectRequest(id: id);
        Navigator.pop(context);
      },
    );
  }

  _onSendTransaction(
    int id,
    WCEthereumTransaction ethereumTransaction,
  ) {
    _onTransaction(
      id: id,
      ethereumTransaction: ethereumTransaction,
      title: 'Send Transaction',
      onConfirm: () async {
        try {
          var gasOptions = await _web3client.getGasInEIP1559();
          Transaction transaction = Transaction(
            from: EthereumAddress.fromHex(ethereumTransaction.from),
            to: EthereumAddress.fromHex(ethereumTransaction.to!),
            maxGas: ethereumTransaction.gasLimit != null
                ? int.tryParse(ethereumTransaction.gasLimit!)
                : gasOptions[1].maxFeePerGas.toInt(),
            gasPrice: ethereumTransaction.gasPrice != null
                ? EtherAmount.inWei(BigInt.parse(ethereumTransaction.gasPrice!))
                : EtherAmount.inWei(gasOptions[1].estimatedGas),
            value: EtherAmount.inWei(
                BigInt.parse(ethereumTransaction.value ?? '0')),
            data: hexToBytes(ethereumTransaction.data!),
            nonce: ethereumTransaction.nonce != null
                ? int.tryParse(ethereumTransaction.nonce!)
                : null,
          );

          final creds = EthPrivateKey.fromHex(privateKey);
          final txhash = await _web3client.sendTransaction(
            creds,
            transaction,
            chainId: _wcClient.chainId!,
          );
          debugPrint('txhash $txhash');
          _wcClient.approveRequest<String>(
            id: id,
            result: txhash,
          );
        } catch (e) {
          _wcClient.rejectRequest(id: id);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Transaction Failed: $e"),
              backgroundColor: Colors.red,
            ),
          );
        } finally {
          Navigator.pop(context);
        }
      },
      onReject: () {
        _wcClient.rejectRequest(id: id);
        Navigator.pop(context);
      },
    );
  }

  _onTransaction({
    required int id,
    required WCEthereumTransaction ethereumTransaction,
    required String title,
    required VoidCallback onConfirm,
    required VoidCallback onReject,
  }) async {
    SimulationResponse response = await simulateTransaction(
      Network.ethereumGoerli,
      EthereumAddress.fromHex(ethereumTransaction.from),
      _wcEthTxToWeb3Tx(ethereumTransaction),
    );
    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Transaction Failed: ${response.error}"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReviewTransaction(
          ethereumTransaction: ethereumTransaction,
          onConfirm: onConfirm,
          onReject: onReject,
          title: title,
          response: response,
        ),
      ),
    );
  }

  _onSign(
    int id,
    WCEthereumSignMessage ethereumSignMessage,
  ) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  if (_wcClient.remotePeerMeta!.icons.isNotEmpty)
                    Container(
                      height: 100.0,
                      width: 100.0,
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child:
                          Image.network(_wcClient.remotePeerMeta!.icons.first),
                    ),
                  Text(
                    _wcClient.remotePeerMeta!.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 20.0,
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: const Text(
                      'Sign Message',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ExpansionTile(
                        tilePadding: EdgeInsets.zero,
                        title: const Text(
                          'Message',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        children: [
                          Text(
                            ethereumSignMessage.data!,
                            style: const TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            _wcClient.rejectRequest(id: id);
                            Navigator.pop(context);
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 10,
                            ),
                            child: Text('REJECT'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            String signedDataHex;
                            if (ethereumSignMessage.type ==
                                WCSignType.TYPED_MESSAGE) {
                              signedDataHex = EthSigUtil.signTypedData(
                                privateKey: privateKey,
                                jsonData: ethereumSignMessage.data!,
                                version: TypedDataVersion.V4,
                              );
                            } else {
                              final creds = EthPrivateKey.fromHex(privateKey);
                              final encodedMessage =
                                  hexToBytes(ethereumSignMessage.data!);
                              final signedData = await creds
                                  .signPersonalMessage(encodedMessage);
                              signedDataHex =
                                  bytesToHex(signedData, include0x: true);
                            }
                            debugPrint('SIGNED $signedDataHex');
                            _wcClient.approveRequest<String>(
                              id: id,
                              result: signedDataHex,
                            );
                            Navigator.pop(context);
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 10,
                            ),
                            child: Text('SIGN'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Transaction _wcEthTxToWeb3Tx(WCEthereumTransaction ethereumTransaction) {
    return Transaction(
      from: EthereumAddress.fromHex(ethereumTransaction.from),
      to: EthereumAddress.fromHex(ethereumTransaction.to!),
      maxGas: ethereumTransaction.gasLimit != null
          ? int.tryParse(ethereumTransaction.gasLimit!)
          : null,
      gasPrice: ethereumTransaction.gasPrice != null
          ? EtherAmount.inWei(BigInt.parse(ethereumTransaction.gasPrice!))
          : null,
      value: EtherAmount.inWei(BigInt.parse(ethereumTransaction.value ?? '0')),
      data: hexToBytes(ethereumTransaction.data!),
      nonce: ethereumTransaction.nonce != null
          ? int.tryParse(ethereumTransaction.nonce!)
          : null,
    );
  }
}
