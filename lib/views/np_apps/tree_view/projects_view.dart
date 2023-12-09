import 'package:flutter/material.dart' hide BuildContext;
import 'package:flutter/material.dart' as flutter_material;
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import 'package:updater/updater.dart' as updater;
import 'package:xenon_cp/model/project_model.dart';
import 'package:xenon_cp/model/tree_view_project.dart';
import 'package:xenon_cp/utils/enums.dart';
import 'package:xenon_cp/views/np_apps/tree_view/projects_view_widget.dart';

import 'project_tree_view.dart';

class TreeView extends StatefulWidget {
  const TreeView({
    Key? key,
    this.onTapProject,
  }) : super(key: key);
  final void Function(TreeViewProject project)? onTapProject;

  @override
  State<TreeView> createState() => _TreeViewState();
}

class _TreeViewState extends State<TreeView> {
  ProjectLang selectedProjectLang = ProjectLang.dart;
  TextEditingController projectDirPathCont = TextEditingController();
  TextEditingController projectNameCont = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  var loading = false;

  Future<void> onTapProject(TreeViewProject project) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProjectTreeView(
          project: project,
        ),
      ),
    );
  }

  @override
  Widget build(flutter_material.BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects View'),
        actions: [
          const IconButton(
            icon: Icon(Icons.delete),
            color: Colors.red,
            onPressed: Project.deleteAll,
          ),
          Container(
            padding: const EdgeInsets.all(8),
            width: 200,
            child: TextField(
              controller: projectNameCont,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.green,
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            padding: const EdgeInsets.all(16),
            icon: const Icon(Icons.add),
            onPressed: save,
          ),
        ],
      ),
      body: updater.UpdaterBloc(
        updater: ThisPageUpdater(
          initialState: '',
          updateForCurrentEvent: true,
        ),
        update: (context, state) {
          return Column(
            children: [
              ProjectsViewWidget(
                onTapProject: widget.onTapProject ?? onTapProject,
              ),
            ],
          );
        },
      ),
    );
    // Get.dialog(widget);
  }

  Future<void> save() async {
    if (projectNameCont.text.isEmpty) {
      Get.snackbar('Exception', 'Provided the project name please');
      return;
    }
    if (projectDirPathCont.text.isEmpty) {
      Get.snackbar('Exception', 'No Worries');
      // return;
    }
    var db = await Hive.openBox('data-projects');
    bool saved = false;
    var nProject = await Project.init(
      projectName: projectNameCont.text,
      projectLang: selectedProjectLang,
      dirPath: null,
    );
    while (!saved) {
      var projectId = nProject.id;
      var exProject = await db.get(projectId);
      if (exProject == null) {
        await db.put(projectId, nProject.toMap());
        saved = true;
      } else {
        nProject.id = Project.newId();
      }
    }
    selectedProjectLang = ProjectLang.dart;
    projectDirPathCont.clear();
    projectNameCont.clear();
    ThisPageUpdater().add('');
  }
}

class ThisPageUpdater extends updater.Updater {
  ThisPageUpdater({initialState, bool updateForCurrentEvent = false})
      : super(
          initialState,
          updateForCurrentEvent: updateForCurrentEvent,
        );
}
