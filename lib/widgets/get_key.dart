import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GetKey extends StatelessWidget {
  TextEditingController controller = TextEditingController();
  VoidCallback onPressed;
  GetKey({super.key, required this.onPressed, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              decoration: BoxDecoration(
                color: Colors.grey.shade600,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: "Enter Private Key",
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(10),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            IconButton(
              onPressed: () {
                Clipboard.getData('text/plain').then((value) {
                  controller.text = value!.text!;
                });
              },
              icon: const Icon(Icons.paste),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: onPressed,
          child: const Text("Submit"),
        ),
      ],
    );
  }
}
