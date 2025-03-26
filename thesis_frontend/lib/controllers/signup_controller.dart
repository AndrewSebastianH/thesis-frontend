import 'package:flutter/material.dart';

class SignUpController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  bool validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return false;
    }
    bool emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(value);
    return emailValid;
  }

  bool validatePassword(String? value) {
    return value != null && value.length >= 6;
  }

  bool isPasswordMatching() {
    return passwordController.text == confirmPasswordController.text;
  }

  void togglePasswordVisibility(VoidCallback updateState) {
    isPasswordVisible = !isPasswordVisible;
    updateState();
  }

  void toggleConfirmPasswordVisibility(VoidCallback updateState) {
    isConfirmPasswordVisible = !isConfirmPasswordVisible;
    updateState();
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }
}
