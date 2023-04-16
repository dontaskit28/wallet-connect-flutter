// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:scan/scan.dart';
import 'dart:math';
import 'package:eip1559/eip1559.dart';
import 'package:eth_sig_util/eth_sig_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_wallet/simulation.dart';
import 'package:simple_wallet/widgets/get_key.dart';
import 'package:simple_wallet/widgets/not_connected.dart';
import 'package:simple_wallet/widgets/qr_scan_view.dart';
import 'package:wallet_connect/wallet_connect.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import '../utils/services/evm/core/main.service.dart' as evm;
import '../utils/constants/network.dart';
import '../utils/services/wallet/key.service.dart' as key;
import '../utils/services/evm/token.service.dart' as token;
// import 'network.dart';
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
  late String privateKey;
  Web3Client _web3client = Web3Client(rpcUri, http.Client());
  bool isprefs = false;
  bool isconnected = false;
  bool hasPrivateKey = false;
  TextEditingController controller = TextEditingController();
  ScanController scanController = ScanController();

  final List<String> networks = [
    'ethereum-goerli',
    'ethereum-mainnet',
    'ethereum-sepolia',
    'polygon-matic',
    'polygon-mumbai',
  ];
  String selectedNetwork = 'ethereum-goerli';

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
    _prefs = await SharedPreferences.getInstance();
    if (_prefs.containsKey('privateKey')) {
      privateKey = _prefs.getString('privateKey')!;
      hasPrivateKey = true;
    }

    if (_prefs.getKeys().length > 1) {
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
      backgroundColor: const Color(0xff1e1e1e),
      body: hasPrivateKey
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                const CircleAvatar(
                  backgroundColor: Color(0xff373737),
                  child: Icon(
                    Icons.people,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Connections",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: isprefs
                      ? _prefs.getKeys().length > 1
                          ? ListView.builder(
                              itemCount: _prefs.getKeys().length - 1,
                              itemBuilder: (context, index) {
                                final key = _prefs.getString('session');
                                var session =
                                    WCSessionStore.fromJson(jsonDecode(key!));
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
                                            await _wcClient
                                                .connectFromSessionStore(
                                              session,
                                            );
                                          },
                                          child: const Text('Connect'),
                                        ),
                                );
                              },
                            )
                          : const NotConnected()
                      : const Center(
                          child: CircularProgressIndicator(),
                        ),
                ),
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              const Color(0xff37CBFA).withOpacity(0.6),
                            ),
                            padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 20,
                              ),
                            ),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return const QRScanView();
                              },
                            )).then(
                              (value) {
                                if (value != null) {
                                  _qrScanHandler(value);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('No QR Code Found'),
                                    ),
                                  );
                                }
                              },
                            );
                          },
                          child: const Text(
                            "Scan QR Code",
                            style: TextStyle(fontSize: 24, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : GetKey(
              onPressed: () async {
                if (controller.text.isNotEmpty) {
                  privateKey = controller.text;
                  await _prefs.setString('privateKey', privateKey);
                  setState(() {
                    hasPrivateKey = true;
                  });
                }
              },
              controller: controller,
            ),
    );
  }

  _qrScanHandler(String value) {
    if (value.contains('bridge') && value.contains('key')) {
      final session = WCSession.from(value);
      debugPrint('session $session');
      final peerMeta = WCPeerMeta(
        name: "Avex Wallet",
        url: "https://avex.wallet",
        description: "Avex Wallet",
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
          top: Radius.circular(40),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return LimitedBox(
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: const BoxDecoration(color: Colors.black),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: const Color(0xff373737),
                              ),
                              child: DropdownButton<String>(
                                value: selectedNetwork,
                                icon: const Icon(Icons.arrow_drop_down),
                                iconSize: 24.0,
                                elevation: 16,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                ),
                                underline: Container(
                                  height: 0,
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedNetwork = newValue!;
                                  });
                                  _web3client = Web3Client(
                                    selectedNetwork.toNetwork()!.rpc,
                                    http.Client(),
                                  );
                                },
                                items: networks.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Row(
                                      children: [
                                        const CircleAvatar(
                                          radius: 17,
                                          backgroundColor: Colors.white,
                                        ),
                                        const SizedBox(width: 10),
                                        Text(value),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
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
                        Text(
                          peerMeta.name,
                          style: const TextStyle(
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: Column(
                        children: [
                          const SizedBox(height: 10.0),
                          Text(
                            "${peerMeta.name} wants to connect to your Avex wallet",
                            style: const TextStyle(color: Colors.grey),
                            overflow: TextOverflow.clip,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 100.0),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: const Color(0xff373737),
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
                                horizontal: 15,
                                vertical: 7,
                              ),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor:
                                  const Color(0xff37CBFA).withOpacity(0.6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () async {
                              _wcClient.approveSession(
                                accounts: [
                                  EthPrivateKey.fromHex(privateKey).address.hex
                                ],
                                chainId: selectedNetwork.toNetwork()!.chainId,
                              );
                              _web3client = Web3Client(
                                selectedNetwork.toNetwork()!.rpc,
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
                                vertical: 7,
                              ),
                              child: Text(
                                'Connect',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
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
                    backgroundColor: const Color(0xff37CBFA).withOpacity(0.6),
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
                    backgroundColor: const Color(0xff37CBFA).withOpacity(0.6),
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
        var gasOptions = await _web3client.getGasInEIP1559();
        Transaction transaction = Transaction(
          from: EthereumAddress.fromHex(ethereumTransaction.from),
          to: EthereumAddress.fromHex(ethereumTransaction.to!),
          value:
              EtherAmount.inWei(BigInt.parse(ethereumTransaction.value ?? '0')),
          data: hexToBytes(ethereumTransaction.data!),
          maxFeePerGas: EtherAmount.fromBigInt(
            EtherUnit.wei,
            gasOptions[1].maxFeePerGas,
          ),
          maxPriorityFeePerGas: EtherAmount.fromBigInt(
            EtherUnit.wei,
            gasOptions[1].maxPriorityFeePerGas,
          ),
        );
        final creds = EthPrivateKey.fromHex(privateKey);
        final tx = await _web3client.signTransaction(
          creds,
          transaction,
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
          // var nativeTokenTransaction = await evm.sendTransaction(
          //     client, network, credentials, rawTransaction);
          // print("transaction: $nativeTokenTransaction");
          // var gasOptions = await _web3client.getGasInEIP1559();
          // Transaction transaction = Transaction(
          //   from: EthereumAddress.fromHex(ethereumTransaction.from),
          //   to: EthereumAddress.fromHex(ethereumTransaction.to!),
          //   value: EtherAmount.inWei(
          //       BigInt.parse(ethereumTransaction.value ?? '0')),
          //   data: hexToBytes(ethereumTransaction.data!),
          //   maxFeePerGas: EtherAmount.fromBigInt(
          //     EtherUnit.wei,
          //     gasOptions[1].maxFeePerGas,
          //   ),
          //   maxPriorityFeePerGas: EtherAmount.fromBigInt(
          //     EtherUnit.wei,
          //     gasOptions[1].maxPriorityFeePerGas,
          //   ),
          // );

          // final creds = EthPrivateKey.fromHex(privateKey);
          // final txhash = await _web3client.sendTransaction(
          //   creds,
          //   transaction,
          //   chainId: _wcClient.chainId!,
          // );
          // debugPrint('txhash $txhash');
          // _wcClient.approveRequest<String>(
          //   id: id,
          //   result: nativeTokenTransaction,
          // );
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
      selectedNetwork.toNetwork()!,
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

    List<SimulationResponseChanges> withdraw = [];
    List<SimulationResponseChanges> deposit = [];
    for (int i = 0; i < response.changes!.length; i++) {
      if (response.changes![i].from == ethereumTransaction.from) {
        withdraw.add(response.changes![i]);
      } else if (response.changes![i].to == ethereumTransaction.from) {
        deposit.add(response.changes![i]);
      }
    }
    var network = selectedNetwork.toNetwork()!;
    var client = await evm.getSafeConnection(network);
    var credentials = key.createEthereumAccountFromHex(privateKey);
    final transactionSpeed = GasOption.standard.multiplier;
    var rawTransaction = token.transactionObjectForNativeTokenTransfer(
      EthereumAddress.fromHex(ethereumTransaction.to!),
      BigInt.parse(ethereumTransaction.value!),
    );
    BigInt? maxFeePerGas;
    BigInt? maxPriorityFeePerGas;
    EtherAmount? gasPrice;
    var balance = await token.getBalance(
      client,
      credentials.address,
    );
    debugPrint("balance: $balance");
    if (balance.getInWei <= BigInt.parse(ethereumTransaction.value!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Insufficient Balance"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (network.isEip1559) {
      var gasFee = await evm.getGasFee(client);
      maxFeePerGas = gasFee[transactionSpeed].maxFeePerGas;
      maxPriorityFeePerGas = gasFee[transactionSpeed].maxPriorityFeePerGas;
    } else {
      gasPrice = await evm.getGasPrice(client);
    }
    rawTransaction = evm.updateGasOptions(rawTransaction, null,
        gasPrice?.getInWei, maxFeePerGas, maxPriorityFeePerGas, null);

    var estimatedGas = await evm.estimateGas(client, rawTransaction);
    debugPrint("estimatedGas: $estimatedGas");

    var nonce = await evm.getNonce(client, credentials.address);
    debugPrint("nonce: $nonce");

    rawTransaction = evm.updateGasOptions(
        rawTransaction, estimatedGas.toInt(), null, null, null, nonce);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReviewTransaction(
          ethereumTransaction: ethereumTransaction,
          title: title,
          response: response,
          withdraw: withdraw,
          deposit: deposit,
          client: client,
          network: network,
          credentials: credentials,
          transaction: rawTransaction,
          wcClient: _wcClient,
          id: id,
        ),
      ),
    );
  }

  _onSign(
    int id,
    WCEthereumSignMessage ethereumSignMessage,
  ) {
    String message = ethereumSignMessage.data!;
    if (message.startsWith('0x')) {
      message = message.substring(2);
      final bytes = hexToBytes(message);
      if (bytes.length % 16 == 0) {
        message = utf8.decode(bytes, allowMalformed: true);
      } else {
        message = utf8.decode(bytes);
      }
    }

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
                            message,
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
                            backgroundColor:
                                const Color(0xff37CBFA).withOpacity(0.6),
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
                            child: Text(
                              'SIGN',
                              style: TextStyle(color: Colors.white),
                            ),
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
