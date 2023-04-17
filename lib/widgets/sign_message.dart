import 'package:flutter/material.dart';
import 'package:wallet_connect/wallet_connect.dart';

Widget signMessage({
  required WCClient wcClient,
  required BuildContext context,
  required message,
  required VoidCallback onReject,
  required VoidCallback onConfirm,
}) {
  return Padding(
    padding: const EdgeInsets.all(15),
    child: Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        if (wcClient.remotePeerMeta!.icons.isNotEmpty)
          Container(
            height: 100.0,
            width: 100.0,
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Image.network(wcClient.remotePeerMeta!.icons.first),
          ),
        Text(
          wcClient.remotePeerMeta!.name,
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
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
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
                onPressed: onReject,
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
                  backgroundColor: const Color(0xff37CBFA).withOpacity(0.6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: onConfirm,
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
  );
}
