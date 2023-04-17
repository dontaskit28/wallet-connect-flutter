import 'package:flutter/material.dart';
import 'package:wallet_connect/wallet_connect.dart';

Widget sessionRequest({
  required BuildContext context,
  required VoidCallback onReject,
  required VoidCallback onConfirm,
  required WCPeerMeta peerMeta,
  required Widget dropdown,
}) {
  return Container(
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
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: const Color(0xff373737),
                  ),
                  child: dropdown,
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
                onPressed: onReject,
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
                  backgroundColor: const Color(0xff37CBFA).withOpacity(0.6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: onConfirm,
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
  );
}
