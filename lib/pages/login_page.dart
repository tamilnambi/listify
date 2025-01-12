import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:listify/pages/home_page.dart';
import 'package:listify/pages/signup_page.dart';
import 'package:listify/services/providers/login_provider.dart';
import 'package:listify/util/app_textstyles.dart';
import 'package:listify/widgets/custom_button.dart';
import 'package:listify/widgets/custom_textfield.dart';
import 'package:provider/provider.dart';

import '../util/app_colors.dart';
import '../util/custom_pageroute.dart';
import '../util/enums.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  // Function to validate email and password
  Future<void> login() async {
    FocusScope.of(context).unfocus(); // Close the keyboard
    String email = emailController.text;
    String password = passwordController.text;

    // Email validation
    if (email.isEmpty) {
      showErrorMessage("Please enter your email");
      return;
    }

    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(email)) {
      showErrorMessage("Enter a valid email address");
      return;
    }

    // Password validation
    if (password.isEmpty) {
      showErrorMessage("Please enter your password");
      return;
    }

    if (password.length < 6) {
      showErrorMessage("Password must be at least 6 characters long");
      return;
    }

    LoginProvider login = Provider.of<LoginProvider>(context, listen: false);
    await login.logIn(email, password).then(
            (value){
          if(login.state == AuthState.success){
            BotToast.showText(text: "Login successful");
            Navigator.pushAndRemoveUntil(
              context,
              CustomPageRoute(
                page: HomePage(),
                transitionType: TransitionType.slideLeft,
              ),
                  (route) => false,
            );
          }
          if(login.state == AuthState.failed){
            showErrorMessage(login.message);
          }
        }
    );
  }

  // Function to show error messages
  void showErrorMessage(String message) {
    //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message),backgroundColor: Colors.red,duration: Duration(seconds: 3),),);
    BotToast.showText(text: message);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true, // Ensures screen resizes when keyboard opens
      body: SingleChildScrollView( // Allows screen content to be scrollable
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
          child: Center(
            child: Column(
              children: [
                SizedBox(height: size.height * 0.15),
                Hero(
                  tag: "splashLogo",
                  child:
                  Image.asset("assets/logo.png", width: size.width * 0.5),
                ),
                const SizedBox(height: 10),
                Text(
                  'Welcome',
                  style: AppTextStyles.heading(context),
                ),
                const SizedBox(height: 10),
                Text(
                  'Stay productive, one task at a time.',
                  style: AppTextStyles.subheading(context),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                    controller: emailController,
                    hintText: 'email',
                    leadingIcon: Icons.email),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: passwordController,
                  hintText: 'password',
                  leadingIcon: Icons.lock,
                  isPassword: true,
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: 'Log In',
                  onPressed: login, // Validate and handle login here
                  color: AppColors.customPink,
                ),
                const SizedBox(height: 30),
                Text(
                  'Don\'t have an account? Sign Up',
                  style: AppTextStyles.subheading(context),
                ),
                const SizedBox(height: 10),
                CustomButton(
                  text: 'Sign Up',
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      CustomPageRoute(
                        page: SignupPage(),
                        transitionType: TransitionType.slideRight,
                      ),
                          (route) => false,
                    );
                  },
                  color: AppColors.customGreen,
                  width: size.width * 0.3,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
