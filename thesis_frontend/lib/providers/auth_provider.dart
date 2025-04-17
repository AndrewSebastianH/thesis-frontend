// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../services/auth_service.dart';

// class AuthProvider extends ChangeNotifier {
//   bool _isLoggedIn = false;
//   String? _token;

//   bool get isLoggedIn => _isLoggedIn;
//   String? get token => _token;

//   Future<void> login(String email, String password) async {
//     final token = await AuthService.login(email, password);

//     if (token != null) {
//       _token = token;
//       _isLoggedIn = true;

//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('auth_token', _token!);

//       notifyListeners();
//     } else {
//       throw Exception('Invalid login credentials');
//     }
//   }

//   Future<void> signup(String username, String email, String password) async {
//     final success = await AuthService.signup(username, email, password);
//     if (!success) throw Exception("Signup failed");
//   }

//   Future<void> logout() async {
//     _token = null;
//     _isLoggedIn = false;

//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('auth_token');

//     notifyListeners();
//   }

//   Future<void> checkLoginStatus() async {
//     final prefs = await SharedPreferences.getInstance();
//     _token = prefs.getString('auth_token');

//     _isLoggedIn = _token != null;
//     notifyListeners();
//   }
// }

import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  //  Email Validation
  bool validateEmail(String? value) {
    if (value == null || value.isEmpty) return false;
    return RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    ).hasMatch(value);
  }

  //  Password Validation
  bool validatePassword(String? value) {
    return value != null && value.length >= 6;
  }

  //  Confirm Password Validation
  bool isPasswordMatching() {
    return passwordController.text == confirmPasswordController.text;
  }

  //  Toggle Visibility
  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible = !isConfirmPasswordVisible;
    notifyListeners();
  }

  //  Login
  void login() {
    if (validateEmail(emailController.text) &&
        validatePassword(passwordController.text)) {
      _isLoggedIn = true;
      notifyListeners();
    }
  }

  //  Signup
  void signup() {
    if (validateEmail(emailController.text) &&
        validatePassword(passwordController.text) &&
        isPasswordMatching()) {
      _isLoggedIn = true;
      notifyListeners();
    }
  }

  void logout() {
    _isLoggedIn = false;
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
