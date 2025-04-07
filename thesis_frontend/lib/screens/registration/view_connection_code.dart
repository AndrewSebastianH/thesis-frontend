import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thesis_frontend/widgets/custom_button.dart';

class ConnectionCodeScreen extends StatelessWidget {
  final String code;

  const ConnectionCodeScreen({Key? key, required this.code}) : super(key: key);

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
                "This is your\nconnection code",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Text(
                code,
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF7F50), // Coral
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Give this code to your parent or child so they can link their account to yours in Closer!",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              const Text(
                "Did your parent/child give you a code?\nTap below to enter it and connect your accounts!",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: CustomButton(
                  text: "Enter Connection Code",
                  onPressed: () {
                    context.push("/link-account", extra: "Link your account");
                  },
                  isOutlined: true,
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: CustomButton(
                  text: "Continue",
                  onPressed: () {
                    // Go to next screen (maybe homepage?)
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
