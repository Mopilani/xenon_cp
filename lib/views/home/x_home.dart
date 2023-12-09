import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Stack(
        clipBehavior: Clip.antiAlias,
        children: [
          Center(
            child: Opacity(
              opacity: 0.3,
              child: Column(
                children: [
                  Container(
                    height: 350,
                    padding: const EdgeInsets.all(50),
                    child: Image.asset(
                      'assets/images/Spider_Base_Logo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  const Text(
                    'XenonBase',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
