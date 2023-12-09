import 'package:businet_models/utils/global_state.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:xenon_cp/updaters.dart';
import 'package:xenon_cp/utils/enums.dart';
import 'package:xenon_cp/views/home/x_home.dart';
import 'package:xenon_cp/views/np_apps.dart';
import 'package:xenon_cp/views/settings/xsettings.dart';
import 'package:xenon_cp/widgets/xlog2.dart';
import 'package:updater/updater.dart' as updater;

import 'xdrawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController pageController;
  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: const Text(
          'Xenon Base',
          style: TextStyle(
              // color: Colors.black,
              ),
        ),
        flexibleSpace: SizedBox(
          height: 100,
          width: 100,
          child: GestureDetector(
            onTap: () {
              setState(() {});
              XLog2Updater('homeLog').add('');
              // HomeLogUpdater().add('');
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              height: 100,
              width: 100,
              child: Image.asset(
                'assets/images/Spider_Base_Logo.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        // actions: [],
      ),
      body: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: XDrawer(
                    pageController: pageController,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 3,
                  child: XPageView(
                    pageController: pageController,
                  ),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  flex: 2,
                  child: XLog2(logId: 'homeLog'),
                  // child: XLog(logId: 'homeLog'),
                ),
              ],
            ),
          ),
          Container(
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black,
            ),
            padding: const EdgeInsets.fromLTRB(12, 2, 12, 2),
            margin: const EdgeInsets.all(4),
            child: Row(
              children: [
                () {
                  ServiceState serviceState =
                      GlobalState.get('53fsea62562') ?? ServiceState.stopped;
                  Color color = (serviceState == ServiceState.started
                      ? Colors.green
                      : serviceState == ServiceState.starting
                          ? Colors.yellow
                          : Colors.red);
                  return Shimmer.fromColors(
                    loop: 3,
                    baseColor: Colors.red,
                    highlightColor: Colors.yellow,
                    child: Text(
                      serviceState.name.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  );
                }.call(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => Test(),
          //   ),
          // ); // InAppNotification.show(
          //   child: Text('Hello'),
          //   context: context,
          //   onTap: () => print('Notification tapped!'),
          // );
        },
        tooltip: 'Go',
        child: const Icon(Icons.group_work_sharp),
      ),
    );
  }
}

class XPageView extends StatefulWidget {
  const XPageView({Key? key, required this.pageController}) : super(key: key);
  final PageController pageController;

  @override
  State<XPageView> createState() => _XPageViewState();
}

class _XPageViewState extends State<XPageView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Widget> items = [
    const Home(),
    const NPApps(),
    const XSettings(),
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: PageView.builder(
        controller: widget.pageController,
        itemCount: items.length,
        itemBuilder: (context, index) {
          // Widget item = items[index];
          return items[index];
        },
      ),
    );
  }
}

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            color: Colors.red,
            onPressed: () {
              // updater.Updater.insOfCache.clear();
              int cardUpdatersCount = 0;
              <String, dynamic>{...updater.Updater.insOfCache}
                  .forEach((key, value) {
                value.dispose();
                if (value.toString().contains('CardUpdater')) {
                  cardUpdatersCount++;
                  updater.SpecialUpdaterX(key).dispose();
                  // } else if (value.toString().contains('ZoomUpdater')) {
                  // } else if (key.toString().contains('')) {
                } else {
                  print(value);
                }
              });
              print(cardUpdatersCount);
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('${updater.Updater.insOfCache}'),
            // Text('كلمة'),
            // SizedBox(height: 30),
            // Expanded(
            //   child: GridView.builder(
            //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //       crossAxisCount: 2,
            //     ),
            //     itemCount: 10,
            //     itemBuilder: (context, index) {
            //       return Card(
            //         shape: RoundedRectangleBorder(),
            //         child: Column(
            //           mainAxisAlignment: MainAxisAlignment.end,
            //           crossAxisAlignment: CrossAxisAlignment.end,
            //           children: [
            //             Text('Card N $index'),
            //             Row(
            //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //               children: [
            //                 Icon(Icons.person),
            //                 Text('Card N $index'),
            //               ],
            //             ),
            //           ],
            //         ),
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
