import 'package:flutter/material.dart';

import 'board_widget.dart';
import 'branch_model.dart';
import 'card_widget.dart';
import 'path_painter.dart';
import 'project_tree_view.dart';

class EventTimeLine {
  static final Map<String, dynamic> _instances = <String, dynamic>{};
  final Map<int, EditEvent> _timeLine = <int, EditEvent>{};

  int currentEventIndex = 0;

  static EventTimeLine init(String id) {
    if (_instances[id] != null) {
      return _instances[id];
    }
    _instances[id] = EventTimeLine();
    return _instances[id];
  }

  void redoLast() {
    if (_timeLine.values.isEmpty) return;
    _timeLine.values.last;
  }

  void undoLast() {
    if (_timeLine.values.isEmpty) return;
    if (currentEventIndex <= 0) return;
    // print(_timeLine);
    EditEvent event = _timeLine[currentEventIndex - 1]!;
    switch (event.type) {
      case EditEventType.delete:
        undoDeleteEvent(event);
        break;
      case EditEventType.create:
        // TODO: Handle this case.
        break;
      case EditEventType.edit:
        // TODO: Handle this case.
        break;
      case EditEventType.past:
        undoPastEvent(event);
        break;
      case EditEventType.cut:
        // TODO: Handle this case.
        break;
      case EditEventType.change:
        // TODO: Handle this case.
        break;
      case EditEventType.undo:
        // Do Nothing
        break;
    }
    currentEventIndex--;
    print('$currentEventIndex - ${event.type}');

    // add(event, EditEventType.undo);
  }

  void undoPastEvent(EditEvent event) {
    switch (event.data.runtimeType) {
      case Branch:
        var branch = event.data as Branch;
        branch.sub.forEach((relationId, subBranMeta) {
          branches[subBranMeta.id]
              ?.sub
              .removeWhere((key, value) => key == branch.id);
          frontStackWidgets.remove(relationId);
        });
        backStackWidgets.removeWhere((key, value) => key.contains(branch.id));
        stackWidgets.remove(branch.id);
        branches.remove(branch.id);
        break;
      case CustomPaint:
        var widget = event.data as CustomPaint;
        var path = (widget.child as TrimPathPainter);
        backStackWidgets.removeWhere((key, value) => key.contains(path.id));

        var bANDb = path.id.split('&');
        var fb = branches[bANDb.first];
        var sb = branches[bANDb.last];
        fb!.sub.remove(sb);
        sb!.sub.remove(fb);
        branches[bANDb.first] = fb;
        branches[bANDb.last] = sb;
        break;
      case DomainBoard:
        var board = event.data as DomainBoard;
        backStackWidgets.remove(board.id);
        break;
      default:
    }
  }

  void undoDeleteEvent(EditEvent event) {
    switch (event.data.runtimeType) {
      case Branch:
        Branch branch = event.data;
        stackWidgets.addAll({
          branch.id: CardWidget(
            branch,
          ),
        });
        branch.sub.forEach((relationId, branchMeta) {
          if (branches[branchMeta.id] == null) return;
          branches[branchMeta.id]!.sub.addAll({
            relationId: BranchMetadata(branch.id, title: branch.title),
          });

          // stackWidgets.addAll({
          //   branches[branchMeta.id]!.id: CardWidget(
          //     branches[branchMeta.id]!,
          //   ),
          // });
        });
        break;
      case CustomPaint:
        CustomPaint widget = event.data;
        var path = (widget.child as TrimPathPainter);
        backStackWidgets.addAll({path.id: widget});
        var bANDb = path.id.split('&');
        var fb = branches[bANDb.first];
        var sb = branches[bANDb.last];
        fb!.sub.addAll({path.id: BranchMetadata(sb!.id, title: sb.title)});
        sb.sub.addAll({path.id: BranchMetadata(fb.id, title: fb.title)});
        branches[bANDb.first] = fb;
        branches[bANDb.last] = sb;
        break;
      case DomainBoard:
        DomainBoard board = event.data;
        var widget = DomainBoardWidget(board: board);
        backStackWidgets.addAll({board.id: widget});
        break;
      default:
    }
  }

  void add(data, EditEventType type) {
    if (data == null) throw 'Data Cannot Be Null';
    _timeLine.addAll({
      currentEventIndex: EditEvent(type, data),
    });
    currentEventIndex++;
    print('$currentEventIndex - $type');
  }

  void clear() {
    _timeLine.clear();
    currentEventIndex = 0;
  }
}

class EditEvent {
  EditEvent(this.type, this.data);
  EditEventType type;
  dynamic data;

  Map<String, dynamic> toMap() => {
        't': type, // Type
        'd': data, // Data
      };

  // fromMap() {}
}

enum EditEventType {
  delete,
  create,
  edit,
  past,
  // copy,
  cut,
  undo,
  change,
}

enum ObjectType {
  branch,
  baord,
  path,
}
