import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:thesis_frontend/screens/signin.dart';
import 'package:thesis_frontend/screens/signup.dart';
import 'package:thesis_frontend/screens/loading.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      routes: {
        '/': (context) => const Loading(),
        '/signup': (context) => const SignUp(),
        '/signin': (context) => const SignIn(),
        '/home': (context) => const LandingPage(),
      },
    );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Closer'),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Home',
              style: TextStyle(color: Colors.deepOrange),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              'About',
              style: TextStyle(color: Colors.deepOrange),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              'Contact',
              style: TextStyle(color: Colors.deepOrange),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Hero Section
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Text(
                    'Welcome to Swiss German Not Scam University',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Lottie.network(
                    'https://assets2.lottiefiles.com/packages/lf20_tutvdkg0.json',
                    height: 250,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Get Started'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  const FeatureCard({required this.icon, required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Icon(icon, size: 50, color: Colors.deepOrange),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
