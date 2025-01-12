import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:listify/pages/login_page.dart';
import 'package:listify/services/providers/login_provider.dart';
import 'package:provider/provider.dart';

import '../util/app_colors.dart';
import '../util/app_textstyles.dart';
import '../util/custom_pageroute.dart';
import '../util/enums.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  // Function to validate email and password
  Future<void> signup() async {
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
    await login.signUp(email, password).then(
        (value){
          if(login.state == AuthState.success){
            BotToast.showText(text: "Sign up successful");
            Navigator.pushAndRemoveUntil(
              context,
              CustomPageRoute(
                page: LoginPage(),
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
                  'Join us now!',
                  style: AppTextStyles.heading(context),
                ),
                const SizedBox(height: 10),
                Text(
                  'Sign up to start your journey.',
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
                  text: 'Create Account',
                  onPressed: signup, // Validate and handle signup here
                  color: AppColors.customPink,
                ),
                const SizedBox(height: 30),
                Text(
                  'Already have an Account?',
                  style: AppTextStyles.subheading(context),
                ),
                const SizedBox(height: 10),
                CustomButton(
                  text: 'Log In',
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      CustomPageRoute(
                        page: LoginPage(),
                        transitionType: TransitionType
                            .slideLeft, // Choose your animation type
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
