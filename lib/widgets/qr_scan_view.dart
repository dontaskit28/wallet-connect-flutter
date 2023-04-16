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
      backgroundColor: Colors.grey.shade900,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.height,
                  // padding: const EdgeInsets.all(20),
                  child: ScanView(
                    controller: controller,
                    scanAreaScale: 1,
                    scanLineColor: Colors.white,
                    onCapture: (data) {
                      Navigator.pop(context, data);
                    },
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.35,
                  left: 80,
                  child: Container(
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
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.35,
                  right: 80,
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
                  bottom: MediaQuery.of(context).size.height * 0.35,
                  left: 80,
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
                  bottom: MediaQuery.of(context).size.height * 0.35,
                  right: 80,
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
                Positioned(
                  bottom: 40,
                  left: MediaQuery.of(context).size.width * 0.5,
                  child: CircleAvatar(
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
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
