import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegistrationShell extends StatelessWidget {
  final Widget child;
  final String title;

  const RegistrationShell({
    super.key,
    required this.child,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
          tooltip: 'Back',
        ),
        title: Text(title),
        centerTitle: true,
      ),
      body: child,
    );
  }
}
