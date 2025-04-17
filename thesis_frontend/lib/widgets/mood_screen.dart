import 'package:flutter/material.dart';

class MoodScreen extends StatelessWidget {
  final Function(String) onMoodSelected;

  const MoodScreen({super.key, required this.onMoodSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "How are you feeling today?",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMoodButton("😊", "happy"),
                  _buildMoodButton("😐", "neutral"),
                  _buildMoodButton("😔", "sad"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoodButton(String emoji, String label) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => onMoodSelected(label),
          child: CircleAvatar(
            radius: 30,
            child: Text(emoji, style: const TextStyle(fontSize: 28)),
          ),
        ),
        const SizedBox(height: 8),
        Text(label[0].toUpperCase() + label.substring(1)),
      ],
    );
  }
}
