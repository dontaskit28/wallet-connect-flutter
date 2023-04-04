import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wallet_connect/wallet_connect.dart';
import 'package:web3dart/web3dart.dart';
import 'simulation.dart';

// ignore: must_be_immutable
class ReviewTransaction extends StatefulWidget {
  WCEthereumTransaction ethereumTransaction;
  VoidCallback onConfirm;
  VoidCallback onReject;
  SimulationResponse response;
  String title;
  List<SimulationResponseChanges> withdraw;
  List<SimulationResponseChanges> deposit;
  ReviewTransaction({
    super.key,
    required this.ethereumTransaction,
    required this.onConfirm,
    required this.onReject,
    required this.title,
    required this.response,
    required this.withdraw,
    required this.deposit,
  });

  @override
  State<ReviewTransaction> createState() => _ReviewTransactionState();
}

class _ReviewTransactionState extends State<ReviewTransaction> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Row(
              children: const [
                Icon(Icons.arrow_back),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Review Your Transaction',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            widget.withdraw.isEmpty
                ? Container()
                : Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Withdrawing".toUpperCase(),
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 37, 172, 202),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Account 1"),
                              Text(
                                  "${widget.ethereumTransaction.from.substring(0, 5)}...${widget.ethereumTransaction.from.substring(36)}"),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: widget.withdraw.length.toDouble() * 80,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        child: ListView.builder(
                          itemCount: widget.withdraw.length,
                          padding: const EdgeInsets.all(0),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 25,
                                        child: Image(
                                          image: NetworkImage(
                                              widget.withdraw[index].logo ??
                                                  ""),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        widget.withdraw[index].symbol,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "${double.parse(widget.withdraw[index].amount).toStringAsPrecision(3)} ${widget.withdraw[index].symbol}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Text("\$0.00 USD"),
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Using dApps",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(widget.deposit.isEmpty
                          ? "Sending"
                          : "${widget.deposit[0].contractAddress?.substring(0, 5)}...${widget.deposit[0].contractAddress?.substring(36)}"),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            widget.deposit.isEmpty
                ? Container()
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Text(
                              "Depositing".toUpperCase(),
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 37, 172, 202),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Account 1"),
                              Text(
                                  "${widget.ethereumTransaction.to?.substring(0, 5)}...${widget.ethereumTransaction.to?.substring(36)}"),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: widget.deposit.length.toDouble() * 80,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        child: ListView.builder(
                          itemCount: widget.deposit.length,
                          padding: const EdgeInsets.all(0),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 25,
                                        child: Image(
                                          image: NetworkImage(
                                              widget.deposit[index].logo ?? ""),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        widget.deposit[index].symbol,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Text("Estimated"),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "${double.parse(widget.deposit[index].amount).toStringAsPrecision(3)} ${widget.deposit[index].symbol}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: const [
                                          Text("Estimated"),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text("\$0.00 USD"),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("Estimated gas fee"),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${(BigInt.parse(widget.response.gasUsed!.substring(2), radix: 16) / BigInt.from(pow(10, 9))).toStringAsPrecision(3)} ETH",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                                "Max ${widget.ethereumTransaction.gasLimit ?? "0.0003"} ETH"),
                          ],
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("Total Cost"),
                        Text(
                          "${((BigInt.parse(widget.response.gasUsed!.substring(2), radix: 16) / BigInt.from(pow(10, 9))) + (BigInt.parse(widget.ethereumTransaction.value?.substring(2) ?? "0", radix: 16) / BigInt.from(pow(10, 18)))).toStringAsPrecision(3)} ETH",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.grey.shade800,
                        ),
                        shape: MaterialStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      onPressed: widget.onReject,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 15,
                        ),
                        child: Text(
                          "Reject",
                          style: TextStyle(
                            color: Color.fromARGB(255, 92, 157, 210),
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 30),
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          const Color(0xff37CBFA).withOpacity(0.6),
                        ),
                        shape: MaterialStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      onPressed: widget.onConfirm,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 15,
                        ),
                        child: Text(
                          "Confirm",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
