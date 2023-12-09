import 'dart:async';

import 'package:businet_models/utils/system_db.dart';
import 'package:mongo_dart/mongo_dart.dart' hide Project;
import 'package:xenon_cp/model/tree_view_project.dart';


class Branch {
  Branch(
    this.id,
    this.title, {
    // this.parentId,
    this.indicator = false,
    required this.color,
    required this.sub,
    required this.xoffset,
    required this.yoffset,
    this.height,
    this.width,
    this.textSize,
    DateTime? time,
  }) {
    time = DateTime.parse(id.split('@').last);
    // this.time = time ?? DateTime.now();
  }

  static void of(TreeViewProject project) {
    collectionName = project.id;
  }

  String? mid;
  String id;
  // String? parentId;
  // String name;
  String title = '';
  double xoffset;
  double yoffset;
  double? height;
  double? width;
  double? textSize; // TextSize
  int color;
  bool indicator = false;
  Map<String, BranchMetadata> sub = {};
  late DateTime time;

  static String collectionName = 'branches';

  static Branch fromMap(Map<String, dynamic> data) {
    return Branch(
      data['id'],
      data['t'],
      indicator: data['i'],
      xoffset: data['xo'],
      yoffset: data['yo'],
      height: data['h'],
      width: data['w'],
      color: data['c'],
      textSize: data['ts'],
      // time: data['time'],
      // description: data['description'],
      sub: Map.fromEntries(
        (<String, dynamic>{...data['s']})
            .entries
            .map(
              (entry) => MapEntry(
                entry.key,
                BranchMetadata(
                  entry.value['id'],
                  title: entry.value['t'],
                  // xoffet: entry.value['xoffet'],
                  // yoffet: entry.value['yoffet'],
                ),
              ),
            )
            .toList(),
      ),
    )..mid = data['_id'].toString();
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        't': title,
        'i': indicator,
        'c': color,
        'xo': xoffset,
        'yo': yoffset,
        'h': height,
        'w': width,
        'ts': textSize,
        's': Map.fromEntries(
          sub.entries
              .map(
                (entry) => MapEntry(
                  entry.key,
                  entry.value.toMap(),
                ),
              )
              .toList(),
        ),
      };

  static Future<List<Branch>> getAll() {
    List<Branch> catgs = [];
    return SystemMDBService.db
        .collection(collectionName)
        .find()
        .transform<Branch>(
          StreamTransformer.fromHandlers(
            handleData: (data, sink) {
              sink.add(Branch.fromMap(data));
            },
          ),
        )
        .listen((subCatg) {
          catgs.add(subCatg);
        })
        .asFuture()
        .then((value) => catgs);
  }

  static Stream<Branch> stream() {
    return SystemMDBService.db.collection(collectionName).find().transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          sink.add(Branch.fromMap(data));
        },
      ),
    );
  }

  Future<Branch?> aggregate(List<dynamic> pipeline) async {
    var d = await SystemMDBService.db
        .collection(collectionName)
        .aggregate(pipeline);

    return Branch.fromMap(d);
  }

  static Future<Branch?> get(int id) async {
    var d = await SystemMDBService.db
        .collection(collectionName)
        .findOne(where.eq('id', id));
    if (d == null) {
      return null;
    }
    return Branch.fromMap(d);
  }

  static Future<Branch?> findById(int id) async {
    var d = await SystemMDBService.db
        .collection(collectionName)
        .findOne(where.eq('id', id));
    if (d == null) {
      return null;
    }
    return Branch.fromMap(d);
  }

  static Future<Branch?> findBydescription(String description) async {
    var d = await SystemMDBService.db
        .collection(collectionName)
        .findOne(where.eq('description', description));
    if (d == null) {
      return null;
    }
    return Branch.fromMap(d);
  }

  Future<Branch> edit([bool fromSyncService = false]) async =>
      await editToCol(collectionName, fromSyncService);

  Future<Branch> editToCol(String collName,
      [bool fromSyncService = false]) async {
    var r = await SystemMDBService.db.collection(collName).update(
          where.eq('id', id),
          toMap(),
        );
    print(r);
    return this;
  }

  Future<int> delete([bool fromSyncService = false]) async =>
      await deleteFromColl(collectionName, fromSyncService);

  Future<int> deleteFromColl(String collName,
      [bool fromSyncService = false]) async {
    var r = await SystemMDBService.db.collection(collName).remove(
          where.eq('id', id),
        );
    return 1;
  }

  Future<int> add([bool fromSyncService = false]) async =>
      await addToCol(collectionName, fromSyncService);

  Future<int> addToCol(String collName, [bool fromSyncService = false]) async {
    var r = await SystemMDBService.db.collection(collName).insert(
          toMap(),
        );
    print(r);
    return 1;
  }

  Future<int> moveToColl(
      String fromCollectionName, String toCollectionName) async {
    var r = await deleteFromColl(fromCollectionName);
    print(r);
    r = await addToCol(toCollectionName);
    print(r);
    return 1;
  }

  Future<int> deleteWithMID([bool fromSyncService = false]) async {
    print(mid);
    var r = await SystemMDBService.db.collection(collectionName).remove(
          where.eq('_id', mid),
        );
    return 1;
  }
}

class BranchMetadata {
  BranchMetadata(
    this.id, {
    required this.title,
    // required this.xoffet,
    // required this.yoffet,
  });
  String id;
  String title;
  // double xoffet;
  // double yoffet;

  static BranchMetadata fromMap(Map<String, dynamic> data) {
    return BranchMetadata(
      data['id'],
      title: data['t'],
      // xoffet: data['xoffet'],
      // yoffet: data['yoffet'],
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        't': title,
        // 'xoffet': xoffet,
        // 'yoffet': yoffet,
      };
}
