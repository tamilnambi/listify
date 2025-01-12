import 'package:flutter/material.dart';
import 'package:listify/pages/login_page.dart';

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
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
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
                  text: 'Create Account',
                  onPressed: () {},
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
        ));
  }
}
