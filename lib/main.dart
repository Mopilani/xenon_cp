import 'package:businet_models/businet_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:flutter_xenon_base/xenon_base.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xenon_cp/app.dart';
import 'package:xenon_cp/model/app_data.dart';

Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await Window.initialize();
  var userDocsDirectory = await getApplicationDocumentsDirectory();
  Hive.init('${userDocsDirectory.path}/Xenon CP');
  // await Hive.();

  await AppData.init();

  XenonApp(
    apiToken: 'No Token',
    url: 'http://192.168.43.151:2354',
  );

  try {
    String docsPath = (await getApplicationDocumentsDirectory()).path;
    await SystemMDBService(
      hiveDBPath: '$docsPath/xenon_cp',
      mongoDBUriString: "mongodb://localhost:27017/xenon_cp",
      auth: false,
    ).init();
  } catch (e) {
    //
  }

  // The main things to do before the ap starts is to check it's history of
  // work then desiding what to do
  GlobalState.set('53fsea6261', false);
  // RepaintBoundary();

  runApp(const XenonCPApp());
}
