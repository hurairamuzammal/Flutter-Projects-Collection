import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_tracker/model/model.dart';

class TimeEntryProvider with ChangeNotifier {
  List<TimeEntry> _entries = [];

  List<TimeEntry> get entries => List.unmodifiable(_entries);

  TimeEntryProvider() {
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedData = prefs.getString('timeEntries');

      if (storedData != null) {
        final List decoded = jsonDecode(storedData);
        _entries = decoded
            .map((e) {
              try {
                return TimeEntry(
                  id: e['id'] as String,
                  projectId: e['projectId'] as String,
                  taskId: e['taskId'] as String,
                  totalTime: (e['totalTime'] as num).toDouble(),
                  date: DateTime.parse(e['date'] as String),
                  notes: e['notes'] as String,
                );
              } catch (e) {
                print('Error parsing time entry: $e');
                return null;
              }
            })
            .whereType<TimeEntry>()
            .toList();

        // Sort entries by date, most recent first
        _entries.sort((a, b) => b.date.compareTo(a.date));
        notifyListeners();
      }
    } catch (e) {
      print('Error loading time entries: $e');
      _entries = [];
    }
  }

  Future<void> _saveEntries() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(
        _entries
            .map(
              (e) => {
                'id': e.id,
                'projectId': e.projectId,
                'taskId': e.taskId,
                'totalTime': e.totalTime,
                'date': e.date.toIso8601String(),
                'notes': e.notes,
              },
            )
            .toList(),
      );
      await prefs.setString('timeEntries', encoded);
    } catch (e) {
      print('Error saving time entries: $e');
    }
  }

  Future<void> addTimeEntry(TimeEntry entry) async {
    _entries.add(entry);
    // Sort entries by date, most recent first
    _entries.sort((a, b) => b.date.compareTo(a.date));
    await _saveEntries();
    notifyListeners();
  }

  Future<void> deleteTimeEntry(String id) async {
    _entries.removeWhere((entry) => entry.id == id);
    await _saveEntries();
    notifyListeners();
  }

  Future<void> updateTimeEntry(TimeEntry updatedEntry) async {
    final index = _entries.indexWhere((e) => e.id == updatedEntry.id);
    if (index != -1) {
      _entries[index] = updatedEntry;
      // Sort entries by date, most recent first
      _entries.sort((a, b) => b.date.compareTo(a.date));
      await _saveEntries();
      notifyListeners();
    }
  }
}
