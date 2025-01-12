import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:listify/services/providers/task_provider.dart';  // Make sure to import the task provider
import 'package:listify/util/enums.dart';

import '../services/providers/login_provider.dart';
import '../util/custom_pageroute.dart';
import '../widgets/custom_alert_dialog.dart';
import '../widgets/task_item.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  TextEditingController _taskController = TextEditingController();

  bool _isExpanded = false;
  String? _selectedTaskId;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 200.0).animate(_animationController);
    getTasks();
  }

  // Function to hide the text field and show the + icon
  void _closeTextField() {
    setState(() {
      _isExpanded = false;
      _taskController.clear();  // Clear the text when closing the text field
    });
  }

  Future<void> getTasks() async {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    await taskProvider.fetchTasks().then(
          (value) {
        if (taskProvider.state == AuthState.success) {
          BotToast.showText(text: "Tasks fetched successfully");
        }
        if (taskProvider.state == AuthState.failed) {
          BotToast.showText(text: taskProvider.message);
        }
      },
    );
  }

  void _showLogoutConfirmationDialog() {
    CustomConfirmationDialog.show(
      context: context,
      title: 'Confirm Logout',
      message: 'Are you sure you want to log out?',
      onConfirm: () async {
        LoginProvider login = Provider.of<LoginProvider>(context, listen: false);
        await login.logOut().then(
              (value) {
            if (login.state == AuthState.success) {
              BotToast.showText(text: "Logout successful");
              Navigator.pushAndRemoveUntil(
                context,
                CustomPageRoute(
                  page: LoginPage(),
                  transitionType: TransitionType.slideLeft,
                ),
                    (route) => false,
              );
            }
          },
        );
      },
      onCancel: () {
        // Handle the cancel action
      },
    );
  }

  void _showDeleteConfirmationDialog() {
    CustomConfirmationDialog.show(
      context: context,
      title: 'Confirm Delete',
      message: 'Are you sure you want to delete the task?',
      onConfirm: () async {
        TaskProvider taskProvider = Provider.of<TaskProvider>(context, listen: false);
        await taskProvider.deleteTask(_selectedTaskId!).then(
              (value) {
            if (taskProvider.state == AuthState.success) {
              BotToast.showText(text: "Task deleted successfully");
            }
            if (taskProvider.state == AuthState.failed) {
              BotToast.showText(text: taskProvider.message);
            }
          },
        );
        setState(() {
          _selectedTaskId = null;
        });
      },
      onCancel: () {
        // Handle the cancel action
      },
    );
  }

  Future<void> _addTask() async {
    if (_taskController.text.isNotEmpty) {
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      if (_selectedTaskId != null) {
        await taskProvider.updateTaskText(
            _selectedTaskId!, _taskController.text).then(
              (value) {
            if (taskProvider.state == AuthState.success) {
              BotToast.showText(text: "Task updated successfully");
            }
            if (taskProvider.state == AuthState.failed) {
              BotToast.showText(text: taskProvider.message);
            }
          },
        );
      } else {
        await taskProvider.addTask(_taskController.text).then(
              (value) {
            if (taskProvider.state == AuthState.success) {
              BotToast.showText(text: "Task added successfully");
            }
            if (taskProvider.state == AuthState.failed) {
              BotToast.showText(text: taskProvider.message);
            }
          },
        );
      }
    }
    _closeTextField();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          if (_selectedTaskId != null) {
            setState(() {
              _selectedTaskId = null;
            });
          } else {
            _closeTextField(); // Close text field when tapping outside
          }
        },
        child: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Hero(
                    tag: "splashLogo",
                    child: Image.asset("assets/logo.png", width: size.height * 0.1),
                  ),
                  IconButton(
                    icon: Icon(Icons.logout_outlined, size: 30),
                    onPressed: _showLogoutConfirmationDialog,
                  ),
                ],
              ),
              Expanded(
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Consumer<TaskProvider>(
                        builder: (context, taskProvider, child) {
                          if (taskProvider.state == AuthState.loading) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (taskProvider.state == AuthState.failed) {
                            return Center(child: Text(taskProvider.message));
                          }
                          return ListView.builder(
                            itemCount: taskProvider.tasks.length,
                            itemBuilder: (context, index) {
                              final task = taskProvider.tasks[index];
                              final isSelected = _selectedTaskId == task['id'];

                              return Stack(
                                children: [
                                  TaskItem(
                                    taskId: task['id'],
                                    taskTitle: task['task'],
                                    isCompleted: task['completed'],
                                    onTaskSelected: (selectedTaskId) {
                                      setState(() {
                                        _selectedTaskId = selectedTaskId == _selectedTaskId ? null : selectedTaskId;
                                      });
                                    },
                                  ),
                                  if (isSelected)
                                    Positioned(
                                      top: 0,
                                      right: 10,
                                      child: Row(
                                        children: [
                                          FloatingActionButton(
                                            mini: true,
                                            backgroundColor: Colors.yellow,
                                            onPressed: () {
                                              // Load the task into the textfield for editing
                                              setState(() {
                                                _taskController.text = task['task'];
                                              });
                                              setState(() {
                                                _isExpanded = true;
                                              });
                                            },
                                            child: Icon(Icons.edit, color: Colors.black),
                                          ),
                                          const SizedBox(width: 8),
                                          FloatingActionButton(
                                            mini: true,
                                            backgroundColor: Colors.red,
                                            onPressed: _showDeleteConfirmationDialog,
                                            child: Icon(Icons.delete, color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                    if (!_isExpanded) Positioned.fill(
                      child: Consumer<TaskProvider>(
                        builder: (context, taskProvider, child) {
                          return AnimatedAlign(
                            duration: Duration(milliseconds: 300),
                            alignment: taskProvider.tasks.isEmpty
                                ? Alignment.center
                                : Alignment.bottomCenter,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isExpanded = true;
                                });
                              },
                              child: Container(
                                width: 56,
                                height: 56,
                                margin: EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Icon(Icons.add, color: Colors.white, size: 30),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: _isExpanded ? 80 : 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                  child: GestureDetector(
                    onTap: () {}, // Prevent tap from bubbling up
                    child: TextField(
                      controller: _taskController,
                      decoration: InputDecoration(
                        hintText: 'Enter your task...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        suffixIcon: IconButton(
                          icon: Icon(Icons.send),
                          onPressed: _addTask,
                        ),
                      ),
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _addTask(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _taskController.dispose();
    super.dispose();
  }
}
