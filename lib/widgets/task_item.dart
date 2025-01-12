import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:listify/services/providers/task_provider.dart';

import '../util/enums.dart';

class TaskItem extends StatelessWidget {
  final String taskId;
  final String taskTitle;
  final bool isCompleted;

  TaskItem({
    required this.taskId,
    required this.taskTitle,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Checkbox-like circle with GestureDetector only on the circle
          GestureDetector(
            onTap: () {
              // Toggle task completion status
              taskProvider.toggleTaskCompletion(taskId, !isCompleted).then(
                    (value) {
                  if (taskProvider.state == AuthState.success) {
                    BotToast.showText(text: "Task updated successfully");
                  }
                  if (taskProvider.state == AuthState.failed) {
                    BotToast.showText(text: taskProvider.message);
                  }
                },
              );
            },
            child: Container(
              width: 30.0,
              height: 30.0,
              decoration: BoxDecoration(
                color: isCompleted ? Colors.green : Colors.transparent,
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(
                  color: isCompleted ? Colors.green : Colors.grey,
                  width: 2.0,
                ),
              ),
              child: isCompleted
                  ? Icon(
                Icons.check,
                color: Colors.white,
                size: 18.0,
              )
                  : null,
            ),
          ),
          const SizedBox(width: 16.0),
          // Task title
          Expanded(
            child: Text(
              taskTitle,
              style: TextStyle(
                fontSize: 16.0,
                color: isCompleted ? Colors.grey : Colors.black,
                decoration: isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
