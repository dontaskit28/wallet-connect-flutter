import 'package:flutter/material.dart';

class NotConnected extends StatelessWidget {
  VoidCallback onPress;
  NotConnected({super.key, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 60,
        left: 20,
        right: 20,
        bottom: 60,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: const [
              Image(
                image: NetworkImage(
                  'https://workablehr.s3.amazonaws.com/uploads/account/open_graph_logo/492879/social?1675329233000',
                ),
                height: 50,
                width: 50,
              ),
              Text(
                "You Connections will appear here",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Row(
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
                  onPressed: onPress,
                  child: const Text(
                    "Scan QR Code",
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
