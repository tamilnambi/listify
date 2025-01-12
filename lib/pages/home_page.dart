import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:listify/services/providers/task_provider.dart';  // Make sure to import the task provider
import 'package:listify/util/enums.dart';

import '../services/providers/login_provider.dart';
import '../util/custom_pageroute.dart';
import '../widgets/custom_alert_dialog.dart';
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

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 200.0).animate(_animationController);
  }

  // Function to show the confirmation dialog
  void _showLogoutConfirmationDialog() {
    CustomConfirmationDialog.show(
      context: context,
      title: 'Confirm Logout',
      message: 'Are you sure you want to log out?',
      onConfirm: () async {
        LoginProvider login = Provider.of<LoginProvider>(context, listen: false);
        await login.logOut().then(
                (value){
              if(login.state == AuthState.success){
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
            }
        );
      },
      onCancel: () {
        // Handle the cancel action
        print('Logout canceled');
      },
    );
  }

  // Function to add a task
  Future<void> _addTask() async {
    if (_taskController.text.isNotEmpty) {
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      await taskProvider.addTask(_taskController.text).then(
              (value) {
            if (taskProvider.state == AuthState.success) {
              BotToast.showText(text: "Task added successfully");
            }
            if (taskProvider.state == AuthState.failed) {
              BotToast.showText(text: taskProvider.message);
            }
          }
      );
      _taskController.clear(); // Clear the textfield after adding the task
      _animationController.reverse(); // Collapse the textfield
      setState(() {
        _isExpanded = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
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
                  icon: Icon(Icons.logout_outlined, size: 30), // Logout icon
                  onPressed: _showLogoutConfirmationDialog, // Show the confirmation dialog
                ),
              ],
            ),
            Spacer(),
            // Circular Container with + icon
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                  if (_isExpanded) {
                    _animationController.forward(); // Expand
                  } else {
                    _animationController.reverse(); // Collapse
                  }
                });
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                width: _isExpanded ? 60 : 70,
                height: _isExpanded ? 60 : 70,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: _isExpanded
                      ? IconButton(
                    icon: Icon(Icons.keyboard_return, color: Colors.white),
                    onPressed: _addTask, // Add task when enter is pressed
                  )
                      : Icon(Icons.add, color: Colors.white),
                ),
              ),
            ),
            // Expanding TextField when clicked
            SizeTransition(
              sizeFactor: _animation,
              axisAlignment: -1.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: TextField(
                  controller: _taskController,
                  decoration: InputDecoration(
                    hintText: 'Enter your task...',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _addTask(), // Add task when enter is pressed
                ),
              ),
            ),
          ],
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
