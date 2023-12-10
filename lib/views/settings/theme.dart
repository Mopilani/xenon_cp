import 'package:businet_models/utils/global_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:get/get.dart';
import 'package:xenon_cp/updaters.dart';

class ThemeControle extends StatefulWidget {
  const ThemeControle({Key? key}) : super(key: key);

  @override
  State<ThemeControle> createState() => _ThemeControleState();
}

class _ThemeControleState extends State<ThemeControle> {
  String? currentTheme;

  @override
  void initState() {
    super.initState();
    currentTheme = GlobalState.get('crntThm') ?? 'dark';
    currentTheme == 'dark' ? radioGroup = 1 : 0;
  }

  @override
  void dispose() {
    super.dispose();
  }

  int radioGroup = 0;
  int radioGroupCurrentValue = 0;
  bool loading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Theme'),
        flexibleSpace:
            Center(child: loading ? const CircleAvatar() : const SizedBox()),
      ),
      body: Center(
        child: Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  children: buttonItems
                      .map<Widget>(
                        (buttonItem) => button23(buttonItem),
                      )
                      .toList(),
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Icon(Icons.color_lens, size: 60),
                      const SizedBox(height: 16),
                      Text(
                        'Current Theme is: $currentTheme',
                        style: const TextStyle(
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                  // const SizedBox(height: 1),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Light Theme'),
                          const SizedBox(width: 32),
                          Radio<int>(
                            value: 0,
                            groupValue: radioGroup,
                            onChanged: (v) {
                              themeMode = ThemeMode.light;
                              currentTheme = 'light';
                              radioGroup = v!;
                              GlobalState.set('crntThm', 'light');
                              // ThemeUpdater().add(themeMode);
                              setState(() {});
                              themeChange.update((val) {});
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Dark Theme'),
                          const SizedBox(width: 32),
                          Radio<int>(
                            value: 1,
                            groupValue: radioGroup,
                            onChanged: (v) {
                              themeMode = ThemeMode.dark;
                              currentTheme = 'dark';
                              radioGroup = v!;
                              GlobalState.set('crntThm', 'dark');
                              // ThemeUpdater().add(themeMode);
                              setState(() {});
                              themeChange.update((val) {});
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget button23(ButtonItem item) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      onPressed: item.onPressed,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add,
              size: 24,
            ),
            const SizedBox(width: 4),
            Text(
              item.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

ThemeMode themeMode = ThemeMode.dark;
RxInt themeChange = 0.obs;

class ButtonItem {
  ButtonItem({
    required this.onPressed,
    required this.title,
  });
  void Function() onPressed;
  String title;
}

List<ButtonItem> buttonItems = [
  ...List.generate(
    WindowEffect.values.length,
    (index) => ButtonItem(
      onPressed: () async {
        await Window.setEffect(
          effect: WindowEffect.values[index],
          color: const Color.fromARGB(204, 255, 213, 255),
        );
      },
      title: WindowEffect.values[index].toString(),
    ),
  ),
  ButtonItem(
    onPressed: () async {
      await Window.hideWindowControls();
    },
    title: 'Hide Window Controls',
  ),
  ButtonItem(
    onPressed: () async {
      await Window.showWindowControls();
    },
    title: 'Show Window Controls',
  ),
  ButtonItem(
    onPressed: () async {
      await Window.setWindowBackgroundColorToDefaultColor();
    },
    title: 'Set Window Background Color To Default Color',
  ),
  ButtonItem(
    onPressed: () async {
      await Window.setWindowBackgroundColorToClear();
    },
    title: 'Set Window Background Color To Clear',
  ),
];
