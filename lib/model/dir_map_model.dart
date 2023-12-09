import 'dart:io';

import '../utils/enums.dart';

import 'package:overlay_support/overlay_support.dart';

class DirMap {
  DirMap(this.lang);

  ProjectLang? lang;

  /// Contains { fileName : path,
  ///            folderName : { contents : pathes },
  ///          }
  Map<String, dynamic> dirMap = {
    // 'pubspec.yaml': '',
  };

  /// Contains the last dir entities map
  Map<String, dynamic> lastDirMap = {};

  /// Contains the last dir entities map comparation result
  Map<String, dynamic> lastDirMapResult = {};

  ///
  Map<String, dynamic> resultDirMap = {};

  late Directory currentDir;

  Future<DirMap> checkAssets(Directory projectDir) async {
    switch (lang.toString()) {
      case 'ProjectLang.dart':
        await _checkDartNativeProjectAssets(projectDir);
        return this;
      case 'ProjectLang.none':
        return this;
      // break;
      default:
        stdout.addError(Exception('Lang type must be specifed'));
        throw (0x3234);
    }
  }

  Future getContents(Directory currentDir) async {
    // List<String> listeners = [];

    // /// Gets a specifed dir entities[]
    // void getDirEntities(Directory dir) {
    //   var lv5s = IDG().lv5s(10);
    //   listeners.add(lv5s);
    //   dir.list().listen((entity) {
    //     var dir = Directory(entity.path);
    //     if (dir.existsSync()) {
    //       dirMap.addAll({
    //         entity.path: [
    //           true /*isDIr*/,
    //         ]
    //       });
    //       getDirEntities(dir);
    //     } else {
    //       dirMap.addAll({
    //         entity.path: [
    //           false /*isDir*/,
    //         ]
    //       });
    //     }
    //   }, onDone: () {
    //     listeners.remove(lv5s);
    //   });
    // }

    // getDirEntities(currentDir);
    // // var lv5s = IDG().lv5s(10); listeners.add(lv5s);
    // // Directory.current.list().listen((entity) {
    // //   // print(entity.path); var dir = Directory(entity.path);
    // //   if (dir.existsSync()) { dirMap.addAll({ entity.path: [
    // //         true /*isDIr*/, ] }); getDirEntities(dir); } else {
    // //     dirMap.addAll({ entity.path: [ false /*isDir*/, ] }); }
    // // }, onDone: () { listeners.remove(lv5s); });

    // return await Future.delayed(
    //   const Duration(seconds: 1),
    //   () {
    //     while (listeners.isEmpty) {
    //       stdout.writeln('Remaining Listeners: ${dirMap.entries.length}');
    //       return dirMap;
    //     }
    //   },
    // );
  }

  Future _checkDartNativeProjectAssets(Directory projectDir) async {
    currentDir = projectDir;
    var errors = 0;
    var exceptions = 0;

    Future _compareDirsWithStandard(String currentDirPath) async {
      // for (MapEntry entry in dartProjectFilesStructure2.entries) {
      //   if (entry.value[1]) {
      //     // print(currentDirPath + entry.value[0]);
      //     var r = await Directory(currentDirPath + entry.value[0]).exists();
      //     if (r) {
      //     } else {
      //       stdout.writeln('The directory ${entry.key} does not exists');
      //       if (entry.value[2]) {
      //         errors++;
      //       } else {
      //         exceptions++;
      //       }
      //     }
      //   } else {
      //     var r = await File(currentDirPath + entry.value[0]).exists();
      //     if (r) {
      //     } else {
      //       stdout.writeln('The file ${entry.key} does not exists');
      //       if (entry.value[2]) {
      //         errors++;
      //       } else {
      //         exceptions++;
      //       }
      //     }
      //   }
      // }
    }

    await getContents(currentDir);
    // print(dirMap);

    await _compareDirsWithStandard(currentDir.path);

    if (errors != 0) {
      print(errors);
      print(exceptions);
      toast(errors.toString());
      throw (0x2093);
    }

    Future<void> result() async {
      /// Firstly the result is comparation result table
      /// The result dir path contains the modefied files and directoryies
      /// and the type of it and they are found or not in a list like
      /// { String path : [bool isFolder, bool modefied, bool found] }
      var resultDirMap = <String, dynamic>{};
      // for (MapEntry entry in dirMap.entries){}

      for (MapEntry entry in dirMap.entries) {
        if (entry.value[0]) {
          var directory = Directory(entry.key);
          var found = await directory.exists();
          var lastDirMapResultEntryValue = lastDirMapResult[entry.key];
          if (lastDirMapResultEntryValue != null) {
            var stat = await directory.stat();
            assert(lastDirMapResultEntryValue[0], true);
            var modefied =
                stat.modified == lastDirMapResultEntryValue[1] ? false : true;
            resultDirMap.addAll({
              entry.value[0]: [
                true,
                modefied,
                found,
              ]
            });
          } else {
            // Add new entity to the new result
          }
        } else {
          var file = File(entry.key);
          var found = await file.exists();
          var lastDirMapResultEntryValue = lastDirMapResult[entry.key];
          if (lastDirMapResultEntryValue != null) {
            var stat = await file.stat();
            assert(lastDirMapResultEntryValue[0], true);
            var modefied =
                stat.modified == lastDirMapResultEntryValue[1] ? false : true;
            resultDirMap.addAll({
              entry.value[0]: [
                true,
                modefied,
                found,
              ]
            });
          } else {
            // Add new entity to the new result
          }
        }
      }
    }

    await result();
  }

  // Future<bool> checkDir(String path) async {
  //   var projectDir = Directory(path);
  //   return await projectDir.exists();
  // }

  // Future<bool> checkFile(String path) async {
  //   var projectDir = Directory(path);
  //   return await projectDir.exists();
  // }

  Future<bool> sendAssets() async {
    bool done = false;
    for (var entry in resultDirMap.entries) {
      // if modefied
      if (entry.value[1]) {}
    }
    return done;
  }

  Map<String, dynamic> toMap() => {
        'lang': lang.toString(),
        'resultDirMap': resultDirMap,
        'lastDirMapResult': lastDirMapResult,
      };

  DirMap.fromMap(Map<String, dynamic> dryDirMap) {
    lang = getProjectLang(dryDirMap['lang']);
    resultDirMap = <String, dynamic>{...dryDirMap['resultDirMap']};
    lastDirMapResult = <String, dynamic>{...dryDirMap['lastDirMapResult']};
  }
}
