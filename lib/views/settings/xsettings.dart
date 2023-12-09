import 'package:flutter/material.dart';
import 'package:xenon_cp/views/settings/about_app.dart';
import 'package:xenon_cp/views/settings/theme.dart';

bool donNotShowMeConnectionErrorDialog = false;

class XSettings extends StatefulWidget {
  const XSettings({Key? key}) : super(key: key);

  @override
  State<XSettings> createState() => _XSettingsState();
}

class _XSettingsState extends State<XSettings> {
  late TextEditingController hostCont;

  @override
  void initState() {
    super.initState();
    hostCont = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final List<_SettingsItem> _items = [
    // _SettingsItem(
    //   icon: Icons.person,
    //   title: 'Account Settings',
    //   tooltip: '',
    //   version: '0.1.1',
    //   navigatoTo: const AccountSettings(),
    // ),
    _SettingsItem(
      icon: Icons.color_lens,
      title: 'Theme',
      tooltip: '',
      version: '0.5.0',
      navigatoTo: const ThemeControle(),
    ),
    _SettingsItem(
      icon: Icons.abc,
      title: 'About',
      tooltip: '',
      version: '1.180.1',
      navigatoTo: const AboutApp(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4.0,
        ),
        itemCount: _items.length,
        itemBuilder: (context, index) {
          return settingsItem(
            _items[index],
          );
        },
      ),
    );
  }

  Widget settingsItem(_SettingsItem item) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => item.navigatoTo,
          ),
        );
      },
      child: SizedBox(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              item.icon == Icons.abc
                  ? Image.asset(
                      'assets/images/Spider_Base_Logo.png',
                      fit: BoxFit.cover,
                      height: 30,
                      width: 30,
                    )
                  : Icon(
                      item.icon,
                      size: 30,
                    ),
              Column(
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    item.version ?? '',
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  connectionErrorDialog(e) {
    showDialog(
      context: context,
      builder: (context) {
        return const Center();
      },
    );
  }
}

class _SettingsItem {
  _SettingsItem(
      {required this.icon,
      required this.title,
      this.tooltip,
      this.version,
      required this.navigatoTo});

  late IconData icon;
  late String title;
  late String? tooltip;
  late String? version;
  late Widget navigatoTo;
}
