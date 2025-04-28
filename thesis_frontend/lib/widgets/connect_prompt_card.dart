import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ConnectPromptCard extends StatelessWidget {
  final String? text;
  final String? assetPath;

  const ConnectPromptCard({super.key, this.text, this.assetPath});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () {
          context.push('/view-connection-code');
        },
        splashColor: Colors.orange.withAlpha(30),
        highlightColor: Colors.orange.withAlpha(20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          margin: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.orange.shade100),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withAlpha(10),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 120,
                height: 120,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withAlpha(20),
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Image.asset(
                  assetPath ?? 'assets/images/parent_boy_bear_heart.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                text ?? "Connect with your relative now",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                "Tap to view your connection code",
                style: TextStyle(fontSize: 13, color: Colors.black45),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
