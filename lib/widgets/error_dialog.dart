import 'package:flutter/material.dart';

Future<void> errorDialog(
  BuildContext context,
  String errorFriendlyMessage,
  dynamic e,
  // bool donNotShowMeConnectionErrorDialog,
  // TextEditingController serveHostCont,
) async {
  await showDialog(
    context: context,
    builder: (context) {
      return Material(
        color: Colors.transparent,
        child: Center(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                20,
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  20,
                ),
                // color: Colors.white,
              ),
              height: 400,
              width: 500,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.error,
                    color: Colors.red,
                    size: 40,
                  ),
                  Text(
                    errorFriendlyMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    '\nError:\n$e',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        child: const Text(
                          "Don't show me connection error dialog",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          // donNotShowMeConnectionErrorDialog = true;
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(width: 16),
                      MaterialButton(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: const BorderSide(color: Colors.grey),
                        ),
                        child: const Text(
                          "OK",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
