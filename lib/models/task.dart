import 'package:uuid/uuid.dart';

class Task {
  final String id;  // Unique ID
  final String name;
  bool isDone;
  final DateTime createdTime;
  DateTime? completedTime;

  Task({String? id, required this.name, this.isDone = false, required this.createdTime, this.completedTime})
      : id = id ?? const Uuid().v4();  // Assign a unique ID if none is provided

  void toggleDone() {
    isDone = !isDone;
    completedTime = isDone ? DateTime.now() : null;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'isDone': isDone,
      'createdTime': createdTime.toIso8601String(),
      'completedTime': completedTime?.toIso8601String(),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],  // Ensure ID is loaded back
      name: map['name'],
      isDone: map['isDone'],
      createdTime: DateTime.parse(map['createdTime']),
      completedTime: map['completedTime'] != null ? DateTime.parse(map['completedTime']) : null,
    );
  }
  int getNotificationId() {
    return id.hashCode & 0x7FFFFFFF; // Ensures ID is within 32-bit range
  }
}
