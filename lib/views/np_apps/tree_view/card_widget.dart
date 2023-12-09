import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as flutter_material;

import 'branch_model.dart';
import 'event_time_line.dart';
import 'path_painter.dart';
import 'project_tree_view.dart';

import 'package:updater/updater.dart' as updater;

import 'updaters.dart';

//////////////////////////////////////////////////////////////////
void pastBranch(Branch branch, Offset offset) {
  String bid = genBranchId();
  double xoffset;
  double yoffset;
  if (offset == Offset.zero) {
    xoffset = branches[branch.id]!.xoffset + 100;
    yoffset = branches[branch.id]!.yoffset + 50;
  } else {
    xoffset = offset.dx;
    yoffset = offset.dy;
  }
  var newBranch = Branch(
    bid,
    '',
    xoffset: xoffset,
    yoffset: yoffset,
    color: branch.color,
    height: branch.height,
    width: branch.width,
    textSize: branch.textSize ?? 11,
    sub: <String, BranchMetadata>{},
  );

  branches.addAll({newBranch.id: newBranch});

  Branch? lastSelectedBranch;
  String? lastSelectedWire;

  if (selectedItem is String) {
    lastSelectedWire = selectedItem;
  } else if (selectedItem is Branch) {
    lastSelectedBranch = selectedItem;
  }

  selectedItem = newBranch;
  if (lastSelectedBranch != null) {
    updater.SpecialUpdaterX(lastSelectedBranch.id).add(0);
  }
  if (lastSelectedWire != null) {
    updater.SpecialUpdaterX(lastSelectedWire).add(0);
  }

  stackWidgets.addAll({
    newBranch.id: CardWidget(
      newBranch,
    ),
  });

  var data = newBranch;
  timeLine.add(data, EditEventType.past);
  ThisPageUpdater().add(0);
}

Map<String, dynamic> ids = {};

class CardWidget extends StatelessWidget {
  CardWidget(
    this.branch, {
    Key? key,
    // this.height,
    // this.width,
  }) : super(key: key) {
    // print('Point');

    // if (ids.containsKey(branch.id)) {
    //   updaterOfWid = ids[branch.id];
    //   // print(0);
    // } else {
    //   updaterOfWid = CardUpdater(
    //     branch.id,
    //     initialState: '',
    //     updateForCurrentEvent: true,
    //   );
    //   ids.addAll({branch.id: updaterOfWid});
    // }
  }

  // late updater.SpecialUpdaterX updaterOfWid;
  // late updater.SpecialUpdaterX updaterOfWidDot;

  Branch branch;
  // final double? height;
  // final double? width;
  FocusNode rklListenerNode = FocusNode();

  void reloadWith(Branch branch) {
    this.branch = branch;
  }

  //////////////////////////////////////////////////////////////////
  void onMovingCard(v) {
    String? lastSelectedWireId;
    Branch? lastSelectedBranch;

    if (selectedItem is String) {
      // WireUpdater(selectedItem).add(0);
      lastSelectedWireId = selectedItem;
    } else if (selectedItem is Branch) {
      lastSelectedBranch = selectedItem;
      // CardUpdater(branch.id).add(0);
    }

    // if (selectedBranches.containsKey(branch.id)) {

    // }

    branch.xoffset += (v.delta.dx);
    branch.yoffset += (v.delta.dy);
    branches[branch.id] = branch;

    // var subBranches = {...branch.sub};
    branch.sub.forEach((relationId, branchMeta) {
      Path path = Path();
      path
        ..moveTo(branch.xoffset + 20, branch.yoffset + 20)
        ..lineTo(
          branches[branchMeta.id]!.xoffset + 20,
          branches[branchMeta.id]!.yoffset + 20,
        );

      backStackWidgets[relationId] = CustomPaint(
        painter: TrimPathPainter(
          trimPercent,
          trimOrigin,
          path,
          id: relationId,
        ),
      );

      // path = Path();
      // addOval(double radius) {
      //   path.addOval(
      //     Rect.fromCircle(
      //       center: Offset(
      //         ((branches[branchMeta.id]!.xoffset - branch.xoffset) / 2) +
      //             branch.xoffset +
      //             0,
      //         ((branches[branchMeta.id]!.yoffset - branch.yoffset) / 2) +
      //             branch.yoffset +
      //             0,
      //       ),
      //       radius: radius,
      //     ),
      //   );
      //   return path;
      // }

      // addOval(8);
      // addOval(6);
      // addOval(4);
      // addOval(2);
      // addOval(1);

      // if (ids.containsKey(relationId)) {
      //   updaterOfWidDot = ids[relationId];
      //   // print(0);
      // } else {
      //   updaterOfWidDot = CardUpdater(
      //     relationId,
      //     initialState: 0,
      //     updateForCurrentEvent: true,
      //   );
      //   ids.addAll({relationId: updaterOfWidDot});
      // }

      frontStackWidgets[relationId] = WireGesture(
        relationId,
        branch: branch,
        branchMeta: branchMeta,
      );
    });

    // stackWidgets[branch.id] = CardWidget(branch);
    (stackWidgets[branch.id] as CardWidget).reloadWith(branch);

    if (lastSelectedWireId != null) {
      updater.SpecialUpdaterX(lastSelectedWireId).add(0);
    }
    if (lastSelectedBranch != null) {
      updater.SpecialUpdaterX(lastSelectedBranch.id).add(0);
    }
    // updater.SpecialUpdaterX(branch.id).add(0);
    ThisPageUpdater().add(0);
  }

  //////////////////////////////////////////////////////////////////
  void onTapCard() {
    print(branch.toMap());
    rklListenerNode.requestFocus();
    String? lastSelectedWireId;
    Branch? lastSelectedBranch;

    if (selectedItem is String) {
      lastSelectedWireId = selectedItem;
    } else if (selectedItem is Branch) {
      lastSelectedBranch = selectedItem;
    }

    selectedItem = branch;
    sbColor = Color(selectedItem!.color);
    ThisPageAppBarUpdater().add(0);
    // print('Branch Id: ${selectedItem?.id}');
    // try {
    //   print('First Subbranch Id: ${selectedItem?.sub.values.first.id}');
    // } catch (e) {
    //   //
    // }

    if (lastSelectedBranch != null) {
      updater.SpecialUpdaterX(lastSelectedBranch.id).add(0);
    }
    if (lastSelectedWireId != null) {
      updater.SpecialUpdaterX(lastSelectedWireId).add(0);
    }
    updater.SpecialUpdaterX(branch.id).add(0);
    unSelectSelectedBranches();
    ThisPageUpdater().add(0);
  }

  //////////////////////////////////////////////////////////////////
  void onSecondaryTapCard(TapDownDetails v) {
    // print(v.localPosition.dx);
    // print(v.localPosition.dy);
    rklListenerNode.requestFocus();
    String? lastSelectedWireId;
    Branch? lastSelectedBranch;

    if (selectedItem is String) {
      lastSelectedWireId = selectedItem;
    } else if (selectedItem is Branch) {
      lastSelectedBranch = selectedItem;
    }

    selectedItem = branch;
    sbColor = Color(selectedItem!.color);
    ThisPageAppBarUpdater().add(0);

    if (lastSelectedBranch != null) {
      updater.SpecialUpdaterX(lastSelectedBranch.id).add(0);
    }
    if (lastSelectedWireId != null) {
      updater.SpecialUpdaterX(lastSelectedWireId).add(0);
    }
    updater.SpecialUpdaterX(branch.id).add(0);
    addOptionsList(
        TapDownDetails(localPosition: Offset(branch.xoffset, branch.yoffset)));
    ThisPageUpdater().add(0);
  }

  //////////////////////////////////////////////////////////////////
  void addSubbranch() {
    var r = branches[branch.id];
    if (r == null) return;

    String bid = genBranchId();
    double xoffset = branch.xoffset + 100;
    double yoffset = branch.yoffset + 50;
    var newBranch = Branch(
      bid,
      '',
      xoffset: xoffset,
      yoffset: yoffset,
      color: sbColor.value,
      width: 100,
      height: 50,
      textSize: 11,
      sub: <String, BranchMetadata>{
        '${branch.id}&$bid': BranchMetadata(
          branch.id,
          title: branch.title,
        ),
      },
    );

    var meta = BranchMetadata(
      newBranch.id,
      title: '',
    );

    branch.sub.addAll({'${branch.id}&${newBranch.id}': meta});
    branches[branch.id] = branch; // re asing the value

    branches.addAll({newBranch.id: newBranch});

    Branch? lastSelectedBranch;

    if (selectedItem is String) {
      updater.SpecialUpdaterX(selectedItem).add(0);
    } else if (selectedItem is Branch) {
      lastSelectedBranch = selectedItem;
      updater.SpecialUpdaterX(branch.id).add(0);
    }

    selectedItem = newBranch;
    if (lastSelectedBranch != null) {
      updater.SpecialUpdaterX(lastSelectedBranch.id).add(0);
    }

    final Path path = Path()
      // ..moveTo(branch.xoffset + ((branch.height ?? 50) / 2),
      //     branch.yoffset + ((branch.width ?? 50) / 2))
      ..moveTo(branch.xoffset + 20, branch.yoffset + 20)
      ..lineTo(
        xoffset + 20,
        yoffset + 20,
      );

    backStackWidgets.addAll({
      '${branch.id}&${newBranch.id}': CustomPaint(
        painter: TrimPathPainter(
          trimPercent,
          trimOrigin,
          path,
          id: '${branch.id}&${newBranch.id}',
        ),
      ),
    });
    stackWidgets.addAll({
      newBranch.id: CardWidget(
        newBranch,
      )
    });

    var data = newBranch;
    timeLine.add(data, EditEventType.create);
    ThisPageUpdater().add(0);
    // CardUpdater(branch.id).add(0);
  }

  //////////////////////////////////////////////////////////////////
  void linkOtherBranch() {
    if (firstSelectedBranch == null) {
      firstSelectedBranch = branch;
    } else {
      if (secondSelectedBranch == null) {
        secondSelectedBranch = branch;
        var _firstSelectedBranch = firstSelectedBranch;
        var _secondSelectedBranch = secondSelectedBranch;

        if (secondSelectedBranch!.id == firstSelectedBranch!.id) {
          firstSelectedBranch = null;
          secondSelectedBranch = null;
          updater.SpecialUpdaterX(_firstSelectedBranch?.id).add(0);
          updater.SpecialUpdaterX(_secondSelectedBranch?.id).add(0);
          return;
        }

        firstSelectedBranch!.sub.addAll({
          '${firstSelectedBranch!.id}&${secondSelectedBranch!.id}':
              BranchMetadata(
            secondSelectedBranch!.id,
            title: secondSelectedBranch!.title,
            // xoffet: secondSelectedBranch!.xoffet,
            // yoffet: secondSelectedBranch!.yoffet,
          )
        });
        secondSelectedBranch!.sub.addAll({
          '${firstSelectedBranch!.id}&${secondSelectedBranch!.id}':
              BranchMetadata(
            firstSelectedBranch!.id,
            title: firstSelectedBranch!.title,
            // xoffet: firstSelectedBranch!.xoffet,
            // yoffet: firstSelectedBranch!.yoffet,
          )
        });

        backStackWidgets.clear();
        for (var branch in branches.values) {
          branch.sub.forEach((branchId, branchMeta) {
            final Path path = Path();
            path
              ..moveTo(branch.xoffset + 20, branch.yoffset + 20)
              ..lineTo(
                branches[branchMeta.id]!.xoffset + 20,
                branches[branchMeta.id]!.yoffset + 20,
              );

            // branch.sub[branchId]!.xoffet += 24;
            // branch.sub[branchId]!.yoffet += 24;
            branches[branch.id] = branch;

            backStackWidgets.addAll({
              branchId: CustomPaint(
                painter: TrimPathPainter(
                  trimPercent,
                  trimOrigin,
                  path,
                  id: branchId,
                ),
              ),
            });
          });
        }

        // var data = newBranch;
        // timeLine.add(data, EditEventType.create);

        firstSelectedBranch = null;
        secondSelectedBranch = null;
        updater.SpecialUpdaterX(_firstSelectedBranch?.id).add(0);
        updater.SpecialUpdaterX(_secondSelectedBranch?.id).add(0);
      } else {
        // firstSelectedBranch?.id;
        // secondSelectedBranch?.id;
      }
    }
    // print(firstSelectedBranch);
    // print(secondSelectedBranch);
    updater.SpecialUpdaterX(branch.id).add(0);
    ThisPageUpdater().add(0);
  }

  //////////////////////////////////////////////////////////////////
  void onMovingStarted(v) {
    String? lastSelectedWireId;
    Branch? lastSelectedBranch;

    if (selectedItem is String) {
      lastSelectedWireId = selectedItem;
    } else if (selectedItem is Branch) {
      lastSelectedBranch = selectedItem;
    }

    rklListenerNode.requestFocus();
    selectedItem = branch;
    sbColor = Color(selectedItem!.color);

    if (lastSelectedWireId != null) {
      updater.SpecialUpdaterX(lastSelectedWireId).add(0);
    }
    if (lastSelectedBranch != null) {
      updater.SpecialUpdaterX(lastSelectedBranch.id).add(0);
    }
    ThisPageUpdater().add(0);
  }

  //////////////////////////////////////////////////////////////////
  void onRawKey(RawKeyEvent key) {
    if (key.data.isControlPressed && key.logicalKey.keyLabel == 'C') {
      print('Copy');
      if (selectedItem is Branch) {
        copiedBranch = selectedItem;
      }
    }
    if (key.data.isControlPressed && key.logicalKey.keyLabel == 'V') {
      print('Past');
      if (copiedBranch == null || pastBranchPressed) return;
      pastBranchPressed = true;
      pastBranch(copiedBranch!, secTapDownOffset);
      Future.delayed(
        const Duration(milliseconds: 200),
        () => pastBranchPressed = false,
      );
    }
    if (key.data.isControlPressed && key.logicalKey.keyLabel == 'X') {
      print('Cut');
    }
    // pastBranchPressed = key.repeat;
    // print('key.repeat: ${key.data}');
  }

  @override
  Widget build(flutter_material.BuildContext context) {
    // print(0);
    return updater.UpdaterBloc(
      updater: updater.SpecialUpdaterX(
        branch.id,
        initialState: '',
        reset: true,
      ),
      update: (context, state) {
        return Positioned(
          left: branch.xoffset,
          top: branch.yoffset,
          child: SizedBox(
            height: branch.height ?? 50,
            width: branch.width ?? 100,
            child: GestureDetector(
              onPanUpdate: selectedBranches.containsKey(branch.id)
                  ? (v) {
                      for (var branchId in selectedBranches.keys) {
                        (stackWidgets[branchId] as CardWidget).onMovingCard(v);
                      }
                    }
                  : (v) {
                      onMovingCard(v);
                      // var xBy2 = v.delta.dx / 2;
                      // var yBy2 = v.delta.dy / 2;
                      // onMovingCard(
                      //   DragUpdateDetails(
                      //     delta: Offset(xBy2, yBy2),
                      //     globalPosition: const Offset(0, 0),
                      //   ),
                      // );
                      // onMovingCard(
                      //   DragUpdateDetails(
                      //     delta: Offset(xBy2, yBy2),
                      //     globalPosition: const Offset(0, 0),
                      //   ),
                      // );
                      // onMovingCard(
                      //   DragUpdateDetails(
                      //     delta: Offset(xBy2, yBy2),
                      //     globalPosition: const Offset(0, 0),
                      //   ),
                      // );
                      // onMovingCard(
                      //   DragUpdateDetails(
                      //     delta: Offset(xBy2, yBy2),
                      //     globalPosition: const Offset(0, 0),
                      //   ),
                      // );
                    },
              onPanStart: onMovingStarted,
              onTap: onTapCard,
              onSecondaryTapDown: (v) => onSecondaryTapCard(
                TapDownDetails(
                  localPosition: v.localPosition,
                ),
              ),
              child: RawKeyboardListener(
                focusNode: rklListenerNode,
                onKey: onRawKey,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(
                      width: 0.7,
                      color: selectedBranches.containsKey(branch.id)
                          ? Colors.green
                          : (selectedItem == null || selectedItem is String)
                              ? Colors.transparent
                              : selectedItem!.id == branch.id
                                  ? Colors.white
                                  : Colors.transparent,
                    ),
                  ),
                  color: Color(branch.color),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                branch.id,
                                style: TextStyle(
                                  fontSize: 3,
                                  color: branch.indicator
                                      ? Colors.green
                                      : Colors.white,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                                child: SizedBox(
                                  height: branch.height != null
                                      ? (branch.height! - 20)
                                      : 20,
                                  child: TextField(
                                    onTap: onTapCard,
                                    style: TextStyle(
                                      fontSize: branch.textSize ?? 6,
                                    ),
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.all(4),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    onChanged: (text) {
                                      branches[branch.id]!.title = text;
                                    },
                                    minLines: null,
                                    maxLines: null,
                                    expands: true,
                                    controller: TextEditingController(
                                      text: branch.title,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 15,
                          child: Column(
                            children: [
                              MaterialButton(
                                padding: const EdgeInsets.all(0),
                                child: const Icon(
                                  Icons.add,
                                  size: 10,
                                ),
                                height: 25,
                                onPressed: addSubbranch,
                              ),
                              MaterialButton(
                                padding: const EdgeInsets.all(0),
                                child: const Icon(
                                  Icons.arrow_right,
                                  size: 10,
                                ),
                                height: 25,
                                color: firstSelectedBranch == null
                                    ? null
                                    : firstSelectedBranch!.id == branch.id
                                        ? Colors.green
                                        : secondSelectedBranch == null
                                            ? null
                                            : secondSelectedBranch!.id ==
                                                    branch.id
                                                ? Colors.green
                                                : null,
                                onPressed: linkOtherBranch,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class WireGesture extends StatelessWidget {
  const WireGesture(
    this.relationId, {
    required this.branch,
    required this.branchMeta,
    Key? key,
  }) : super(key: key);
  final String relationId;
  final BranchMetadata branchMeta;
  final Branch branch;

  void onTapPoint() {
    String? lastSelectedWireId;
    Branch? lastSelectedBranch;

    if (selectedItem is String) {
      lastSelectedWireId = selectedItem;
    } else if (selectedItem is Branch) {
      lastSelectedBranch = selectedItem;
    }

    selectedItem = relationId;
    updater.SpecialUpdaterX(relationId).add(0);
    if (lastSelectedWireId != null) {
      updater.SpecialUpdaterX(lastSelectedWireId).add(0);
    }
    if (lastSelectedBranch != null) {
      updater.SpecialUpdaterX(lastSelectedBranch.id).add(0);
    }
    unSelectSelectedBranches();
    ThisPageUpdater().add(0);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: ((branches[branchMeta.id]!.xoffset + 0 - branch.xoffset) / 2) +
          branch.xoffset +
          20,
      top: ((branches[branchMeta.id]!.yoffset + 0 - branch.yoffset) / 2) +
          branch.yoffset +
          20,
      height: 10,
      width: 10,
      child: !showRelationsDots
          ? const SizedBox()
          : GestureDetector(
              onTap: onTapPoint,
              onDoubleTap: () {
                onTapPoint();
                deleteWire();
              },
              child: updater.StatelessUpdaterBloc(
                updater: updater.SpecialUpdaterX(
                  relationId,
                  initialState: 0,
                  reset: true,
                ),
                update: (context, state) {
                  return CircleAvatar(
                    backgroundColor:
                        selectedItem != null && (selectedItem is String)
                            ? selectedItem == relationId
                                ? Colors.green
                                : Colors.white
                            : Colors.white,
                  );
                },
              ),
              //   child: CustomPaint(
              //     painter: TrimPathPainter(
              //       trimPercent,
              //       trimOrigin,
              //       path,
              //       id: relationId,
              //     ),
              //   ),
            ),
    );
  }
}

// class CardUpdater<T> extends updater.SpecialUpdaterX<T> {
//   CardUpdater(id, {initialState, bool updateForCurrentEvent = false})
//       : super(
//           id,
//           initialState,
//           reset: updateForCurrentEvent,
//         );
//   // {  updater.SpecialUpdaterX(
//   //     id,
//   //     initialState,
//   //     reset: updateForCurrentEvent,
//   //   );
//   // }
// }

// class WireUpdater extends updater.SpecialUpdaterX {
//   WireUpdater(id, {initialState, bool updateForCurrentEvent = false})
//       : super(
//           id,
//           initialState,
//           reset: updateForCurrentEvent,
//         );
// }

// class CardUpdater extends updater.SpecialUpdater {
//   CardUpdater(id, {initialState, bool updateForCurrentEvent = false})
//       : super(
//           id,
//           initialState,
//           updateForCurrentEvent: updateForCurrentEvent,
//           updateSpeed: 17,
//         );
// }

// class WireUpdater extends updater.SpecialUpdater {
//   WireUpdater(id, {initialState, bool updateForCurrentEvent = false})
//       : super(
//           id,
//           initialState,
//           updateForCurrentEvent: updateForCurrentEvent,
//           updateSpeed: 17,
//         );
// }

    // backStackWidgets.removeWhere((key, value) => key.contains(branch.id));
    // backStackWidgets.clear();

    // if (branch.parentId != null) { var parentBranch = branches[branch.parentId]; if (parentBranch != null) {
    //     try { parentBranch.sub[branch.id]!.xoffet = branch.xoffet;
    //       parentBranch.sub[branch.id]!.yoffet = branch.yoffet; } catch (e) { // }
    //     path ..moveTo(branch.xoffet + 20, branch.yoffet + 20)
    //       ..quadraticBezierTo(  parentBranch.xoffet + 24,  parentBranch.yoffet + 24,  parentBranch.xoffet + 24, parentBranch.yoffet + 24, );
    //     branches[parentBranch.id] = parentBranch;
    //     // backStackWidgets.remove('${branch.parentId}&${branch.id}');
    //     // backStackWidgets.remove('${branch.id}&${branch.parentId}');
    //     backStackWidgets.addAll({ '${branch.parentId}&${branch.id}': CustomPaint(
    //         painter: TrimPathPainter(trimPercent, trimOrigin, path), ),  });  }}



                // backStackWidgets.clear();
                // for (var branch in branches.values) {
                //   final Path path = Path();
                //   branch.sub.forEach((branchId, branchMeta) {
                //     path
                //       ..moveTo(branch.xoffet + 20, branch.yoffet + 20)
                //       ..quadraticBezierTo(
                //         branchMeta.xoffet + 24,
                //         branchMeta.yoffet + 24,
                //         branchMeta.xoffet + 24,
                //         branchMeta.yoffet + 24,
                //       );backStackWidgets.addAll({
                //       '${branch.id}&$branchId': CustomPaint(
                //         painter: TrimPathPainter(trimPercent, trimOrigin, path),  ),  }); });}
                // ThisPageUpdater().add(0);

                
    // backStackWidgets.clear();
    // for (var branch in branches.values) {
    //   final Path path = Path();
    //   branch.sub.forEach((branchId, branchMeta) {
    //     path
    //       ..moveTo(branch.xoffet + 20, branch.yoffet + 20)
    //       ..quadraticBezierTo(
    //         branchMeta.xoffet + 24,
    //         branchMeta.yoffet + 24,
    //         branchMeta.xoffet + 24,
    //         branchMeta.yoffet + 24,
    //       );
    //     backStackWidgets.addAll({
    //       '${branch.id}&$branchId': CustomPaint(
    //         painter: TrimPathPainter(trimPercent, trimOrigin, path),
    //       ),
    //     });
    //   });
    // }
    // ThisPageUpdater().add(0);
          // print('================================');
      // print(branches[branchMeta.id]!.xoffet);
      // print(branches[branchMeta.id]!.yoffet);
      // print('x: ${branch.xoffet}');
      // print('y: ${branch.yoffet}');
      // print(branches[branchMeta.id]!.xoffet - branch.xoffet + branch.xoffet);
      // print(branches[branchMeta.id]!.yoffet - branch.yoffet + branch.yoffet);
      // path.addOval(
      //   Rect.fromCircle(
      //     center: Offset(
      //       ((branches[branchMeta.id]!.xoffet + 0 - branch.xoffet) / 2) +
      //           branch.xoffet +
      //           20,
      //       ((branches[branchMeta.id]!.yoffet + 0 - branch.yoffet) / 2) +
      //           branch.yoffet +
      //           20,
      //     ),
      //     radius: 10,
      //   ),
      // );

      
    // print(backStackWidgets.length);

    // if (branch.xoffet > (maxXFocus - 10)) {
    //   xOffset += 10;
    //   maxXFocus += 10;
    //   minXFocus += 10;
    //   xScrollController.jumpTo(xOffset);
    // }
    // if (branch.yoffet > (maxYFocus - 10)) {
    //   yOffset += 10;
    //   maxYFocus += 10;
    //   minYFocus += 10;
    //   yScrollController.jumpTo(yOffset);
    // }
    // if (xOffset < minXOffset) {
    //   xOffset = 0;
    // }
    // if (yOffset < minYOffset) {
    //   yOffset = 0;
    // }