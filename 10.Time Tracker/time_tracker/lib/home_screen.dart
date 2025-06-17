import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/add_time_entry.dart';
import 'package:time_tracker/project_managment.dart';
import 'package:time_tracker/project_task_provider.dart';
import 'package:time_tracker/time_entry_provider.dart';
import 'package:time_tracker/model/model.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        // drawer with a list of projects and tasks
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Text(
                  'Time Tracker',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              ListTile(
                leading: Icon(Icons.folder_outlined),
                title: Text('Project Management'),
                onTap: () {
                  Navigator.pop(context); // Close drawer
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProjectTaskManagementScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.task_outlined),
                title: Text('Task Management'),
                onTap: () {
                  Navigator.pop(context); // Close drawer
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddTimeEntryScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(text: 'Home'),
              Tab(text: 'Project Tab'),
            ],
          ),
          title: Text('Time Entries'),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AddTimeEntryScreen()),
                );
              },
              tooltip: 'Add Time Entry',
            ),
          ],
        ),
        body: TabBarView(
          children: [
            Consumer2<TimeEntryProvider, ProjectTaskProvider>(
              builder: (context, timeProvider, projectTaskProvider, child) {
                if (timeProvider.entries.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.access_time, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No time entries yet',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Tap the + button to add your first time entry',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: timeProvider.entries.length,
                  itemBuilder: (context, index) {
                    final entry = timeProvider.entries[index];
                    final project = projectTaskProvider.projects.firstWhere(
                      (p) => p.id == entry.projectId,
                      orElse: () =>
                          Project(id: 'unknown', name: 'Unknown Project'),
                    );
                    final task = projectTaskProvider.tasks.firstWhere(
                      (t) => t.id == entry.taskId,
                      orElse: () => Task(id: 'unknown', name: 'Unknown Task'),
                    );

                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: ListTile(
                        title: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    project.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    task.name,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue[100],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '${entry.totalTime}h',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[900],
                                ),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 4),
                            Text(DateFormat('MMM dd, yyyy').format(entry.date)),
                            if (entry.notes.isNotEmpty)
                              Text(
                                entry.notes,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red[300]),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Delete Time Entry'),
                                content: Text(
                                  'Are you sure you want to delete this time entry?',
                                ),
                                actions: [
                                  TextButton(
                                    child: Text('Cancel'),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  TextButton(
                                    child: Text('Delete'),
                                    onPressed: () {
                                      timeProvider.deleteTimeEntry(entry.id);
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),

            Consumer2<TimeEntryProvider, ProjectTaskProvider>(
              builder: (context, timeProvider, projectTaskProvider, child) {
                if (timeProvider.entries.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.bar_chart, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No time entries to group',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Add some time entries to see them grouped by project',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Group entries by project and calculate total time
                Map<String, double> projectTotals = {};
                Map<String, List<TimeEntry>> projectEntries = {};

                for (var entry in timeProvider.entries) {
                  if (!projectTotals.containsKey(entry.projectId)) {
                    projectTotals[entry.projectId] = 0;
                    projectEntries[entry.projectId] = [];
                  }
                  projectTotals[entry.projectId] =
                      (projectTotals[entry.projectId] ?? 0) + entry.totalTime;
                  projectEntries[entry.projectId]!.add(entry);
                }

                return ListView.builder(
                  itemCount: projectTotals.length,
                  itemBuilder: (context, index) {
                    String projectId = projectTotals.keys.elementAt(index);
                    Project project = projectTaskProvider.projects.firstWhere(
                      (p) => p.id == projectId,
                      orElse: () =>
                          Project(id: 'unknown', name: 'Unknown Project'),
                    );

                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: ExpansionTile(
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                project.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue[100],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '${projectTotals[projectId]?.toStringAsFixed(1)}h',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[900],
                                ),
                              ),
                            ),
                          ],
                        ),
                        children: projectEntries[projectId]!.map((entry) {
                          Task task = projectTaskProvider.tasks.firstWhere(
                            (t) => t.id == entry.taskId,
                            orElse: () =>
                                Task(id: 'unknown', name: 'Unknown Task'),
                          );

                          return ListTile(
                            title: Text(task.name),
                            subtitle: Text(
                              DateFormat('MMM dd, yyyy').format(entry.date),
                            ),
                            trailing: Text(
                              '${entry.totalTime}h',
                              style: TextStyle(color: Colors.blue[700]),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddTimeEntryScreen()),
            );
          },
          tooltip: 'Add Time Entry',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
