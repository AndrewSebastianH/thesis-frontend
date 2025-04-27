import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/custom_button.dart';

class LinkAccountPage extends StatelessWidget {
  const LinkAccountPage({Key? key}) : super(key: key);

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
                onSubmit: (code) {
                  print("Entered code: $code");
                  final result = {'name': 'John Doe', 'role': 'parent'};

                  // Handle logic
                  if (result != null) {
                    final name = result['name'];
                    final role = result['role'];

                    showDialog(
                      context: context,
                      builder:
                          (BuildContext dialogContext) => AlertDialog(
                            title: const Text("User Found"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (role == "parent")
                                  Image.asset(
                                    "assets/images/avatar/3.png",
                                    width: 100,
                                    height: 100,
                                  )
                                else
                                  Image.asset(
                                    "assets/images/avatar/1.png",
                                    width: 100,
                                    height: 100,
                                  ),
                                const SizedBox(height: 16),

                                Text(
                                  "$name",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "${role?[0].toUpperCase()}${role?.substring(1)}",
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: const Color(0xFFFF7F50),
                                ),
                                onPressed:
                                    () => Navigator.of(dialogContext).pop(),
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: const Color(0xFFFF7F50),
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () => context.go('/home'),
                                child: const Text("Connect"),
                              ),
                            ],
                          ),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder:
                          (BuildContext alertContext) => AlertDialog(
                            title: Text("User not found"),
                            content: Text(
                              "The code is invalid or expired. Please try again",
                            ),
                            actions: [
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: const Color(0xFFFF7F50),
                                ),
                                onPressed:
                                    () => Navigator.of(alertContext).pop(),
                                child: const Text("OK"),
                              ),
                            ],
                          ),
                    );
                  }
                },
              ),

              const SizedBox(height: 24),
              const Text(
                "Enter the code shared by your parent/\nchild to connect your accounts in Closer.",
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // Your custom button here
              SizedBox(
                width: double.infinity,
                height: 50,
                child: CustomButton(
                  text: "Connect Account",
                  onPressed: () {
                    // Handle continue action
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
