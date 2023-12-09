import 'dart:io';
import 'dart:math';

import 'package:hive/hive.dart';

import '../utils/enums.dart';
import 'dir_map_model.dart';

class TreeViewProject {
  TreeViewProject();

  /// The init project initializes a project you can control from the
  /// command line input, means interactivly controling
  static Future<TreeViewProject> init({
    TreeViewProject? project,
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
        project = TreeViewProject.n(
          name: projectName,
          lang: projectLang,
          dirMap: dirMapIns,
        );
      } else {
        project = TreeViewProject.n(
          name: projectName,
          lang: projectLang,
          dirMap: null,
        );
      }
      return project;
    }
  }

  TreeViewProject.n({
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

  static Future<List<TreeViewProject>> getAll() async {
    List<TreeViewProject> projects = [];
    var db = await Hive.openBox('data-projects');
    for (var value in db.values) {
      var r = TreeViewProject.fromMap(<String, dynamic>{...value});
      projects.add(r);
    }
    print(projects);
    return projects;
  }

  static Future<List<TreeViewProject>> deleteAll() async {
    List<TreeViewProject> projects = [];
    var db = await Hive.openBox('data-projects');
    await db.deleteAll(db.keys);
    print(projects);
    return projects;
  }

  static Future<List<TreeViewProject>> delete(String id) async {
    List<TreeViewProject> projects = [];
    var db = await Hive.openBox('data-projects');
    await db.delete(id);
    print(projects);
    return projects;
  }

  static TreeViewProject fromMap(Map<String, dynamic> dryProject) {
    var project = TreeViewProject();
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
