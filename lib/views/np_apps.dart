import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xenon_cp/views/np_apps/data_view/json_viewer.dart';
import 'package:xenon_cp/views/np_apps/teleprompter/teleprompter.dart';

import 'package:xenon_cp/views/np_apps/tree_view/projects_view.dart';


bool donNotShowMeConnectionErrorDialog = false;

class NPApps extends StatefulWidget {
  const NPApps({Key? key}) : super(key: key);

  @override
  State<NPApps> createState() => _NPAppsState();
}

class _NPAppsState extends State<NPApps> {
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

  final List<_AppItem> _items = [
    // _AppItem(
    //   icon: Icons.developer_board,
    //   title: 'Spider Developer Inspector',
    //   tooltip: '',
    //   version: '0.0.2-R-SBXB',
    //   navigatoTo: const SpiderDeveloperInspector(),
    // ),
    // _AppItem(
    //   icon: Icons.cloud,
    //   title: 'Cloud Controle Panel',
    //   tooltip: '',
    //   version: '0.2.0-R-SBXB',
    //   navigatoTo: const CloudControlePage(),
    // ),
    // _AppItem(
    //   icon: Icons.developer_mode,
    //   title: 'Code Projects Controle',
    //   tooltip: '',
    //   version: '0.0.4',
    //   navigatoTo: const CodeProjectsControle(),
    // ),
    _AppItem(
      icon: Icons.ac_unit_rounded,
      title: 'Tree View',
      tooltip: '',
      version: '0.0.4',
      navigatoTo: const TreeView(),
    ),
    // _AppItem(
    //   icon: Icons.ac_unit_rounded,
    //   title: 'Tree View',
    //   tooltip: '',
    //   version: '0.0.4',
    //   navigatoTo: const ProjectsView(),
    // ),
    // _AppItem(
    //   icon: Icons.developer_mode,
    //   title: 'Devices Connector',
    //   tooltip: '',
    //   version: '0.0.1-R-SBXB',
    //   navigatoTo: const DevicesConnector(),
    // ),
    // _AppItem(
    //   icon: Icons.api_rounded,
    //   title: 'Xenon API Tester',
    //   tooltip: '',
    //   version: '0.8.2-R',
    //   navigatoTo: const XenonAPITester(),
    // ),
    // _AppItem(
    //   icon: Icons.api_sharp,
    //   title: 'Request Maker',
    //   tooltip: '',
    //   version: '0.3.1-R',
    //   navigatoTo: const RequestMaker(),
    // ),
    // _AppItem(
    //   icon: Icons.recycling_outlined,
    //   title: 'SP Converter',
    //   tooltip: '',
    //   version: '0.2.0-R',
    //   navigatoTo: const SPXBConverter(),
    // ),
    // _AppItem(
    //   icon: Icons.chrome_reader_mode_rounded,
    //   title: 'Local Server Test',
    //   tooltip: '',
    //   version: '0.6.1-R-SBXB',
    //   navigatoTo: const XBLocalServerTest(),
    // ),
    // _AppItem(
    //   icon: Icons.density_small_sharp,
    //   title: 'Aurdio Tests',
    //   tooltip: '',
    //   version: '0.1.0',
    //   navigatoTo: const AudioTests(),
    // ),
    // _AppItem(
    //   icon: Icons.density_small_sharp,
    //   title: 'Database Controle',
    //   tooltip: '',
    //   version: '0.0.0-R-Inv',
    //   navigatoTo: const XSettings(),
    // ),
    // _AppItem(
    //   icon: Icons.cloud,
    //   title: 'Api App Test',
    //   tooltip: '',
    //   version: '0.3.5-R-SBXB',
    //   navigatoTo: const ApiAppTest(),
    // ),
    // _AppItem(
    //   icon: Icons.start,
    //   title: 'Commander',
    //   tooltip: '',
    //   version: '0.5.0-B',
    //   navigatoTo: const Commander(),
    // ),
    // _AppItem(
    //   icon: Icons.eco_rounded,
    //   title: 'EncoDec',
    //   tooltip: '0.0.1',
    //   navigatoTo: const EncoDec(),
    // ),
    // _AppItem(
    //   icon: Icons.air,
    //   title: 'Flow',
    //   tooltip: '',
    //   version: '0.0.2',
    //   navigatoTo: const FlowHome(),
    // ),
    // _AppItem(
    //   icon: Icons.map,
    //   title: 'D-Map',
    //   version: '0.0.3',
    //   tooltip: '',
    //   navigatoTo: const BuildScriptHome(),
    // ),
    // _AppItem(
    //   icon: Icons.content_paste_go_rounded,
    //   title: 'Logs',
    //   tooltip: '',
    //   version: '0.1.0-R-SBXB',
    //   navigatoTo: const LogsView(),
    // ),
    // _AppItem(
    //   icon: Icons.telegram_sharp,
    //   title: 'T-Bot',
    //   tooltip: '',
    //   version: '0.1.5-R',
    //   navigatoTo: const TelegramDataBot(),
    // ),
    // _AppItem(
    //   icon: Icons.color_lens,
    //   title: 'X-Settings',
    //   tooltip: '',
    //   navigatoTo: const XSettings(),
    // ),
    // _AppItem(
    //   icon: Icons.work,
    //   title: 'Mopilani Custom Tools',  
    //   tooltip: '',
    //   navigatoTo: const MopilaniCustomTools(),
    // ),
    _AppItem(
      icon: Icons.panorama_photosphere,
      title: 'Teleprompter',  
      tooltip: '',
      navigatoTo: const TeleprompterView(),
    ),
    _AppItem(
      icon: Icons.panorama_photosphere,
      title: 'Json View',  
      tooltip: '',
      navigatoTo: const JsonViewerPage(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nexa-Pros Included Apps'),
        actions: [
          // MaterialButton(
          //   onPressed: () {
          //     const SellBytesActerState();
          //   },
          // ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 4.0,
        ),
        itemCount: _items.length,
        itemBuilder: (context, index) {
          return appItem(
            _items[index],
          );
        },
      ),
    );
  }

  Widget appItem(_AppItem item) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
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
              Icon(
                item.icon,
                size: 30,
              ),
              Column(
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 16,
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

class _AppItem {
  _AppItem(
      {required this.icon,
      required this.title,
      this.tooltip,
      this.version,
      required this.navigatoTo});

  late IconData icon;
  late String title;
  late String? version;
  late String? tooltip;
  late Widget navigatoTo;
}
