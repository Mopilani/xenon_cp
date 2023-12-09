import 'package:hive/hive.dart';
import 'package:xenon_cp/utils/kns.dart';

// extension TOSPiderBaseProjects on Map {
//   dsdf() {}
//   Map<String, SpiderBaseProject> toSpiderBaseProjects() {
//     Map<String, SpiderBaseProject> result = {};
//     result = map(
//       (key, value) {
//         value = SpiderBaseProject.fromMap(value);
//         return MapEntry(key, value);
//       },
//     );

//     return result;
//   }
// }

class AppData {
  /// Gets the available [AppData] instance and returns it
  static Future<AppData> init() async {
    var box = await Hive.openBox(ApDBx_KN);
    // box.clear();

    // Getting the app data instance to be extracted in new instace
    var instanceData = box.get(ApDIns_001_KN);

    if (instanceData != null) {
      // print('AppData Instance Found:');
      // print('$instanceData');

      var oldInstance =
          AppData.fromMap((instanceData as Map).cast<String, dynamic>());

      // [Note] commenting this `set` operation cause the hive
      // had been the cache for the instances
      // GlobalState.set(ApDIns_001_KN, oldInstance);
      box.close();
      return oldInstance;
    } else {
      var newIns = AppData();

      await box.put(ApDIns_001_KN, newIns.toMap());

      // GlobalState.set(ApDIns_001_KN, newIns);
      box.close();
      return newIns;
    }
  }

  static Future<AppData?> ins() async {
    var box = await Hive.openBox(ApDBx_KN);

    Map dryIns = box.get(ApDIns_001_KN);
    // print(dryIns);

    var _appData = AppData.fromMap(dryIns.cast<String, dynamic>());
    // var box = GlobalState.get<Box>(ApDBx_001_KN);
    // var _appData = box.get(ApDIns_001_KN);
    await box.close();

    return _appData;
  }

  // AppData({Map<String, dynamic>? spiderProjects}) {
  //   if (spiderProjects != null) {
  //     this.spiderProjects = spiderBaseDryProjectsToInstances(spiderProjects);
  //   } else {
  //     this.spiderProjects = <String, SpiderBaseProject>{};
  //   }
  // }

  // late Map<String, SpiderBaseProject> spiderProjects;

  // Herer the map kies names
  static const String spiderProjectsKN = 'sbpros';

  Map<String, dynamic> toMap() {
    return {
      // spiderProjectsKN: spiderBaseInstancesToDryProjects(spiderProjects),
    };
  }

  static AppData fromMap(Map<String, dynamic> other) {
    return AppData(
        // spiderProjects:
        //     (other[spiderProjectsKN] as Map).cast<String, dynamic>()
        );
  }

  // Future<SpiderBaseProject> addSpiderProject({
  //   required String id,
  //   required SpiderBaseProject project,
  // }) async {
  //   var _appDataIns = await AppData.ins();

  //   _appDataIns!.spiderProjects.addAll({
  //     id: project,
  //   });

  //   // print(_appDataIns.toMap());
  //   var box = await Hive.openBox(ApDBx_KN);
  //   print(_appDataIns.toMap());

  //   await box.put(ApDIns_001_KN, _appDataIns.toMap());

  //   await box.close();

  //   return project;
  //   // await appData.save();
  // }

  // _reload() {}

  /// Gets you the application data hive box as Db
  // Box appDataDb() => GlobalState.get<Box>(ApDBx_001_KN);

}
