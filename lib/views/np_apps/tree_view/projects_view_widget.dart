import 'package:flutter/material.dart' hide BuildContext;
import 'package:flutter/material.dart' as flutter_material;
import 'package:flutter/services.dart' as services;
import 'package:xenon_cp/model/tree_view_project.dart';
import 'package:xenon_cp/views/np_apps/tree_view/projects_view.dart';

TreeViewProject? selectedProject;

class ProjectsViewWidget extends StatelessWidget {
  ProjectsViewWidget({
    Key? key,
    this.onTapProject,
  }) : super(key: key);
  void Function(TreeViewProject project)? onTapProject;
  List<TreeViewProject> projects = [];

  @override
  Widget build(flutter_material.BuildContext context) {
    return Expanded(
      child: FutureBuilder<List<TreeViewProject>>(
        future: TreeViewProject.getAll(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            projects = snapshot.data!;
          }
          if (snapshot.hasError) {
            print(snapshot.error);
            (snapshot.stackTrace);
            return Center(
              child: Text(
                '${snapshot.error}\n${snapshot.stackTrace}',
              ),
            );
          }
          return ListView.builder(
            itemCount: projects.length,
            itemBuilder: (context, index) {
              var project = projects[index];
              return InkWell(
                onTap: onTapProject != null
                    ? () => onTapProject!(project)
                    : () {
                        selectedProject = project;
                        ThisPageUpdater().add('');
                      },
                borderRadius: BorderRadius.circular(16),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color:
                      selectedProject?.id == project.id ? Colors.black87 : null,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.folder),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 8.0,
                            right: 8.0,
                          ),
                          child: Column(
                            children: [
                              Text(
                                project.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  // fontFamily: ,
                                ),
                              ),
                              Text(
                                project.path ?? '',
                                style: const TextStyle(
                                  // fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          color: Colors.red,
                          onPressed: () async {
                            await TreeViewProject.delete(project.id);
                            ThisPageUpdater().add('');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
