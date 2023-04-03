import 'package:flutter/material.dart';
import 'package:scan/scan.dart';
import 'package:images_picker/images_picker.dart';

class QRScanView extends StatefulWidget {
  const QRScanView({Key? key}) : super(key: key);

  @override
  _QRScanViewState createState() => _QRScanViewState();
}

class _QRScanViewState extends State<QRScanView> {
  final ScanController controller = ScanController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan"),
        backgroundColor: Colors.grey.shade900,
        elevation: 0,
      ),
      backgroundColor: Colors.grey.shade900,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  height: 260,
                  width: 260,
                  child: ScanView(
                    controller: controller,
                    scanAreaScale: 1,
                    scanLineColor: Colors.white,
                    onCapture: (data) {
                      Navigator.pop(context, data);
                    },
                  ),
                ),
                Container(
                  height: 80,
                  width: 80,
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Colors.white,
                        width: 4,
                      ),
                      left: BorderSide(
                        color: Colors.white,
                        width: 4,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    height: 80,
                    width: 80,
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Colors.white,
                          width: 4,
                        ),
                        right: BorderSide(
                          color: Colors.white,
                          width: 4,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                    height: 80,
                    width: 80,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.white,
                          width: 4,
                        ),
                        left: BorderSide(
                          color: Colors.white,
                          width: 4,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    height: 80,
                    width: 80,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.white,
                          width: 4,
                        ),
                        right: BorderSide(
                          color: Colors.white,
                          width: 4,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            const Text("Scan the QR code"),
            const SizedBox(
              height: 20,
            ),
            CircleAvatar(
              child: IconButton(
                onPressed: () async {
                  List<Media>? res = await ImagesPicker.pick();
                  if (res != null) {
                    String? str = await Scan.parse(res[0].path);
                    if (str != null) {
                      return Navigator.pop(context, str);
                    } else {
                      return Navigator.pop(context, "No QR code found");
                    }
                  }
                },
                icon: const Icon(Icons.image),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
