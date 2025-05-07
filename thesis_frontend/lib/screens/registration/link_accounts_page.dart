import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
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
  String _enteredCode = '';
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _codeOwner;
  late UserProvider userProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userProvider = Provider.of<UserProvider>(context, listen: false);
  }

  Future<void> _verifyCode() async {
    if (_enteredCode.length != 6) {
      setState(() => _errorMessage = "Code must be 6 characters.");
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _codeOwner = null;
    });

    final result = await AuthService.findUserByConnectionCode(
      connectionCode: _enteredCode,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      if (result.success) {
        _codeOwner = result.data['codeOwner'];
      } else {
        _errorMessage = result.message ?? "User not found";
      }
    });
  }

  Future<void> _linkAccount() async {
    setState(() => _isLoading = true);

    final result = await AuthService.linkAccounts(code: _enteredCode);

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (result.success) {
      await userProvider.refreshUserInfo();
      print('User JSON: ${userProvider.user}');
      print('Related User JSON: ${userProvider.relatedUser}');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account linked successfully')),
      );

      context.go("/home");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.message ?? 'Failed to link account')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child:
              _isLoading
                  ? const CircularProgressIndicator()
                  : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Enter Connection Code",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 40),
                      OtpTextField(
                        numberOfFields: 6,
                        borderColor: const Color(0xFFFF7F50),
                        focusedBorderColor: const Color(0xFFFF7F50),
                        showFieldAsBox: false,
                        borderWidth: 4.0,
                        onCodeChanged: (code) {
                          setState(() {
                            _enteredCode = code;
                            _errorMessage = null;
                          });
                        },
                        onSubmit: (code) {
                          setState(() => _enteredCode = code);
                          _verifyCode();
                        },
                      ),
                      if (_errorMessage != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                      const SizedBox(height: 24),
                      const Text(
                        "Enter the code shared by your parent/\nchild to connect your accounts in Closer.",
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      if (_codeOwner != null) ...[
                        const Text(
                          "User found!",
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildProfileCard(_codeOwner!),
                      ],
                      const SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: CustomButton(
                          text:
                              _codeOwner != null ? "Connect Account" : "Verify",
                          onPressed:
                              _codeOwner != null ? _linkAccount : _verifyCode,
                          isEnabled: _enteredCode.length == 6,
                        ),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(Map<String, dynamic> user) {
    final name = user['username'] ?? 'Unknown';
    final role = user['role'] ?? '';
    final isParent = role == 'parent';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9EC),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withAlpha(30),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage(
              isParent
                  ? 'assets/images/avatars/3.png'
                  : 'assets/images/avatars/1.png',
            ),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            role[0].toUpperCase() + role.substring(1),
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
