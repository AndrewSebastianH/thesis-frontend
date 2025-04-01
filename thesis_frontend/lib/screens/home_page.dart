import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:thesis_frontend/providers/auth_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            final controller = Provider.of<AuthProvider>(
              context,
              listen: false,
            );
            controller.logout();
            context.go('/signin');
          },
          child: const Text('Logout'), // You can keep 'const' here
        ),
      ),
    );
  }
}
