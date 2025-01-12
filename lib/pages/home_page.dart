import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:listify/services/providers/login_provider.dart';
import 'package:listify/util/enums.dart';
import 'package:listify/widgets/custom_alert_dialog.dart';
import 'package:provider/provider.dart';

import '../util/custom_pageroute.dart';
import 'login_page.dart'; // Import the custom dialog

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
          ],
        ),
      ),
    );
  }
}
