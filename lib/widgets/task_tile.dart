import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskTile extends StatelessWidget {
  final bool isChecked;
  final String taskTitle;
  final DateTime createdTime;
  final DateTime? completedTime;
  final ValueChanged<bool?> checkboxCallback;
  final Function deleteTaskCallback;
  TaskTile(
      {required this.isChecked,
      required this.taskTitle,
      required this.createdTime,
      this.completedTime,
      required this.checkboxCallback,
      required this.deleteTaskCallback});

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');
    return ListTile(
      onLongPress: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Delete Task'),
              content: Text('Do you want to delete this task?'),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Delete'),
                  onPressed: () {
                    deleteTaskCallback();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
      title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          taskTitle,
          style: TextStyle(
              decoration: isChecked ? TextDecoration.lineThrough : null),
        ),
        Text(
          'Created: ${formatter.format(createdTime)}',
          style: TextStyle(
            fontSize: 10.0,
            color: Colors.grey,
          ),
        ),
        if (completedTime != null)
          Text(
            'Completed: ${formatter.format(completedTime!)}',
            style: TextStyle(
              fontSize: 10.0,
              color: Colors.grey,
            ),
          ),
      ]),
      trailing: Checkbox(
        activeColor: Colors.lightBlueAccent,
        value: isChecked,
        onChanged: checkboxCallback,
      ),
    );
  }
}



// (bool? checkboxState) {
//             setState(() {
//               isChecked = checkboxState!;
//             });
//           }