import 'package:flutter/material.dart';

class AboutApp extends StatefulWidget {
  const AboutApp({Key? key}) : super(key: key);

  @override
  State<AboutApp> createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            
            Column(
              children: [
                Image.asset(
                  'assets/images/Spider_Base_Logo.png',
                  fit: BoxFit.cover,
                  height: 150,
                  width: 150,
                ),
                const SizedBox(
                  height: 32,
                ),
                const Text(
                  'Spiderbase - Xenonbase',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w100,
                  ),
                ),
                const Text(
                  'Platform version 1.180.1-Beta',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const Text(
              '''           SBXB (C) (SpiderBase XenonBase) Cloud Platform is one of (NexaPros) Acanxa (C) Projects,
              SBXB (This App) is designed to maintain and controle SBXB cloud servers with many adminstration
              features and plugins add of NP (NexaPros) apps''',
              textAlign: TextAlign.center,
              style: TextStyle(
                // fontSize: 16,
                fontWeight: FontWeight.w100,
              ),
            ),
            const Text(
              '(C) All Rights And Fingerprints Reserved For\nAcanxa, Nexapros, Beauty Bend, Spiderbase & Xenonbase',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                // fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
