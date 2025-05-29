import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:todoey_flutter/models/task_data.dart';
import 'package:todoey_flutter/screens/task_screen.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize notifications & permissions
  await _initializeNotifications();
  await _requestPermissions();

  // Initialize the time zone database
  tz.initializeTimeZones();

  // Check and request "Exact Alarm" permission (Android 12+)
  await _checkAndRequestExactAlarmPermission();

  // Load saved tasks
  TaskData taskData = TaskData(flutterLocalNotificationsPlugin);
  await taskData.loadTasks();

  runApp(MyApp(taskData: taskData));
}

// 🔔 Request Permissions (Android, iOS, macOS)
Future<void> _requestPermissions() async {
  if (Platform.isAndroid) {
    if (Platform.operatingSystemVersion.contains('13')) {
      await Permission.notification.request();
    }
  }

  // Request iOS/macOS permissions
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(alert: true, badge: true, sound: true);

  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(alert: true, badge: true, sound: true);
}

// 🔔 Initialize Notifications
Future<void> _initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: DarwinInitializationSettings(),
    macOS: DarwinInitializationSettings(),
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

// 🔔 Check & Request "Exact Alarm" Permission (Android 12+)
Future<void> _checkAndRequestExactAlarmPermission() async {
  if (Platform.isAndroid && Platform.operatingSystemVersion.contains('12')) {
    if (await Permission.scheduleExactAlarm.isDenied) {
      await Permission.scheduleExactAlarm.request();
    }
  }
}

// 🌟 Flutter App Widget
class MyApp extends StatelessWidget {
  final TaskData taskData;

  const MyApp({super.key, required this.taskData});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => taskData,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: TasksScreen(),
      ),
    );
  }
}
