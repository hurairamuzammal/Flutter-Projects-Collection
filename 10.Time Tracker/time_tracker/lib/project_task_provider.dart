import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_tracker/model/model.dart';
import 'dart:convert';

class ProjectTaskProvider extends ChangeNotifier {
  List<Project> _projects = [];
  List<Task> _tasks = [];

  List<Project> get projects => List.unmodifiable(_projects);
  List<Task> get tasks => List.unmodifiable(_tasks);

  ProjectTaskProvider() {
    _loadData(); // Load from SharedPreferences on init
  }

  Future<void> _loadData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final projectJsonList = prefs.getStringList('projects') ?? [];
      final taskJsonList = prefs.getStringList('tasks') ?? [];

      _projects = projectJsonList
          .map((e) {
            try {
              final map = jsonDecode(e) as Map<String, dynamic>;
              return Project.fromJson(map);
            } catch (e) {
              print('Error decoding project: $e');
              return null;
            }
          })
          .whereType<Project>()
          .toList();

      _tasks = taskJsonList
          .map((e) {
            try {
              final map = jsonDecode(e) as Map<String, dynamic>;
              return Task.fromJson(map);
            } catch (e) {
              print('Error decoding task: $e');
              return null;
            }
          })
          .whereType<Task>()
          .toList();

      notifyListeners();
    } catch (e) {
      print('Error loading data: $e');
      // Initialize with empty lists if loading fails
      _projects = [];
      _tasks = [];
    }
  }

  Future<void> _saveProjects() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = _projects.map((e) => jsonEncode(e.toJson())).toList();
      await prefs.setStringList('projects', encoded);
    } catch (e) {
      print('Error saving projects: $e');
    }
  }

  Future<void> _saveTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = _tasks.map((e) => jsonEncode(e.toJson())).toList();
      await prefs.setStringList('tasks', encoded);
    } catch (e) {
      print('Error saving tasks: $e');
    }
  }

  Future<void> addProject(Project project) async {
    _projects.add(project);
    await _saveProjects();
    notifyListeners();
  }

  Future<void> deleteProject(String id) async {
    _projects.removeWhere((p) => p.id == id);
    await _saveProjects();
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    _tasks.add(task);
    await _saveTasks();
    notifyListeners();
  }

  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((t) => t.id == id);
    await _saveTasks();
    notifyListeners();
  }
}
