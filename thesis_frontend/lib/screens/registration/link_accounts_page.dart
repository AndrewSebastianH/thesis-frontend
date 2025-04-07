import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

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
                  // Handle logic
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
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF7F50),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    // Validate & connect account
                  },
                  child: const Text(
                    "Connect Account",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
