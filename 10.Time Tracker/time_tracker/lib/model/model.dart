class Project {
  final String id;
  final String name;

  Project({required this.id, required this.name});

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(id: json['id'] as String, name: json['name'] as String);
  }
}

class Task {
  final String id;
  final String name;

  Task({required this.id, required this.name});

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(id: json['id'] as String, name: json['name'] as String);
  }
}

class TimeEntry {
  final String id;
  final String projectId;
  final String taskId;
  final double totalTime;
  final DateTime date;
  final String notes;

  TimeEntry({
    required this.id,
    required this.projectId,
    required this.taskId,
    required this.totalTime,
    required this.date,
    required this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'projectId': projectId,
      'taskId': taskId,
      'totalTime': totalTime,
      'date': date.toIso8601String(),
      'notes': notes,
    };
  }

  factory TimeEntry.fromJson(Map<String, dynamic> json) {
    return TimeEntry(
      id: json['id'] as String,
      projectId: json['projectId'] as String,
      taskId: json['taskId'] as String,
      totalTime: (json['totalTime'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      notes: json['notes'] as String,
    );
  }
}


