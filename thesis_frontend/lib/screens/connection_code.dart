import 'package:flutter/material.dart';

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

              /// Outlined Button (Full Width)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Color(0xFFFF7F50),
                    side: const BorderSide(color: Color(0xFFFF7F50)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    // Show enter code input or navigate
                  },
                  child: const Text(
                    "Enter Connection Code",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              /// Elevated Button (Full Width)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF7F50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    // Go to next screen (maybe homepage?)
                  },
                  child: const Text(
                    "Continue",
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
