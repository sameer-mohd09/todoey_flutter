import 'dart:collection';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoey_flutter/models/task.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class TaskData extends ChangeNotifier {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  TaskData(this.flutterLocalNotificationsPlugin);

  List<Task> _tasks = [
    Task(name: 'Add Task', createdTime: DateTime.now()),
    Task(name: 'Long press to delete', createdTime: DateTime.now()),
    Task(name: 'Check the box to mark as done', createdTime: DateTime.now()),
  ];

  UnmodifiableListView<Task> get tasks {
    return UnmodifiableListView(_tasks);
  }

  int get taskCount => _tasks.length;

  void addTask(String newTaskTitle, DateTime reminderTime) {
    final task = Task(name: newTaskTitle, createdTime: DateTime.now());
    _tasks.add(task);
    saveTasks();
    scheduleNotification(task, reminderTime);
    notifyListeners();
  }

  void updateTask(Task task, {DateTime? newReminderTime}) {
    task.toggleDone();
    saveTasks();

    if (task.isDone) {
      cancelNotification(task);
    } else if (newReminderTime != null) {
      scheduleNotification(task, newReminderTime);
    }

    notifyListeners();
  }

  void deleteTask(Task task) {
    _tasks.remove(task);
    saveTasks();
    cancelNotification(task);
    notifyListeners();
  }

  double get progress {
    if (_tasks.isEmpty) return 0.0;
    int completedTasks = _tasks.where((task) => task.isDone).length;
    return completedTasks / _tasks.length;
  }

  Future<void> saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> taskList = _tasks.map((task) => json.encode(task.toMap())).toList();
    prefs.setStringList('tasks', taskList);
  }

  Future<void> loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? taskList = prefs.getStringList('tasks');
    if (taskList != null) {
      _tasks = taskList.map((task) => Task.fromMap(json.decode(task))).toList();
      notifyListeners();
    }
  }

  Future<void> scheduleNotification(Task task, DateTime reminderTime) async {
    if (reminderTime.isBefore(DateTime.now())) {
      return; // Prevent scheduling past notifications
    }

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    int notificationId = task.getNotificationId() % 2147483647; // Ensure safe 32-bit ID

    await flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId,
      'Task Reminder',
      'Don\'t forget to complete your task: ${task.name}',
      tz.TZDateTime.from(reminderTime, tz.local),
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelNotification(Task task) async {
    int notificationId = task.getNotificationId() % 2147483647;
    await flutterLocalNotificationsPlugin.cancel(notificationId);
  }
}
