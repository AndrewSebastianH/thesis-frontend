import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:thesis_frontend/extensions/response_result_extension.dart';
import 'package:thesis_frontend/services/auth_api_service.dart';
import 'package:thesis_frontend/models/response_result_mdl.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;
  final _storage = const FlutterSecureStorage();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  // Username Validation
  bool validateUsername(String? value) {
    return value != null &&
        value.trim().isNotEmpty &&
        RegExp(r"^[A-Za-z\s]+$").hasMatch(value.trim());
  }

  // Email Validation
  bool validateEmail(String? value) {
    if (value == null || value.isEmpty) return false;
    return RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    ).hasMatch(value);
  }

  // Password Validation
  bool validatePassword(String? value) {
    return value != null && value.length >= 6;
  }

  // Confirm Password Validation
  bool isPasswordMatching() {
    return passwordController.text == confirmPasswordController.text;
  }

  // Toggle Visibility
  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible = !isConfirmPasswordVisible;
    notifyListeners();
  }

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  Future<void> clearToken() async {
    await _storage.delete(key: 'auth_token');
  }

  Future<ResponseResult> signup() async {
    final response = await AuthService.signup(
      username: usernameController.text,
      email: emailController.text,
      password: passwordController.text,
    );
    return response;
  }

  Future<ResponseResult> login() async {
    return await AuthService.login(
      email: emailController.text,
      password: passwordController.text,
    );
  }

  // Mock methods
  void loginMock() {
    if (validateEmail(emailController.text) &&
        validatePassword(passwordController.text)) {
      _isLoggedIn = true;
      notifyListeners();
    }
  }

  void signupMock() {
    if (validateEmail(emailController.text) &&
        validatePassword(passwordController.text) &&
        isPasswordMatching()) {
      _isLoggedIn = true;
      notifyListeners();
    }
  }

  void logout() async {
    _isLoggedIn = false;
    await clearToken();
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    usernameController.dispose();
    super.dispose();
  }
}
