//   Future<void> signup(String username, String email, String password) async {
//     final success = await AuthService.signup(username, email, password);
//     if (!success) throw Exception("Signup failed");
//   }

//   Future<void> logout() async {
//     _isLoggedIn = false;
//     _token = null;
//     _user = null;

//     await _secureStorage.delete(key: 'auth_token');
//     await _secureStorage.delete(key: 'user_data');

//     emailController.clear();
//     passwordController.clear();
//     confirmPasswordController.clear();

//     notifyListeners();
//   }

//   Future<void> tryAutoLogin() async {
//     final token = await _secureStorage.read(key: 'auth_token');
//     final userData = await _secureStorage.read(key: 'user_data');

//     if (token != null && userData != null && !JwtDecoder.isExpired(token)) {
//       _token = token;
//       _user = UserModel.fromJson(jsonDecode(userData));
//       _isLoggedIn = true;
//       notifyListeners();
//     }
//   }

//   @override
//   void dispose() {
//     emailController.dispose();
//     passwordController.dispose();
//     confirmPasswordController.dispose();
//     super.dispose();
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
  final TextEditingController usernameController = TextEditingController();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  // Username Validation
  bool validateUsername(String? value) {
    return value != null;
  }

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
