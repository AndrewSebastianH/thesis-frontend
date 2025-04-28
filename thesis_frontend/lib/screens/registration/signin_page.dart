import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';

class SignIn extends StatelessWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/backgrounds/1.png', fit: BoxFit.cover),

          Container(color: Colors.white.withAlpha(150)),

          Center(
            child:
                isSmallScreen
                    ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [_Logo(), _FormContent()],
                    )
                    : Container(
                      padding: const EdgeInsets.all(32.0),
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: Row(
                        children: const [
                          Expanded(child: _Logo()),
                          Expanded(child: Center(child: _FormContent())),
                        ],
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Welcome to Closer!",
            textAlign: TextAlign.center,
            style:
                isSmallScreen
                    ? Theme.of(context).textTheme.headlineSmall
                    : Theme.of(
                      context,
                    ).textTheme.headlineMedium?.copyWith(color: Colors.black),
          ),
        ),
      ],
    );
  }
}

class _FormContent extends StatefulWidget {
  const _FormContent({Key? key}) : super(key: key);

  @override
  State<_FormContent> createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isFormValid = false;
  bool _rememberMe = false;

  late AuthProvider controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller = Provider.of<AuthProvider>(context, listen: false);
    controller.emailController.addListener(_validateForm);
    controller.passwordController.addListener(_validateForm);
  }

  void _validateForm() {
    final isValid =
        controller.validateEmail(controller.emailController.text) &&
        controller.validatePassword(controller.passwordController.text);

    if (_isFormValid != isValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  @override
  void dispose() {
    controller.emailController.removeListener(_validateForm);
    controller.passwordController.removeListener(_validateForm);
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
            TextFormField(
              controller: controller.emailController,
              validator:
                  (value) =>
                      controller.validateEmail(value)
                          ? null
                          : 'Enter a valid email',
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }

                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
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
            _gap(height: 8),
            CheckboxListTile(
              value: _rememberMe,
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  _rememberMe = value;
                });
              },
              title: const Text('Remember me'),
              controlAffinity: ListTileControlAffinity.leading,
              dense: true,
              activeColor: Colors.orange,
              contentPadding: const EdgeInsets.all(0),
            ),
            _gap(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: CustomButton(
                text: "Login",
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    context.go('/home');
                  }
                },
                isEnabled: _isFormValid,
              ),
            ),
            _gap(),
            TextButton(
              onPressed: () {
                context.push('/forgot-password');
              },
              child: const Text(
                'Forgot password',
                style: TextStyle(color: Colors.deepOrange),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account? "),
                GestureDetector(
                  onTap: () {
                    context.push('/signup', extra: 'Register your account');
                  },
                  child: const Text(
                    'Register',
                    style: TextStyle(color: Colors.deepOrange),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _gap({double height = 16}) => SizedBox(height: height);
}
