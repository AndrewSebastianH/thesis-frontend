// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:thesis_frontend/config/apiConfig.dart';

// class AuthProvider extends ChangeNotifier {
//   bool _isLoggedIn = false;
//   String? _token;
//   final String baseUrl = ApiConfig.baseUrl;

//   bool get isLoggedIn => _isLoggedIn;
//   String? get token => _token;

//   Future<void> login(String email, String password) async {
//     try {
//       final response = await http.post(
//         Uri.parse(
//           '/auth/login',
//         ),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'email': email, 'password': password}),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         _token = data['token'];
//         _isLoggedIn = true;

//         // Store token locally for persistence
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString('auth_token', _token!);

//         notifyListeners();
//       } else {
//         throw Exception('Failed to login');
//       }
//     } catch (e) {
//       print('Login error: $e');
//       throw Exception('Network error');
//     }
//   }

//   Future<void> logout() async {
//     _token = null;
//     _isLoggedIn = false;

//     // Remove token from storage
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('auth_token');

//     notifyListeners();
//   }

//   Future<void> checkLoginStatus() async {
//     final prefs = await SharedPreferences.getInstance();
//     _token = prefs.getString('auth_token');

//     if (_token != null) {
//       _isLoggedIn = true;
//     }

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
