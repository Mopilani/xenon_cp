import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart' hide BuildContext;
import 'package:flutter/material.dart' as flutter_material;

import 'package:updater/updater.dart' as updater;

import 'package:path_drawing/path_drawing.dart';
import 'package:xenon_cp/model/tree_view_project.dart';

import 'branch_model.dart';
import 'card_widget.dart';
import 'event_time_line.dart';
import 'path_painter.dart';
import 'updaters.dart';
import 'zoom_mx.dart';

class ProjectTreeView extends StatefulWidget {
  const ProjectTreeView({
    Key? key,
    required this.project,
  }) : super(key: key);
  final TreeViewProject project;

  @override
  State<ProjectTreeView> createState() => _ProjectTreeViewState();
}

Map<String, Widget> backStackWidgets = {};
Map<String, Widget> stackWidgets = {};
Map<String, Widget> frontStackWidgets = {};
Map<String, Branch> branches = {};
Map<String, Branch> selectedBranches = {};

void unSelectSelectedBranches() {
  var d = {...selectedBranches};
  selectedBranches.clear();
  for (var branch in d.values) {
    updater.SpecialUpdaterX(branch.id).add(0);
  }
  ThisPageUpdater().add(0);
}

// Branch? selectedBranch;

Branch? firstSelectedBranch;
Branch? secondSelectedBranch;

String genBranchId() => '${Random().nextInt(101101)}@${DateTime.now()}';
double xOffset = .0;
double yOffset = .0;
double maxXOffset = 10000;
double maxYOffset = 10000;
double minXOffset = .0;
double minYOffset = .0;

double boardWidth = 100000;
double boardHeight = 100000;

bool didMaxHeightAndWidthSet = false;
double maxHeight = .1;
double maxWidth = .1;

double maxXFocus = .0;
double minXFocus = .0;
double maxYFocus = .0;
double minYFocus = .0;

// double currentOffsetMiddle = .0;

double selectionXSPoint = .0;
double selectionYSPoint = .0;
double selectionXEPoint = .0;
double selectionYEPoint = .0;
bool selectionXInverted = false;
bool selectionYInverted = false;

double xMoveSpeed = .0;
double yMoveSpeed = .0;

bool controlPressed = false;

Branch? copiedBranch;
bool pastBranchPressed = false;

bool undoPressed = false;
bool redoPressed = false;
bool savePressed = false;
// String? selectedWireId;
dynamic selectedItem;

Offset secTapDownOffset = Offset.zero;

double currentScaleValue = .0;

Color sbColor = Colors.black;
Size sbSize = Size.zero;
double sbTextSize = 6.0;

late double trimPercent;
late PathTrimOrigin trimOrigin;
// late Zoom zoomW;
late EventTimeLine timeLine;

bool addBox = false;

bool showRelationsDots = true;

int frameCount = 0;
// List<int> fpsCounts = [];

ScrollController xScrollController = ScrollController();
ScrollController yScrollController = ScrollController();

// bool popUpAllowed = false;
bool ready = false;

d() => _ProjectTreeViewState();

void bringTo(int value) {
  if (selectedItem is! Branch) return;
  var data = (selectedItem as Branch);
  var sEntries = stackWidgets.entries.toList();
  var bEntries = branches.entries.toList();
  MapEntry<String, Widget> fb;
  MapEntry<String, Widget> sb;
  MapEntry<String, Branch> fb2;
  MapEntry<String, Branch> sb2;
  int fbIndex = 0;
  int sbIndex = 0;
  int fbIndex2 = 0;
  int sbIndex2 = 0;
  fbIndex = sEntries.indexWhere((entry) => data.id == entry.key);
  fbIndex2 = bEntries.indexWhere((entry) => data.id == entry.key);
  sbIndex = fbIndex + value;
  sbIndex2 = fbIndex2 + value;
  if (sbIndex >= sEntries.length) {
  } else {
    if (sbIndex < 0) {
    } else {
      fb = sEntries[fbIndex];
      sb = sEntries[sbIndex];
      sEntries.insert(fbIndex, sb);
      sEntries.insert(sbIndex, fb);
      stackWidgets = Map.fromEntries(sEntries);
    }
  }
  if (sbIndex2 >= bEntries.length) {
  } else {
    if (sbIndex2 < 0) {
    } else {
      fb2 = bEntries[fbIndex2];
      sb2 = bEntries[sbIndex2];
      bEntries.insert(fbIndex2, sb2);
      bEntries.insert(sbIndex2, fb2);
      branches = Map.fromEntries(bEntries);
    }
  }
  ThisPageUpdater().add(0);
}

Future<void> deleteBranch() async {
  // print(selectedItem);
  // await selectedItem!.delete();
  var data = (selectedItem as Branch);

  stackWidgets.remove(selectedItem!.id);
  backStackWidgets.removeWhere((k, v) {
    return k.contains(selectedItem!.id);
  });
  frontStackWidgets.removeWhere((k, v) {
    return k.contains(selectedItem!.id);
  });

  selectedItem!.sub.forEach((relationId, branchMeta) {
    branches[branchMeta.id]!.sub.remove(relationId);
    stackWidgets.addAll({
      branchMeta.id: CardWidget(branches[branchMeta.id]!),
    });
    stackWidgets.remove(relationId);
  });

  timeLine.add(data, EditEventType.delete);
  branches.remove(selectedItem!.id);
  selectedItem = null;
  ThisPageUpdater().add(0);
}

void deleteWire() {
  var bANDb = (selectedItem as String).split('&');
  // var fb = branches[bANDb.first];
  // var sb = branches[bANDb.last];
  // fb!.sub.remove(bANDb);
  // sb!.sub.remove(bANDb);
  // branches[bANDb.first] = fb;
  // branches[bANDb.last] = sb;
  try {
    branches[bANDb.first]!.sub.remove(selectedItem);
  } catch (e, s) {
    print(e);
    print(s);
    frontStackWidgets.remove(selectedItem); // removing the dot
    ThisPageUpdater().add(0);
    backStackWidgets.remove(selectedItem); // removing the wire
    return;
  }

  try {
    branches[bANDb.last]!.sub.remove(selectedItem);
  } catch (e, s) {
    print(e);
    print(s);
    frontStackWidgets.remove(selectedItem); // removing the dot
    ThisPageUpdater().add(0);
    backStackWidgets.remove(selectedItem); // removing the wire
    return;
  }

  var data = (backStackWidgets[selectedItem] as CustomPaint);
  timeLine.add(data, EditEventType.delete);
  frontStackWidgets.remove(selectedItem); // removing the dot
  backStackWidgets.remove(selectedItem); // removing the wire
  selectedItem = null;
  ThisPageUpdater().add(0);
}

class _ProjectTreeViewState extends State<ProjectTreeView> {
  TextEditingController branchNameController = TextEditingController();
  FocusNode rklListenerNode = FocusNode();
  num loaded = 0;
  num total = 0;

  @override
  void initState() {
    super.initState();
    Branch.of(widget.project);
    getAwaiters();
    trimPercent = 0;
    trimOrigin = PathTrimOrigin.begin;
    xScrollController = ScrollController(initialScrollOffset: xOffset);
    yScrollController = ScrollController(initialScrollOffset: yOffset);
    rklListenerNode.requestFocus();
    timeLine = EventTimeLine.init(widget.project.id);
  }

  Future<void> getAwaiters() async {
    // SystemMDBService.db.collection(widget.project.id).drop();
    // SystemMDBService.db.collection(widget.project.id).find().listen((event) {
    //   SystemMDBService.db.collection(widget.project.id).update(
    //       md.where.eq('id', event['id']),
    //       event
    //         ..['c'] = 4279280821
    //         ..remove('_id'));
    // });
    ready = false;
    await loadBranches();
  }

  Future<void> loadBranches() async {
    if (ready) return;
    await Branch.getAll().then(
      (branchs) {
        for (var branch in branchs) {
          stackWidgets.addAll({branch.id: CardWidget(branch)});
          branches.addAll({branch.id: branch});
        }
        total = branchs.length;
        updater.SpecialUpdaterX('branches_loader').add(0);
        // ThisPageUpdater().add(0);
        for (var branch in branches.values) {
          branch.sub.forEach((branchId, branchMeta) {
            Path path = Path();
            path
              ..moveTo(branch.xoffset + 20, branch.yoffset + 20)
              ..lineTo(
                branches[branchMeta.id]!.xoffset + 20,
                branches[branchMeta.id]!.yoffset + 20,
              );

            backStackWidgets[branchId] = CustomPaint(
              painter:
                  TrimPathPainter(trimPercent, trimOrigin, path, id: branchId),
            );
          });
          loaded++;
          updater.SpecialUpdaterX('branches_loader').add(0);
        }
        ThisPageUpdater().add(0);
      },
    ).then(
      (value) => ready = true,
    );
  }

  @override
  void dispose() {
    super.dispose();
    stackWidgets.clear();
    backStackWidgets.clear();
    selectedBranches.clear();
    frontStackWidgets.clear();
    branches.clear();
    timeLine.clear();
    ids.clear();
    // xOffset = .0;
    // yOffset = .0;
    maxXOffset = 10000;
    maxYOffset = 10000;
    minXOffset = .0;
    minYOffset = .0;
    xMoveSpeed = .0;
    yMoveSpeed = .0;
    selectedItem = null;
    ready = false;
    firstSelectedBranch = null;
    secondSelectedBranch = null;
    sbColor = Colors.black;
  }

  var loading = false;

  void addMainBranch() {
    String bid = genBranchId();
    Branch branch = Branch(
      bid,
      branchNameController.text,
      xoffset: 500,
      yoffset: 300,
      color: sbColor.value,
      height: 50,
      width: 110,
      textSize: 12,
      sub: <String, BranchMetadata>{},
    );
    branches[bid] = branch;
    branches.addAll({bid: branch});
    stackWidgets.addAll({bid: CardWidget(branch)});
    timeLine.add(branch, EditEventType.create);
    ThisPageUpdater().add(0);
  }

  void updateSelectedBranchWithTextSize(double size) {
    if (selectedItem is String || selectedItem == null) return;
    sbTextSize = size;
    PropertiesBottomSheetUpdater().add(0);
    if (selectedItem != null) {
      stackWidgets[selectedItem!.id] = CardWidget(selectedItem!);
    }
    branches[(selectedItem as Branch).id]!.textSize = sbTextSize;
    ThisPageUpdater().add(0);
  }

  void updateSelectedBranchWithColor(Color color) {
    if (selectedItem is String || selectedItem == null) return;
    sbColor = color;
    PropertiesBottomSheetUpdater().add(0);
    if (selectedItem != null) {
      stackWidgets[selectedItem!.id] = CardWidget(selectedItem!);
    }
    branches[(selectedItem as Branch).id]!.color = color.value;
    ThisPageUpdater().add(0);
  }

  void updateSelectedBranchWithSize(Size size) {
    if (selectedItem is String || selectedItem == null) return;
    sbSize = size;
    PropertiesBottomSheetUpdater().add(0);
    branches[(selectedItem as Branch).id]!.height = size.height;
    branches[(selectedItem as Branch).id]!.width = size.width;
    if (selectedItem != null) {
      stackWidgets[selectedItem!.id] = CardWidget(selectedItem!);
    }
    ThisPageUpdater().add(0);
  }

  Widget wid5(Color color) => Padding(
        padding: const EdgeInsets.all(4.0),
        child: GestureDetector(
          onTap: () => updateSelectedBranchWithColor(color),
          child: CircleAvatar(
            backgroundColor: color,
            radius: 25,
          ),
        ),
      );

  Future<void> save() async {
    Map<String, Branch> _branches = {...branches};
    Map<String, Branch> _fbranches = {};
    Branch.stream().listen((branch) {
      if (_branches.containsKey(branch.id)) {
      } else {
        branch.delete();
      }
      stdout.writeln('Branch');
      _fbranches.addAll({branch.id: branch});
    }, onDone: () async {
      stdout.writeln('Done');
      for (Branch branch in _branches.values) {
        if (_fbranches.containsKey(branch.id)) {
          await branch.edit();
        } else {
          await branch.add();
        }
      }
      stdout.writeln('All Saved');
    });
  }

  @override
  Widget build(flutter_material.BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (ready) {
              Navigator.pop(context);
            }
          },
        ),
        title: updater.UpdaterBloc(
          updater: updater.SpecialUpdaterX(
            'branches_loader',
            initialState: 0,
            reset: true,
          ),
          update: (context, state) {
            // print(state.data);
            // int fpsMiddle = fpsCounts;
            var _frameCount = frameCount;
            frameCount = 0;
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    '${widget.project.name} - ${_frameCount}FPS ${ready ? "" : ("- Loading Branches.. $loaded/$total")}'),
                ready
                    ? const SizedBox()
                    : const CircularProgressIndicator(color: Colors.white),
              ],
            );
          },
        ),
        //  StreamBuilder(
        //   // stream: Stream.periodic(const Duration(seconds: 1)),
        //   builder: (context, snapshot) {
        //     // int fpsMiddle = fpsCounts;
        //     var _frameCount = frameCount;
        //     frameCount = 0;
        //     return Text('Tree View for ${widget.project.name} $_frameCount');
        //   },
        // ),
        actions: [
          updater.UpdaterBloc(
            updater: ThisPageAppBarUpdater(
              initialState: 0,
              updateForCurrentEvent: true,
            ),
            update: (context, state) {
              return Row(
                children: [
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(Icons.turn_slight_left),
                    onPressed: () {
                      int max = 300;
                      int count = 0;
                      var s = Stream.periodic(const Duration(milliseconds: 16),
                          (b) {
                        return b;
                      });
                      dynamic sub;
                      sub = s.listen((event) {
                        count++;
                        // print('count');
                        if (count > max) {
                          sub.cancel();
                        }
                        ThisPageUpdater().add(0);
                      });
                    },
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(Icons.circle),
                    color: showRelationsDots ? Colors.green : null,
                    onPressed: () {
                      showRelationsDots = !showRelationsDots;
                      ThisPageAppBarUpdater().add(0);
                      ThisPageUpdater().add(0);
                    },
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    color: Colors.red,
                    onPressed: selectedItem == null
                        ? null
                        : (selectedItem is Branch ? deleteBranch : deleteWire),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(Icons.arrow_upward),
                    onPressed: () => bringTo(1),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(Icons.arrow_downward),
                    onPressed: () => bringTo(-1),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(Icons.redo),
                    onPressed: timeLine.redoLast,
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(Icons.undo),
                    onPressed: timeLine.undoLast,
                  ),
                  // const SizedBox(width: 12),
                  // IconButton(
                  //   icon: const Icon(Icons.add_box_outlined),
                  //   onPressed: () {
                  //     addBox = !addBox;
                  //   },
                  // ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(Icons.save),
                    onPressed: save,
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(Icons.color_lens),
                    // color: selectedItem == null
                    //     ? null
                    //     : (selectedItem is Branch &&
                    //             selectedItem?.color != null)
                    //         ? Color(selectedItem.color)
                    //         : null,
                    onPressed: selectedItem == null ? null : colorBottomSheet,
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 250,
                    child: TextField(
                      controller: branchNameController,
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: addMainBranch,
                  ),
                  const SizedBox(width: 12),
                ],
              );
            },
          ),
        ],
      ),
      body: Row(
        children: [
          // ySlider(),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, consts) {
                      maxHeight = consts.maxHeight;
                      maxWidth = consts.maxWidth;
                      if (!didMaxHeightAndWidthSet) {
                        maxXFocus = maxWidth;
                        maxYFocus = maxHeight;
                        didMaxHeightAndWidthSet = true;
                      }

                      return board(context);
                    },
                  ),
                ),
                // xSlider(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onRawKey(key) async {
    if (key.data.isControlPressed && key.logicalKey.keyLabel == 'Z') {
      if (undoPressed) return;
      print('Undo');
      undoPressed = true;
      timeLine.undoLast();
      ThisPageUpdater().add(0);
      Future.delayed(
        const Duration(milliseconds: 300),
        () => undoPressed = false,
      );
      return;
    }

    if (key.data.isControlPressed && key.logicalKey.keyLabel == 'Y') {
      if (redoPressed) return;
      print('Redo');
      redoPressed = true;
      timeLine.redoLast();
      ThisPageUpdater().add(0);
      Future.delayed(
        const Duration(milliseconds: 250),
        () => redoPressed = false,
      );
      return;
    }

    if (key.data.isControlPressed && key.logicalKey.keyLabel == 'F') {
      print('Find');
      return;
    }
    if (key.data.isControlPressed && key.logicalKey.keyLabel == 'A') {
      print('Select All');
      return;
    }
    if (key.data.isControlPressed && key.logicalKey.keyLabel == 'N') {
      print('New Branch');
      return;
    }

    if (key.data.isControlPressed && key.logicalKey.keyLabel == 'S') {
      print('Save');
      if (savePressed) return;
      savePressed = true;
      await save();

      ThisPageUpdater().add(0);
      Future.delayed(
        const Duration(milliseconds: 250),
        () => savePressed = false,
      );
      return;
    }

    if (key.logicalKey.keyLabel == 'Delete') {
      print('Delete');
      if (savePressed) return;
      savePressed = true;
      if (selectedItem != null) {
        (selectedItem is Branch ? deleteBranch() : deleteWire());
      }

      ThisPageUpdater().add(0);
      Future.delayed(
        const Duration(milliseconds: 250),
        () => savePressed = false,
      );
      return;
    }

    controlPressed = (key.data.isControlPressed);
    ZoomUpdater().add(0);
    // if (controlPressed) {
    // } else {
    //   ZoomUpdater().add(0);
    // }
  }

  void onTapBoard() {
    String? lastSelectedWireId;
    Branch? lastSelectedBranch;
    frontStackWidgets.remove('options_list');
    if (selectedItem is String) {
      lastSelectedWireId = selectedItem;
    } else if (selectedItem is Branch) {
      lastSelectedBranch = selectedItem;
    }
    selectedItem = null;
    if (lastSelectedWireId != null) {
      updater.SpecialUpdaterX(lastSelectedWireId).add(0);
    }
    if (lastSelectedBranch != null) {
      updater.SpecialUpdaterX(lastSelectedBranch.id).add(0);
    }
    ThisPageUpdater().add(0);
    unSelectSelectedBranches();
    rklListenerNode.requestFocus();
  }

  Widget board(context) {
    return FutureBuilder(
        future: loadBranches(),
        builder: (context, snapshot) {
          if (!ready) return const SizedBox();
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //   return Center(
          //     child: updater.UpdaterBloc(
          //       updater: updater.SpecialUpdaterX(
          //         'branches_loader',
          //         initialState: 0,
          //         reset: true,
          //       ),
          //       update: (context, state) {
          //         print(state.data);
          //         return Column(
          //           mainAxisSize: MainAxisSize.min,
          //           children: [
          //             Text('Loading Branches.. $loaded/$total'),
          //             const CircularProgressIndicator(),
          //           ],
          //         );
          //       },
          //     ),
          //   );
          // }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                style: const TextStyle(fontSize: 24),
              ),
            );
          }

          // return Container();

          return ZoomMX(
            maxZoomHeight: 10000,
            maxZoomWidth: 10000,
            doubleTapZoom: false,
            maxScale: 3,
            onTap: onTapBoard,
            onScaleUpdate: (dx, dy) {
              // print('$dx - $dy');
              currentScaleValue = dy;
            },
            initScale: 0.5,
            // transformationController: transformationController,
            // onPositionUpdate: onMoveOrSellectionUpdate,
            child: SizedBox(
              // width: 10000,
              // height: 10000,
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                controller: yScrollController,
                child: SizedBox(
                  height: boardHeight,
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: xScrollController,
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: boardWidth,
                      child: RawKeyboardListener(
                        focusNode: rklListenerNode,
                        onKey: onRawKey,
                        child: Center(
                          child: SizedBox(
                            child: updater.UpdaterBloc(
                              updater: ThisPageUpdater(
                                initialState: 0,
                                reset: true,
                              ),
                              update: (context, state) {
                                // print('board');
                                // frameCount++;
                                if (controlPressed) {
                                  return GestureDetector(
                                    onPanDown: (v) {
                                      if (controlPressed) {
                                        onSellectionStarted(
                                          TapDownDetails(
                                            localPosition: Offset(
                                                v.localPosition.dx,
                                                v.localPosition.dy),
                                          ),
                                        );
                                        return;
                                      } else {}
                                    },
                                    onPanEnd: onSellectionEnd,
                                    onPanCancel: selectionCanceled,
                                    onPanUpdate: (details) {
                                      if (controlPressed) {
                                        onMoveOrSellectionUpdate(details);
                                        return;
                                      } else {}
                                    },
                                    onSecondaryTapDown: (v) {
                                      // controlPressed = false;
                                      addOptionsList(v);
                                      // ZoomUpdater().add(0);
                                    },
                                    child: Card(
                                      child: Stack(
                                        children: [
                                          Stack(
                                            children: backStackWidgets.values
                                                .toList(),
                                          ),
                                          Stack(
                                            children:
                                                stackWidgets.values.toList(),
                                          ),
                                          // showRelationsDots
                                          //     ?
                                          Stack(
                                            children: frontStackWidgets.values
                                                .toList(),
                                          )
                                          // : const SizedBox()
                                          ,
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  return GestureDetector(
                                    // onPanEnd: onSellectionEnd,
                                    // onPanStart: onSellectionStarted,
                                    // onPanUpdate: onMoveOrSellectionUpdate,
                                    onSecondaryTapDown: (v) {
                                      // controlPressed = true;
                                      // ZoomUpdater().add(0);
                                      secTapDownOffset = v.localPosition;
                                      addOptionsList(v);
                                      ThisPageUpdater().add(0);
                                      // print(v.localPosition.dx);
                                      // print(v.localPosition.dy);
                                    },

                                    child: Card(
                                      child: Stack(
                                        children: [
                                          Stack(
                                            children: backStackWidgets.values
                                                .toList(),
                                          ),
                                          // updater.UpdaterBloc(
                                          //   updater: ThisPageUpdater(
                                          //     initialState: 0,
                                          //     updateForCurrentEvent: true,
                                          //   ),
                                          //   update: (context, state) {
                                          // StreamBuilder(
                                          //   stream: Stream.periodic(
                                          //       const Duration(milliseconds: 16)),
                                          //   builder: (context, s) {
                                          // frameCount++;
                                          // return Container();
                                          // return
                                          Stack(
                                            children:
                                                stackWidgets.values.toList(),
                                            //   );
                                            // },
                                          ),
                                          // showRelationsDots
                                          //     ?
                                          Stack(
                                            children: frontStackWidgets.values
                                                .toList(),
                                          )
                                          // : const SizedBox()
                                          ,
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  void colorBottomSheet() {
    var cx = .0;
    var cy = .0;
    bool moveStarted = false;
    showModalBottomSheet(
      // isDismissible: false,
      // isScrollControlled: true,
      enableDrag: false,
      context: context,
      builder: (context) {
        return Material(
          child: SizedBox(
            height: 400,
            width: 500,
            child: updater.UpdaterBloc(
              updater: PropertiesBottomSheetUpdater(
                initialState: 0,
                updateForCurrentEvent: true,
              ),
              update: (context, state) {
                return SingleChildScrollView(
                  controller: ScrollController(),
                  child: SizedBox(
                    height: 400,
                    width: 500,
                    child: Card(
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 400,
                              width: 400,
                              color: Colors.white54,
                              child: LayoutBuilder(
                                  builder: (context, constraints) {
                                if (!moveStarted) {
                                  // cx = (constraints.maxWidth / 2) - 70;
                                  // cy = (constraints.maxHeight / 2) - 35;
                                  cx = 200 - 17.5;
                                  cy = 200 - 17.5;
                                }
                                return Stack(
                                  children: [
                                    Positioned(
                                      top: 10,
                                      left: cx,
                                      child: const Text('Height+'),
                                    ),
                                    Positioned(
                                      top: constraints.maxHeight - 40,
                                      left: cx,
                                      child: const Text('Height-'),
                                    ),
                                    Positioned(
                                      top: cy + 17.5,
                                      left: constraints.maxWidth - 60,
                                      child: const Text('Width-'),
                                    ),
                                    Positioned(
                                      top: cy + 17.5,
                                      left: 10,
                                      child: const Text('Width+'),
                                    ),
                                    Positioned(
                                      top: cy,
                                      left: cx,
                                      child: GestureDetector(
                                        onPanStart: (d) {
                                          moveStarted = true;
                                          PropertiesBottomSheetUpdater().add(0);
                                        },
                                        onPanEnd: (d) {
                                          moveStarted = false;
                                          // cx = (constraints.maxWidth / 2) - 0;
                                          // cy = (constraints.maxHeight / 2) - 35;
                                          PropertiesBottomSheetUpdater().add(0);
                                        },
                                        onPanUpdate: (d) {
                                          cx += d.delta.dx;
                                          cy += d.delta.dy;
                                          var fixedHeight = sbSize.height +
                                              (d.delta.dy.isNegative
                                                  ? d.delta.dy * 0.25
                                                  : d.delta.dy * 0.25);
                                          var fixedWidth = sbSize.width +
                                              (d.delta.dx.isNegative
                                                  ? d.delta.dx * .25
                                                  : d.delta.dx * .25);
                                          fixedHeight < 50
                                              ? (fixedHeight = 50)
                                              : null;
                                          fixedWidth < 100
                                              ? (fixedWidth = 100)
                                              : null;
                                          sbSize = Size(
                                            fixedWidth,
                                            fixedHeight,
                                          );
                                          updateSelectedBranchWithSize(sbSize);
                                          PropertiesBottomSheetUpdater().add(0);
                                        },
                                        child: const CircleAvatar(
                                          radius: 35,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 30,
                                  child: Column(
                                    children: [
                                      MaterialButton(
                                        padding: const EdgeInsets.all(0),
                                        elevation: 0,
                                        onPressed: () {
                                          sbTextSize++;
                                          updateSelectedBranchWithTextSize(
                                              sbTextSize);
                                        },
                                        child: const Text('+'),
                                      ),
                                      Text(sbTextSize.toString()),
                                      MaterialButton(
                                        padding: const EdgeInsets.all(0),
                                        elevation: 0,
                                        onPressed: () {
                                          sbTextSize--;
                                          updateSelectedBranchWithTextSize(
                                              sbTextSize);
                                        },
                                        child: const Text('-'),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          const SizedBox(
                                            width: 60,
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                'Blue',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Slider(
                                              min: 0,
                                              max: 255,
                                              value: sbColor.blue.toDouble(),
                                              onChanged: (value) =>
                                                  updateSelectedBranchWithColor(
                                                sbColor.withBlue(value.toInt()),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const SizedBox(
                                            width: 60,
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                'Red',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Slider(
                                              min: 0,
                                              max: 255,
                                              value: sbColor.red.toDouble(),
                                              onChanged: (value) =>
                                                  updateSelectedBranchWithColor(
                                                sbColor.withRed(value.toInt()),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const SizedBox(
                                            width: 60,
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                'Green',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Slider(
                                              min: 0,
                                              max: 255,
                                              value: sbColor.green.toDouble(),
                                              onChanged: (value) =>
                                                  updateSelectedBranchWithColor(
                                                sbColor
                                                    .withGreen(value.toInt()),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const SizedBox(
                                            width: 70,
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                'Opacity',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Slider(
                                              min: 0,
                                              max: 1,
                                              value: sbColor.opacity,
                                              onChanged: (value) =>
                                                  updateSelectedBranchWithColor(
                                                sbColor.withOpacity(value),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              height: 40,
                                              margin: const EdgeInsets.all(8),
                                              child: MaterialButton(
                                                elevation: 0,
                                                color: sbColor,
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('OK'),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              height: 120,
                                              margin: const EdgeInsets.all(8),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          wid5(Colors.yellow),
                                                          wid5(Colors.lime),
                                                          wid5(Colors.orange),
                                                          wid5(Colors
                                                              .deepOrange),
                                                          wid5(Colors.red),
                                                          wid5(Colors.pink),
                                                          wid5(Colors.purple),
                                                          wid5(Colors
                                                              .deepPurple),
                                                          wid5(Colors.indigo),
                                                          wid5(Colors.blue),
                                                          wid5(
                                                              Colors.lightBlue),
                                                          wid5(Colors.cyan),
                                                          wid5(Colors.teal),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      wid5(Colors.green),
                                                      wid5(Colors.blueGrey),
                                                      wid5(Colors.grey),
                                                      wid5(Colors.brown),
                                                      wid5(Colors.black),
                                                      wid5(Colors.black87),
                                                      wid5(Colors.black45),
                                                      wid5(Colors.black26),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void onSellectionEnd(details) {
    // print(
    //     'sXSPoint: $selectionXSPoint');
    // print(
    //     'sXEPoint: $selectionXEPoint');
    // print(
    //     'sYSPoint: $selectionYSPoint');
    // print(
    //     'sYEPoint: $selectionYEPoint');
    // print(
    //     'sXInverted: $selectionXInverted');
    // print(
    //     'sYInverted: $selectionYInverted');
    //
    List<List<Point>> getBounds(
      double xsp,
      double ysp,
      double xep,
      double yep, {
      bool selectionXInverted = false,
      bool selectionYInverted = false,
      bool wantedFix = false,
    }) {
      int _xs = xsp.toInt() + 1;
      int _ys = ysp.toInt() + 1;
      int _xe = xep.toInt() + 1;
      int _ye = yep.toInt() + 1;
      int xs = (selectionXInverted ? _xs + _xe : _xs);
      int ys = (selectionYInverted ? _ys + _ye : _ys);
      int xe = (selectionXInverted ? -_xe : _xe) + (wantedFix ? xs : 0);
      int ye = (selectionYInverted ? -_ye : _ye) + (wantedFix ? ys : 0);

      int xPointsLength = xe - xs;
      int yPointsLength = ye - ys;
      // print('--------------------------------------');
      // print(
      //     '_xs ${_xs.roundToDouble()} | _ys ${_ys.roundToDouble()} | _xe ${_xe.roundToDouble()} | _ye ${_ye.roundToDouble()} | xi $selectionXInverted - yi $selectionYInverted');
      // print(
      //     'xs ${xs.roundToDouble()} | ys ${ys.roundToDouble()} | xe ${xe.roundToDouble()} | ye ${ye.roundToDouble()} | xi $selectionXInverted - yi $selectionYInverted');

      // print('xPnts: $xPointsLength');
      // print('yPnts: $yPointsLength');
      List<Point> topSide =
          List.generate(xPointsLength, (index) => Point(index + xs, ys));
      List<Point> leftSide =
          List.generate(yPointsLength, (index) => Point(xe, index + ys));
      List<Point> rightSide =
          List.generate(yPointsLength, (index) => Point(xs, index + ys));
      List<Point> bottomSide =
          List.generate(xPointsLength, (index) => Point(index + xs, ye));
      // print(topSide);
      // print(leftSide);
      // print(rightSide);
      // print(bottomSide);
      return [topSide, leftSide, bottomSide, rightSide];
    }

    try {
      var selectionBounds = getBounds(
        selectionXSPoint,
        selectionYSPoint,
        selectionXEPoint,
        selectionYEPoint,
        selectionXInverted: selectionXInverted,
        selectionYInverted: selectionYInverted,
        wantedFix: true,
      );

      // selectedBranches = {};
      unSelectSelectedBranches();
      for (var branch in branches.values) {
        var x1 = branch.xoffset;
        var x2 = branch.xoffset + (branch.width ?? 100);
        var y1 = branch.yoffset;
        var y2 = branch.yoffset + (branch.height ?? 50);
        // int sindex = 0;
        bool foundInRange = false;

        var sbound = selectionBounds[0];
        // print('$x1 - ${sbound.first.x} | $x2 - ${sbound.last.x}');
        // print('${x1 > sbound.first.x} | ${x2 < sbound.last.x}');
        if (x1 > sbound.first.x && x2 < sbound.last.x) {
          if (y1 > selectionBounds[1].first.y &&
              y2 < selectionBounds[1].last.y) {
            selectedBranches.addAll({branch.id: branch});
            foundInRange = true;
          }
        }

        if (!foundInRange) {
          // print('Not Found In Range');
          var branchCardBounds = getBounds(x1, y1, x2, y2);
          for (var sbound in selectionBounds) {
            for (var spoint in sbound) {
              for (var bbound in branchCardBounds) {
                for (var bpoint in bbound) {
                  if (spoint.x == bpoint.x && spoint.y == bpoint.y) {
                    selectedBranches.addAll({branch.id: branch});
                    break;
                  }
                  // print('Point');
                }
              }
            }
          }
        }
        // print('--------------------------------------');
        // print(
        //     '${selectionXSPoint.roundToDouble()} - ${selectionYSPoint.roundToDouble()} - ${selectionXEPoint.roundToDouble()} - ${selectionYEPoint.roundToDouble()}');
        // print(
        //     '${x1.roundToDouble()} - ${x2.roundToDouble()} - ${y1.roundToDouble()} - ${y2.roundToDouble()}');
        // if (x1 > selectionYEPoint) {
        //   selectedBranches.add(branch);
        // }
      }
      // print('Slctd Branchs: ${selectedBranches.length}');
      for (var branch in selectedBranches.values) {
        updater.SpecialUpdaterX(branch.id).add(0);
      }
    } catch (e) {
      stdout.writeln(e);
    }

    selectionXSPoint = 0;
    selectionXEPoint = 0;
    selectionYSPoint = 0;
    selectionYEPoint = 0;
    selectionXInverted = false;
    selectionYInverted = false;
    stackWidgets.remove('selection_widget');
    ThisPageUpdater().add(0);
  }
}

void onMoveOrSellectionUpdate(DragUpdateDetails details) {
  if (!controlPressed) {
    // // xOffset += (-details.delta.dx);
    // xOffset += (-details.dx);
    // // if (xOffset > maxXOffset) {
    // //   xOffset = maxXOffset;
    // // }
    // // if (xOffset < minXOffset) {
    // //   xOffset = 0;
    // // }
    // // yOffset += (-details.delta.dy);
    // yOffset += (-details.dy);
    // // if (yOffset > maxYOffset) {
    // //   yOffset = maxYOffset;
    // // }
    // // if (yOffset < minYOffset) {
    // //   yOffset = 0;
    // // }
    // print('----------------');
    // print('${details.dx} - ${details.dy}');
    // var ofst = transformationController.toScene(Offset(xOffset, yOffset));
    // // transformationController.value = Matrix;
    // print('$xOffset - $yOffset');
    // print('${ofst.dx} - ${ofst.dy}');
    // // xScrollController.jumpTo(xOffset);
    // // yScrollController.jumpTo(xOffset);
    // xScrollController.jumpTo(ofst.dx);
    // yScrollController.jumpTo(ofst.dy);
  } else {
    selectionXEPoint += (details.delta.dx);
    selectionYEPoint += (details.delta.dy);
    // print('${details.delta.dx} - ${details.delta.dy}');

    if (selectionXEPoint.isNegative) {
      selectionXInverted = true;
    } else {
      selectionXInverted = false;
    }
    if (selectionYEPoint.isNegative) {
      selectionYInverted = true;
    } else {
      selectionYInverted = false;
    }
    stackWidgets.addAll({
      'selection_widget': Positioned(
        top: selectionYInverted
            ? (selectionYSPoint + selectionYEPoint)
            : selectionYSPoint,
        left: selectionXInverted
            ? (selectionXSPoint + selectionXEPoint)
            : selectionXSPoint,
        child: Container(
          height: selectionYInverted ? -selectionYEPoint : selectionYEPoint,
          width: selectionXInverted ? -selectionXEPoint : selectionXEPoint,
          color: Colors.blueAccent.withOpacity(.4),
        ),
      ),
    });
  }
  ThisPageUpdater().add(0);
}

Widget widg235(String title, void Function()? onPressed) => MaterialButton(
      padding: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12 - (currentScaleValue * 1.8)),
      ),
      minWidth: 150 - (currentScaleValue * 15),
      height: 30 - (currentScaleValue * 1.6),
      onPressed: onPressed == null
          ? null
          : () {
              onPressed();
              frontStackWidgets.remove('options_list');
              ThisPageUpdater().add(0);
            },
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12 - (currentScaleValue * 1.4),
        ),
      ),
    );

void addOptionsList(v) {
  frontStackWidgets.addAll({
    'options_list': Positioned(
      top: v.localPosition.dy,
      left: v.localPosition.dx,
      child: SizedBox(
        width: 150 - (currentScaleValue * 15),
        // height: 270 - (currentScaleValue * 45),
        child: Card(
          color: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12 - (currentScaleValue * 1.8)),
          ),
          child: Column(
            children: [
              widg235(
                'Copy',
                selectedItem == null ? null : () => copiedBranch = selectedItem,
              ),
              widg235(
                'Past',
                copiedBranch == null
                    ? null
                    : () => pastBranch(
                          copiedBranch!,
                          secTapDownOffset,
                        ),
              ),
              widg235('Cut', null),
              widg235(
                'Delete',
                selectedItem == null
                    ? null
                    : (selectedItem is Branch ? deleteBranch : deleteWire),
              ),
              widg235('Undo', timeLine.undoLast),
              widg235('Redo', timeLine.redoLast),
              widg235('Bring To Front',
                  selectedItem == null ? null : () => bringTo(1)),
              widg235('Bring To Back',
                  selectedItem == null ? null : () => bringTo(-1)),
              widg235(
                  'Send To Front',
                  selectedItem == null
                      ? null
                      : () => bringTo(stackWidgets.length - 2)),
              widg235('Send To Back',
                  selectedItem == null ? null : () => bringTo(0)),
            ],
          ),
        ),
      ),
    ),
  });
}

void selectionCanceled() {
  selectionXSPoint = 0;
  selectionXEPoint = 0;
  selectionYSPoint = 0;
  selectionYEPoint = 0;
  selectionXInverted = false;
  selectionYInverted = false;
  stackWidgets.remove('selection_widget');
  ThisPageUpdater().add(0);
}

void onSellectionStarted(TapDownDetails details) {
  selectionXSPoint = (details.localPosition.dx);
  selectionYSPoint = (details.localPosition.dy);

  // print('${details.localPosition.dx} - ${details.localPosition.dy}');
}
// if (xOffset - v.delta.dx < minXOffset) {
// } else {
//   xOffset += v.delta.dx;
// }
// if (xOffset + v.delta.dx > maxXOffset) {
// } else {
//   xOffset += v.delta.dx;
// }
// print('xOffset: $xOffset');

// if (v.delta.dy.isNegative &&
//     yOffset - v.delta.dy < minYOffset) {
//   print('true1');
// } else {
//   print('false1');
//   yOffset += v.delta.dy;
//   if (yOffset < minYOffset) {
//     yOffset = 0;
//   }
// }
// if (v.delta.dy.isNegative &&
//     yOffset + v.delta.dy > maxYOffset) {
//   print('true2');
// } else {
//   print('false2');
//   yOffset += v.delta.dy;
//   if (yOffset > maxYOffset) {
//     yOffset = maxYOffset;
//   }
// }

// maxZoomHeight: 10000,
// maxZoomWidth: 10000,
// doubleTapZoom: false,
// maxScale: 6,
// scrollWeight: 0.1,
// zoomSensibility: 0.01,
// onScaleUpdate: (dx, dy) {
//   print('$dx - $dy');
//   xMoveSpeed = dx;
//   yMoveSpeed = dy;
//   // boardWidth = 10000 + (dx * 500);
//   // boardHeight =
//   //     10000 + (dy * 500);
//   // maxXOffset = boardWidth;
//   // maxYOffset = boardHeight;
//   // print(boardWidth);
//   // print(boardHeight);
//   // ThisPageUpdater2().add(0);
// },
// onPositionUpdate: (p) {},

// Expanded(
//   child: Card(
//     color: Colors.black,
//     child: Text('asfas'),
//   ),
// ),
// Row(
//   children: [
//     const SizedBox(
//       width: 60,
//       child: Padding(
//         padding: EdgeInsets.all(8.0),
//         child: Text(
//           'Height',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     ),
//     Expanded(
//       child: Slider(
//         min: 0,
//         max: 255,
//         value: sbSize.height,
//         onChanged: (value) {
//           sbSize = Size(
//             sbSize.width,
//             sbSize.height + value,
//           );
//           updateSelectedBranchWithSize(
//             sbSize,
//           );
//         },
//       ),
//     ),
//   ],
// ),

// int _xs = selectionXSPoint.toInt() + 1;
// int _ys = selectionYSPoint.toInt() + 1;
// int _xe = selectionXEPoint.toInt() + 1;
// int _ye = selectionYEPoint.toInt() + 1;
// int xs = (selectionXInverted ? _xs + _xe : _xs);
// int ys = (selectionYInverted ? _ys + _ye : _ys);
// int xe = (selectionXInverted ? -_xe : _xe);
// int ye = (selectionYInverted ? -_ye : _ye);

// int xPointsLength = xe - xs;
// int yPointsLength = ye - ys;
// print('--------------------------------------');
// print(
//     '_xs ${_xs.roundToDouble()} | _ys ${_ys.roundToDouble()} | _xe ${_xe.roundToDouble()} | _ye ${_ye.roundToDouble()} | xi $selectionXInverted - yi $selectionYInverted');
// print(
//     'xs ${xs.roundToDouble()} | ys ${ys.roundToDouble()} | xe ${xe.roundToDouble()} | ye ${ye.roundToDouble()} | xi $selectionXInverted - yi $selectionYInverted');

// print(xPointsLength);
// print(yPointsLength);
// List<Point> topSide =
//     List.generate(xPointsLength, (index) => Point(index + xs, ys));
// List<Point> leftSide =
//     List.generate(yPointsLength, (index) => Point(xe, index + ys));
// List<Point> rightSide =
//     List.generate(yPointsLength, (index) => Point(xs, index + ys));
// List<Point> bottomSide =
//     List.generate(xPointsLength, (index) => Point(index + xs, ye));
// print(topSide);
// print(leftSide);
// print(rightSide);
// print(bottomSide);

// var matrix = Matrix4.zero();
// matrix.dotRow(i, v);

// sbound = selectionBounds[1];
// print('$y1 - ${sbound.first.y} | $y2 - ${sbound.last.y}');
// print('${y1 > sbound.first.y} | ${y2 < sbound.last.y}');
// if (y1 > sbound.first.y && y2 < sbound.last.y) {
//   if (x1 > selectionBounds[0].first.x ||
//       x2 < selectionBounds[0].last.x) {
//     selectedBranches.addAll({branch.id: branch});
//     foundInRange = true;
//   }
// }
// for (var sbound in selectionBounds) {
//   // for (var spoint in sbound) {
//   // for (var bbound in branchCardBounds) {
//   //   for (var bpoint in bbound) {
//   switch (sindex) {
//     case 0: // left
//       print('$x1 - ${sbound.first.x} | $x2 - ${sbound.last.x}');
//       print('${x1 > sbound.first.x} | ${x2 < sbound.last.x}');
//       if (x1 > sbound.first.x && x2 < sbound.last.x) {
//         if (y1 > sbound.first.y || y2 < sbound.last.y) {
//           selectedBranches.addAll({branch.id: branch});
//           foundInRange = true;
//         }
//       }
//       break;
//     case 1: // top
//       print('$y1 - ${sbound.first.y} | $y2 - ${sbound.last.y}');
//       print('${y1 > sbound.first.y} | ${y2 < sbound.last.y}');
//       if (y1 > sbound.first.y && y2 < sbound.last.y) {
//         if (x1 < sbound.first.x || x2 > sbound.last.x) {
//           selectedBranches.addAll({branch.id: branch});
//           foundInRange = true;
//         }
//       }
//       break;
//     // case 2: // right
//     //   print('$x1 - ${sbound.first.x} | $x2 - ${sbound.last.x}');
//     //   print('${x1 > sbound.first.x} | ${x2 < sbound.last.x}');
//     //   if (x1 > sbound.first.x && x2 < sbound.last.x) {
//     //     selectedBranches.addAll({branch.id: branch});
//     //     foundInRange = true;
//     //   }
//     //   break;
//     // case 3: // bottom
//     //   print('$y1 - ${sbound.first.y} | $y2 - ${sbound.last.y}');
//     //   print('${y1 > sbound.first.y} | ${y2 < sbound.last.y}');
//     //   if (y1 > sbound.first.y && y2 < sbound.last.y) {
//     //     selectedBranches.addAll({branch.id: branch});
//     //     foundInRange = true;
//     //   }
//     //   break;
//   }
//   sindex++;
// }


  // Widget ySlider() {
  //   return SizedBox(
  //     width: 30,
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.spaceAround,
  //       children: [
  //         MaterialButton(
  //           minWidth: 30,
  //           child: const Icon(
  //             Icons.arrow_drop_up,
  //             size: 20,
  //           ),
  //           onPressed: () {
  //             if (yOffset - 100 < minYOffset) return;
  //             yScrollController.animateTo(
  //               yOffset -= 100,
  //               duration: const Duration(milliseconds: 200),
  //               curve: Curves.ease,
  //             );
  //             ThisPageUpdater().add(0);
  //           },
  //         ),
  //         Expanded(
  //           child: Slider(
  //             value: yOffset,
  //             max: maxYOffset,
  //             min: minYOffset,
  //             onChanged: (y) {
  //               yOffset = y;
  //               yScrollController.animateTo(
  //                 yOffset,
  //                 duration: const Duration(milliseconds: 200),
  //                 curve: Curves.ease,
  //               );
  //               ThisPageUpdater().add(0);
  //             },
  //             onChangeEnd: (y) {
  //               yScrollController.animateTo(
  //                 yOffset,
  //                 duration: const Duration(milliseconds: 200),
  //                 curve: Curves.ease,
  //               );
  //               ThisPageUpdater().add(0);
  //             },
  //           ),
  //         ),
  //         MaterialButton(
  //           minWidth: 30,
  //           child: const Icon(
  //             Icons.arrow_drop_down,
  //             size: 20,
  //           ),
  //           onPressed: () {
  //             if (yOffset + 100 > maxYOffset) return;
  //             yScrollController.animateTo(
  //               yOffset += 100,
  //               duration: const Duration(milliseconds: 200),
  //               curve: Curves.ease,
  //             );
  //             ThisPageUpdater().add(0);
  //           },
  //         ),
  //         const SizedBox(height: 30),
  //       ],
  //     ),
  //   );
  // }

  // Widget xSlider() {
  //   return SizedBox(
  //     height: 30,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceAround,
  //       children: [
  //         MaterialButton(
  //           minWidth: 40,
  //           child: const Icon(
  //             Icons.arrow_left,
  //             size: 30,
  //           ),
  //           onPressed: () {
  //             if (xOffset - 100 < minXOffset) return;
  //             xScrollController.animateTo(
  //               xOffset -= 100,
  //               duration: const Duration(milliseconds: 200),
  //               curve: Curves.ease,
  //             );
  //             ThisPageUpdater().add(0);
  //           },
  //         ),
  //         Expanded(
  //           child: Slider(
  //             value: xOffset,
  //             max: maxXOffset,
  //             min: minXOffset,
  //             onChanged: (x) {
  //               xOffset = x;
  //               xScrollController.animateTo(
  //                 xOffset,
  //                 duration: const Duration(milliseconds: 200),
  //                 curve: Curves.ease,
  //               );
  //               ThisPageUpdater().add(0);
  //             },
  //             onChangeEnd: (x) {
  //               xScrollController.animateTo(
  //                 xOffset,
  //                 duration: const Duration(milliseconds: 200),
  //                 curve: Curves.ease,
  //               );
  //               ThisPageUpdater().add(0);
  //             },
  //           ),
  //         ),
  //         MaterialButton(
  //           minWidth: 40,
  //           child: const Icon(
  //             Icons.arrow_right,
  //             size: 30,
  //           ),
  //           onPressed: () {
  //             if (xOffset + 100 > maxXOffset) return;
  //             xScrollController.animateTo(
  //               xOffset += 100,
  //               duration: const Duration(milliseconds: 200),
  //               curve: Curves.ease,
  //             );
  //             ThisPageUpdater().add(0);
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }
