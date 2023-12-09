import 'package:flutter/material.dart';

class XDrawer extends StatefulWidget {
  const XDrawer({Key? key, required this.pageController}) : super(key: key);
  final PageController pageController;

  @override
  State<XDrawer> createState() => _XDrawerState();
}

class _XDrawerState extends State<XDrawer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<_XDrawerItem> items = [
    _XDrawerItem('Home', null, 0, Icons.home_filled),
    _XDrawerItem('NP Apps', null, 1, Icons.padding_rounded),
    _XDrawerItem('Settings', null, 2, Icons.settings),
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.all(4),
      height: size.height,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: ScrollController(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                _XDrawerItem item = items[index];
                return SizedBox(
                  height: 60,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      widget.pageController.jumpToPage(item.index);
                    },
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      title: Text(item.title),
                      leading: Icon(
                        item.icon,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      subtitle:
                          item.subtitle == null ? null : Text(item.subtitle!),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white30,
              child: Image.asset(
                'assets/images/Spider_Base_Logo.png',
                fit: BoxFit.cover,
                height: 50,
                width: 50,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _XDrawerItem {
  _XDrawerItem(this.title, this.subtitle, this.index, this.icon);

  final String title;
  final String? subtitle;
  final int index;
  final IconData icon;
}
