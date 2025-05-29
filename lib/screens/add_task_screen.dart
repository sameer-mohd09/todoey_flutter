import 'package:flutter/material.dart';

// Primary Colors
const Color primaryColor = Color(0xFF4A90E2); // Soft Blue (AppBar, FAB)
const Color secondaryColor = Color(0xFFF7F9FC); // Very Light Blue/White Blend (Background)

// Text Colors
const Color textPrimary = Color(0xFF2C3E50); // Dark Blue-Gray (Main Text)
const Color textSecondary = Color(0xFF7F8C8D); // Muted Gray (Subtitles, Time)

// Accent Colors
const Color accentColor = Color(0xFFFF6B6B); // Soft Red (Buttons, Selected Checkboxes, Highlights)

class AddTaskScreen extends StatefulWidget {
  final Function addTaskCallback;

  AddTaskScreen(this.addTaskCallback);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  String newTaskTitle = '';
  DateTime? reminderTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff757575),
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Add Task',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30.0,
                color: primaryColor,
              ),
            ),
            TextField(
              autofocus: true,
              textAlign: TextAlign.center,
              onChanged: (newText) {
                newTaskTitle = newText;
              },
            ),
            SizedBox(
              height: 10.0,
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: primaryColor,
              ),
              onPressed: () async {
                reminderTime = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                );
                if (reminderTime != null) {
                  TimeOfDay? time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time != null) {
                    reminderTime = DateTime(
                      reminderTime!.year,
                      reminderTime!.month,
                      reminderTime!.day,
                      time.hour,
                      time.minute,
                    );
                  }
                }
              },
              child: Text(
                'Set Reminder',
                style: TextStyle(
                  color: secondaryColor,
                  fontSize: 18.0,
                ),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: primaryColor,
              ),
              onPressed: () {
                if (newTaskTitle.isNotEmpty && reminderTime != null) {
                  widget.addTaskCallback(newTaskTitle, reminderTime!);
                  Navigator.pop(context);
                }
              },
              child: Text(
                'Add',
                style: TextStyle(
                  color: secondaryColor,
                  fontSize: 18.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
