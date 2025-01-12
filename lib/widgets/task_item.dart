import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:listify/services/providers/task_provider.dart';

import '../util/enums.dart';

class TaskItem extends StatefulWidget {
  final String taskId;
  final String taskTitle;
  final bool isCompleted;
  final Function(String) onTaskSelected;

  TaskItem({
    required this.taskId,
    required this.taskTitle,
    required this.isCompleted,
    required this.onTaskSelected,
  });

  @override
  _TaskItemState createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> with SingleTickerProviderStateMixin {
  double _scale = 1.0;

  void _triggerScale() {
    setState(() {
      _scale = 1.1; // Increase size slightly
    });

    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        _scale = 1.0; // Return to original size
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    return GestureDetector(
      onTap: () {
        _triggerScale();

        // Notify HomePage of the selected task
        widget.onTaskSelected(widget.taskId);
      },
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: Container(
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
              GestureDetector(
                onTap: () {
                  taskProvider.toggleTaskCompletion(widget.taskId, !widget.isCompleted).then(
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
                    color: widget.isCompleted ? Colors.green : Colors.transparent,
                    borderRadius: BorderRadius.circular(30.0),
                    border: Border.all(
                      color: widget.isCompleted ? Colors.green : Colors.grey,
                      width: 2.0,
                    ),
                  ),
                  child: widget.isCompleted
                      ? Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 18.0,
                  )
                      : null,
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Text(
                  widget.taskTitle,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: widget.isCompleted ? Colors.grey : Colors.black,
                    decoration: widget.isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
