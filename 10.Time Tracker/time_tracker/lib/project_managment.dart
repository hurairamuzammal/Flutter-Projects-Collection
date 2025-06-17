import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/model/model.dart';
import 'package:time_tracker/project_task_provider.dart';

class ProjectTaskManagementScreen extends StatelessWidget {
  final _projectController = TextEditingController();
  final _taskController = TextEditingController();

  ProjectTaskManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProjectTaskProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Manage Projects and Tasks')),

      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _projectController,
                    decoration: InputDecoration(labelText: 'New Project Name'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () async {
                    final name = _projectController.text.trim();
                    if (name.isNotEmpty) {
                      await provider.addProject(
                        Project(id: DateTime.now().toString(), name: name),
                      );
                      _projectController.clear();
                    }
                  },
                ),
              ],
            ),
            // --- Show Projects ---
            Text('Projects', style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView(
                children: provider.projects.map((project) {
                  return ListTile(
                    title: Text(project.name),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await provider.deleteProject(project.id);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            Divider(),

            // --- Add Task ---
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: InputDecoration(labelText: 'New Task Name'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () async {
                    final name = _taskController.text.trim();
                    if (name.isNotEmpty) {
                      await provider.addTask(
                        Task(id: DateTime.now().toString(), name: name),
                      );
                      _taskController.clear();
                    }
                  },
                ),
              ],
            ),
            // --- Show Tasks ---
            Text('Tasks', style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView(
                children: provider.tasks.map((task) {
                  return ListTile(
                    title: Text(task.name),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await provider.deleteTask(task.id);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
