import 'dart:convert';

import 'package:flutter/material.dart';

class JsonViewerPage extends StatefulWidget {
  const JsonViewerPage({super.key});

  @override
  State<JsonViewerPage> createState() => _JsonViewerPageState();
}

class _JsonViewerPageState extends State<JsonViewerPage> {
  TextEditingController contentCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Json Viewer')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: contentCont,
                expands: true,
                minLines: null,
                maxLines: null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onChanged: (text) {
                  // print(text);
                  print(json.decode(text));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  MaterialButton(
                    color: Colors.black,
                    onPressed: format,
                    child: const Text('Format'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void format() {
    /// Need format code here
    contentCont.text;
  }
}
