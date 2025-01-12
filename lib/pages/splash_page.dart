import 'package:flutter/material.dart';


import '../util/shared_preferences_service.dart';
import 'home_page.dart';
import 'login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool isLoggedIn = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkStatus();
  }

  void checkStatus() {
    Future.delayed(const Duration(milliseconds: 500), () async {
      isLoggedIn = SharedPreferencesService.prefs!
              .getBool(SharedPreferencesService.isLoggedIn) ??
          false;
      if (isLoggedIn) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
              (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
              (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Hero(
              tag: "splashLogo",
              child: Image.asset("assets/logo.png", width: 150),
            ),
          ),
        ],
      ),
    );
  }
}
