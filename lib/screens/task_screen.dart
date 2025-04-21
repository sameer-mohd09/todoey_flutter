import 'package:flutter/material.dart';
import 'package:todoey_flutter/widgets/task_list.dart';
import 'package:todoey_flutter/screens/add_task_screen.dart';
import 'package:todoey_flutter/models/task.dart';
import 'package:provider/provider.dart';
import 'package:todoey_flutter/models/task_data.dart';

// Primary Colors
const Color primaryColor = Color(0xFF4A90E2); // Soft Blue (AppBar, FAB)
const Color secondaryColor =
    Color(0xFFF7F9FC); // Very Light Blue/White Blend (Background)

// Text Colors
const Color textPrimary = Color(0xFF2C3E50); // Dark Blue-Gray (Main Text)
const Color textSecondary = Color(0xFF7F8C8D); // Muted Gray (Subtitles, Time)

// Accent Colors
const Color accentColor =
    Color(0xFFFF6B6B); // Soft Red (Buttons, Selected Checkboxes, Highlights)

// Task Card Background (Optional)
const Color taskCardColor =
    Color(0xFFFFFFFF); // White with slight shadow for elevation

class TasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Task> tasks = Provider.of<TaskData>(context).tasks;

    return Scaffold(
      backgroundColor: primaryColor,
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        backgroundColor: primaryColor,
        child: Icon(
          Icons.add,
          color: secondaryColor,
        ),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: AddTaskScreen((newTaskTitle, reminderTime) {
                  Provider.of<TaskData>(context, listen: false)
                      .addTask(newTaskTitle, reminderTime);
                  Navigator.pop(context);
                }),
              ),
            ),
          );
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(
              top: 60.0,
              left: 30.0,
              right: 30.0,
              bottom: 30.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImageIcon(
                  AssetImage('images/to-do-list.png'),
                  color: textPrimary,
                  size: 40.0,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'QuickList',
                  style: TextStyle(
                    color: textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 50.0,
                  ),
                ),
                Text(
                  tasks.length == 1 || tasks.length == 0
                      ? '${tasks.length} Task'
                      : '${tasks.length} Tasks',
                  style: TextStyle(
                    color: textPrimary,
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Consumer<TaskData>(
                  builder: (context, taskData, child) {
                    double progress = taskData.progress;
                    return Row(
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: secondaryColor,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(textPrimary),
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          '${(progress * 100).toStringAsFixed(1)}%',
                          style: TextStyle(
                            color: textPrimary,
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: TasksList(),
            ),
          )
        ],
      ),
    );
  }
}
