import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/model/model.dart';
import 'package:time_tracker/project_task_provider.dart';
import 'package:time_tracker/time_entry_provider.dart';

class AddTimeEntryScreen extends StatefulWidget {
  const AddTimeEntryScreen({super.key});

  @override
  AddTimeEntryScreenState createState() => AddTimeEntryScreenState();
}

class AddTimeEntryScreenState extends State<AddTimeEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  String? selectedProjectId;
  String? selectedTaskId;
  double totalTime = 0.0;
  DateTime date = DateTime.now();
  String notes = '';
  final _notesController = TextEditingController();
  final _timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Time Entry')),
      body: Consumer2<ProjectTaskProvider, TimeEntryProvider>(
        builder: (context, projectTaskProvider, timeEntryProvider, child) {
          final projects = projectTaskProvider.projects;
          final tasks = projectTaskProvider.tasks;

          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // Project Dropdown
                  projects.isEmpty
                      ? Card(
                          color: Colors.amber[100],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'No projects available. Please add one first.',
                              style: TextStyle(color: Colors.brown),
                            ),
                          ),
                        )
                      : DropdownButtonFormField<String>(
                          value: selectedProjectId,
                          decoration: InputDecoration(
                            labelText: 'Project',
                            border: OutlineInputBorder(),
                          ),

                          validator: (value) =>
                              value == null ? 'Please select a project' : null,

                          items: projects
                              .map(
                                (project) => DropdownMenuItem(
                                  value: project.id,
                                  child: Text(project.name),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedProjectId = value;
                            });
                          },
                        ),

                  SizedBox(height: 16),

                  // Task Dropdown
                  tasks.isEmpty
                      ? Card(
                          color: Colors.amber[100],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'No tasks available. Please add one first.',
                              style: TextStyle(color: Colors.brown),
                            ),
                          ),
                        )
                      : DropdownButtonFormField<String>(
                          value: selectedTaskId,
                          decoration: InputDecoration(
                            labelText: 'Task',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) =>
                              value == null ? 'Please select a task' : null,
                          items: tasks
                              .map(
                                (task) => DropdownMenuItem(
                                  value: task.id,
                                  child: Text(task.name),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedTaskId = value;
                            });
                          },
                        ),

                  SizedBox(height: 16),

                  // Time Input
                  TextFormField(
                    controller: _timeController,
                    decoration: InputDecoration(
                      labelText: 'Time (hours)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter time';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      totalTime = double.parse(value!);
                    },
                  ),

                  SizedBox(height: 16),

                  // Date Picker
                  ListTile(
                    title: Text(
                      'Date: ${date.toLocal().toString().split(' ')[0]}',
                    ),
                    trailing: Icon(Icons.calendar_today),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: date,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() {
                          date = picked;
                        });
                      }
                    },
                  ),

                  SizedBox(height: 16),

                  // Notes Input
                  TextFormField(
                    controller: _notesController,
                    decoration: InputDecoration(
                      labelText: 'Notes',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    onSaved: (value) {
                      notes = value ?? '';
                    },
                  ),

                  SizedBox(height: 24),

                  // Submit Button
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        final timeEntry = TimeEntry(
                          id: DateTime.now().toString(),
                          projectId: selectedProjectId!,
                          taskId: selectedTaskId!,
                          totalTime: totalTime,
                          date: date,
                          notes: notes,
                        );

                        timeEntryProvider.addTimeEntry(timeEntry);
                        Navigator.pop(context);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text('Save Time Entry'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _notesController.dispose();
    _timeController.dispose();
    super.dispose();
  }
}
