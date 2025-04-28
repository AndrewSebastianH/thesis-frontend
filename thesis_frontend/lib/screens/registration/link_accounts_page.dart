import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:thesis_frontend/providers/user_provider.dart';
import '../../widgets/custom_button.dart';

class LinkAccountPage extends StatefulWidget {
  const LinkAccountPage({Key? key}) : super(key: key);

  @override
  State<LinkAccountPage> createState() => _LinkAccountPageState();
}

class _LinkAccountPageState extends State<LinkAccountPage> {
  String _enteredCode = '';
  late UserProvider userProvider;
  Map<String, String>? foundUser;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userProvider = Provider.of<UserProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Enter Connection Code",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),

              // OTP / PIN Code Input
              OtpTextField(
                numberOfFields: 6,
                borderColor: const Color(0xFFFF7F50),
                focusedBorderColor: const Color(0xFFFF7F50),
                showFieldAsBox: false,
                borderWidth: 4.0,
                onCodeChanged: (code) {
                  setState(() {
                    _enteredCode = code;
                  });
                },
                onSubmit: (code) {
                  setState(() {
                    _enteredCode = code;
                  });
                  _handleSubmit();
                },
              ),

              const SizedBox(height: 24),
              const Text(
                "Enter the code shared by your parent/\nchild to connect your accounts in Closer.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              if (foundUser != null) ...[
                const Text(
                  "User found!",
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                _buildProfileCard(),
              ] else if (_enteredCode.length == 6 && foundUser == null) ...[
                const Text(
                  "No user found with this code.",
                  style: TextStyle(color: Colors.red),
                ),
              ],

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: CustomButton(
                  text: "Connect Account",
                  onPressed:
                      foundUser != null
                          ? () => {
                            userProvider.clear(),
                            userProvider.setMockParentUser(),

                            context.go("/home"),
                          }
                          : null,

                  isEnabled: foundUser != null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    final name = foundUser!['name']!;
    final role = foundUser!['role']!;
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

  void _handleSubmit() {
    // TEMPORARY MOCK - replace this with API call later
    final result = {'name': 'John Doe', 'role': 'child'};

    setState(() {
      foundUser = result;
    });
  }
}
