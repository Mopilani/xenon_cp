import 'dart:io';
import 'dart:math';

import 'package:hive/hive.dart';

import '../utils/enums.dart';
import 'dir_map_model.dart';

class Project {
  Project();

  /// The init project initializes a project you can control from the
  /// command line input, means interactivly controling
  static Future<Project> init({
    Project? project,
    required String projectName,
    required ProjectLang projectLang,
    String? dirPath,
  }) async {
    if (project != null) {
      if (project.dirMap != null) {
        var projectDir = Directory(project.path!);

        if (await projectDir.exists()) {
          await DirMap(project.dirMap?.lang).checkAssets(projectDir);
        } else {}
        throw 'Project Folder Does Not Exists! 0x2353';
      }
      return project;
    } else {
      if (dirPath != null) {
        var currentDir = Directory(dirPath ?? Directory.current.path);

        var dirMapIns = DirMap(projectLang);
        await dirMapIns.checkAssets(currentDir);
        project = Project.n(
          name: projectName,
          lang: projectLang,
          dirMap: dirMapIns,
        );
      } else {
        project = Project.n(
          name: projectName,
          lang: projectLang,
          dirMap: null,
        );
      }
      return project;
    }
  }

  Project.n({
    required this.name,
    required this.lang,
    this.dirMap,
  }) {
    id = newId();
    // name = projectName;
    path = dirMap?.currentDir.path;
    // lang = projectLang; // This must be initialized in 2023 right now
    projectDir = dirMap?.currentDir;
    // dirMap = dirMap;
  }

  static newId() => 'xcpp-${Random().nextInt(10000)}';

  // Future goInteractive() async {
  //   _read() => stdin.readLineSync();

  //   bool interactive = true;
  //   while (interactive) {
  //     var argsStr = _read();
  //     List<String> args;
  //     if (argsStr != null) {
  //       args = argsStr.split(' ');
  //       var parseResult = parser.parse(args);
  //       await commandSwitch(parseResult.command!.name);
  //     } else {}
  //   }
  // }

  late String id;
  late String name;
  late ProjectLang lang;
  late String? path;

  /// Runtime initializable
  late Directory? projectDir;
  late DirMap? dirMap;

  Map<String, dynamic> toMap() => {
        'dirMap': dirMap?.toMap(),
        'name': name,
        'path': path,
        'lang': lang.toString(),
        'id': id,
      };

  static Future<List<Project>> getAll() async {
    List<Project> projects = [];
    var db = await Hive.openBox('data-projects');
    for (var value in db.values) {
      var r = Project.fromMap(<String, dynamic>{...value});
      projects.add(r);
    }
    print(projects);
    return projects;
  }

  static Future<List<Project>> deleteAll() async {
    List<Project> projects = [];
    var db = await Hive.openBox('data-projects');
    await db.deleteAll(db.keys);
    print(projects);
    return projects;
  }

  static Future<List<Project>> delete(String id) async {
    List<Project> projects = [];
    var db = await Hive.openBox('data-projects');
    await db.delete(id);
    print(projects);
    return projects;
  }

  static Project fromMap(Map<String, dynamic> dryProject) {
    var project = Project();
    if (dryProject['dirMap'] != null) {
      project.dirMap =
          DirMap.fromMap(<String, dynamic>{...(dryProject['dirMap'])});
    }
    project.dirMap = null;
    project.id = dryProject['id'];
    project.name = dryProject['name'];
    project.path = dryProject['path'];
    project.lang = getProjectLang(dryProject['lang'])!;
    return project;
  }

  Future watchProject(String? projectPath) async {
    if (projectPath == null) {
      projectDir = Directory(projectPath!);
      if (await projectDir?.exists() ?? false) {
      } else {
        throw 'Project Folder Does Not Exists!';
      }
      var eStream = projectDir?.watch();
      projectDir!
          .list(
        recursive: true,
      )
          .listen((event) {
        print(event.path);
        print(Directory(event.path).existsSync());
        // print(event.uri.scheme);
        // print(event.uri.host);
        // if (event.uri);
      }, onDone: () {
        print('Done From The First Listen');
      });
      // eStream.listen(
      //   (event) {
      //     // event.type;
      //     print(event.isDirectory);
      //     print(event.path);
      //     print(event.type);
      //     FileSystemEvent.all;
      //     projectDir
      //         .list(
      //       recursive: true,
      //     )
      //         .listen((event) {
      //       print(event.path);
      //     }, onDone: () {
      //       print('Done');
      //     });
      //   },
      // );
    } else {}
  }
}
