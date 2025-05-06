import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:thesis_frontend/providers/user_provider.dart';
import 'package:thesis_frontend/services/auth_api_service.dart';
import 'package:thesis_frontend/widgets/custom_button.dart';

class LinkAccountPage extends StatefulWidget {
  const LinkAccountPage({super.key});

  @override
  State<LinkAccountPage> createState() => _LinkAccountPageState();
}

class _LinkAccountPageState extends State<LinkAccountPage> {
  final _codeController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _codeOwner;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _verifyCode() async {
    final code = _codeController.text.trim();
    if (code.length != 6) {
      setState(() => _errorMessage = "Code must be 6 characters");
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await AuthService.findUserByConnectionCode(
      connectionCode: code,
    );

    if (!mounted) return;

    if (result.success) {
      setState(() {
        _codeOwner = result.data['codeOwner'];
        _isLoading = false;
      });
    } else {
      setState(() {
        _errorMessage = result.message;
        _isLoading = false;
      });
    }
  }

  Future<void> _linkAccount() async {
    final code = _codeController.text.trim();
    setState(() => _isLoading = true);

    final result = await AuthService.linkAccounts(code: code);

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (result.success) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.refreshUserInfo();
      context.go('/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.message ?? 'Failed to link account')),
      );
    }
  }

  Widget _buildCodeInput() {
    return TextField(
      controller: _codeController,
      maxLength: 6,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 32,
        letterSpacing: 12,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        hintText: '------',
        counterText: '',
        errorText: _errorMessage,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 2),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.orange, width: 2),
        ),
      ),
      keyboardType: TextInputType.number,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Link Account')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Center(
          child:
              _isLoading
                  ? const CircularProgressIndicator()
                  : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Enter 6-digit connection code',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildCodeInput(),
                      const SizedBox(height: 30),
                      if (_codeOwner != null) ...[
                        const Text("This code belongs to:"),
                        const SizedBox(height: 6),
                        Text(
                          _codeOwner!['username'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(height: 20),
                        CustomButton(
                          text: "Confirm & Connect",
                          onPressed: _linkAccount,
                        ),
                      ] else ...[
                        CustomButton(text: "Verify", onPressed: _verifyCode),
                      ],
                    ],
                  ),
        ),
      ),
    );
  }
}
