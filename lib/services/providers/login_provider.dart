import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:listify/util/shared_preferences_service.dart';

import '../../util/app_logger.dart';
import '../../util/enums.dart';

class LoginProvider with ChangeNotifier{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthState _state = AuthState.loading;
  String _message = '';

  AuthState get state => _state;
  String get message => _message;

  // Sign Up with Email/Password
  Future<User?> signUp(String email, String password) async {
    try {
      _state = AuthState.loading;
      _message = '';
      notifyListeners();
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _state = AuthState.success;
      _message = 'Sign up successful!';
      notifyListeners();
      return userCredential.user;
    } catch (e) {
      _state = AuthState.failed;
      _message = e.toString();
      notifyListeners();
      AppLogger().logError('Error signing up: $e');
      return null;
    }
  }

  // Log In with Email/Password
  Future<User?> logIn(String email, String password) async {
    try {
      _state = AuthState.loading;
      _message = '';
      notifyListeners();
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _state = AuthState.success;
      SharedPreferencesService.prefs!.setBool(SharedPreferencesService.isLoggedIn, true);
      SharedPreferencesService.prefs!.setString(SharedPreferencesService.userId, userCredential.user!.uid);
      AppLogger().logInfo('User ID: ${userCredential.user!.uid}');
      _message = 'Login successful!';
      notifyListeners();
      return userCredential.user;
    } catch (e) {
      _state = AuthState.failed;
      _message = e.toString();
      notifyListeners();
      AppLogger().logError('Error logging in: $e');
      return null;
    }
  }

  // Log Out
  Future<void> logOut() async {
    try {
      _state = AuthState.loading;
      _message = '';
      notifyListeners();
      await _auth.signOut();
      _state = AuthState.success;
      SharedPreferencesService().clearAllValues();
      _message = 'Logged out successfully!';
      notifyListeners();
    } catch (e) {
      _state = AuthState.failed;
      _message = e.toString();
      notifyListeners();
      AppLogger().logError('Error logging out: $e');
    }
  }
}