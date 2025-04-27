import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      body: Center(
        child:
            isSmallScreen
                ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [_FormContent()],
                )
                : Container(
                  padding: const EdgeInsets.all(32.0),
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Row(
                    children: const [
                      Expanded(child: Center(child: _FormContent())),
                    ],
                  ),
                ),
      ),
    );
  }
}

class _FormContent extends StatefulWidget {
  const _FormContent({Key? key}) : super(key: key);

  @override
  State<_FormContent> createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
  final _formKey = GlobalKey<FormState>();
  bool _isFormValid = false;
  late AuthProvider controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller = Provider.of<AuthProvider>(context, listen: false);
    controller.usernameController.addListener(_validateForm);
    controller.emailController.addListener(_validateForm);
    controller.passwordController.addListener(_validateForm);
    controller.confirmPasswordController.addListener(_validateForm);
  }

  void _validateForm() {
    final isValid =
        controller.validateUsername(controller.usernameController.text) &&
        controller.validateEmail(controller.emailController.text) &&
        controller.validatePassword(controller.passwordController.text) &&
        controller.isPasswordMatching();

    if (_isFormValid != isValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  @override
  void dispose() {
    controller.usernameController.removeListener(_validateForm);
    controller.emailController.removeListener(_validateForm);
    controller.passwordController.removeListener(_validateForm);
    controller.confirmPasswordController.removeListener(_validateForm);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Let's get you started",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            _gap(height: 40),
            TextFormField(
              controller: controller.usernameController,
              validator:
                  (value) =>
                      controller.validateUsername(value)
                          ? null
                          : 'Please enter a valid name',

              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'Enter your name',
                prefixIcon: Icon(Icons.person_outline_rounded),
                border: OutlineInputBorder(),
              ),
            ),
            _gap(),
            TextFormField(
              controller: controller.emailController,
              validator:
                  (value) =>
                      controller.validateEmail(value)
                          ? null
                          : 'Please enter a valid email',

              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            _gap(),
            TextFormField(
              controller: controller.passwordController,
              validator:
                  (value) =>
                      controller.validatePassword(value)
                          ? null
                          : 'Password must be at least 6 characters',
              obscureText: !controller.isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      controller.isPasswordVisible =
                          !controller.isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            _gap(),
            TextFormField(
              controller: controller.confirmPasswordController,
              validator: (value) {
                if (!controller.isPasswordMatching()) {
                  return 'Passwords do not match';
                }
                return null;
              },
              obscureText: !controller.isConfirmPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                hintText: 'Enter your password again',
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isConfirmPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      controller.isConfirmPasswordVisible =
                          !controller.isConfirmPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            _gap(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: CustomButton(
                text: "Signup",
                onPressed: () {
                  // if (_formKey.currentState?.validate() ?? false) {

                  context.go('/choose-role');

                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   const SnackBar(
                  //     content: Text('Signup failed. Please try again.'),
                  //   ),
                  // );

                  // final result = await controller.signup();
                  // if (result) {
                  //   final connectionCode = result['connectionCode'];
                  // }
                  // }
                },
                isEnabled: _isFormValid,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gap({double height = 16}) => SizedBox(height: height);
}
