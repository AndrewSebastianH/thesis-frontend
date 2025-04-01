import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:thesis_frontend/providers/auth_provider.dart';
import 'package:thesis_frontend/screens/signin.dart';
import 'package:thesis_frontend/screens/signup.dart';
import 'package:thesis_frontend/screens/loading.dart';
import 'package:thesis_frontend/screens/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    // const MyApp(),
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    final router = GoRouter(
      initialLocation: '/signin',
      redirect: (context, state) {
        final isLoggedIn = authProvider.isLoggedIn;
        final isAuthRoute = state.path == '/signin' || state.path == '/signup';

        if (isLoggedIn && isAuthRoute) {
          return '/home';
        }

        if (!isLoggedIn && state.path == '/home') {
          return '/signin';
        }

        return null;
      },
      routes: [
        GoRoute(path: '/', builder: (context, state) => const Loading()),
        GoRoute(path: '/signup', builder: (context, state) => const SignUp()),
        GoRoute(path: '/signin', builder: (context, state) => const SignIn()),
        GoRoute(path: '/home', builder: (context, state) => const HomePage()),
      ],
    );

    return MaterialApp.router(
      title: 'Closer',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.deepOrange,
        ),
      ),
      routerConfig: router,
      debugShowCheckedModeBanner: true,
    );
  }
}

// class LandingPage extends StatelessWidget {
//   const LandingPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Closer'),
//         actions: [
//           TextButton(
//             onPressed: () {},
//             child: const Text(
//               'Home',
//               style: TextStyle(color: Colors.deepOrange),
//             ),
//           ),
//           TextButton(
//             onPressed: () {},
//             child: const Text(
//               'About',
//               style: TextStyle(color: Colors.deepOrange),
//             ),
//           ),
//           TextButton(
//             onPressed: () {},
//             child: const Text(
//               'Contact',
//               style: TextStyle(color: Colors.deepOrange),
//             ),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             // Hero Section
//             Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 children: [
//                   const Text(
//                     'Welcome to Swiss German Not Scam University',
//                     style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 20),
//                   Lottie.network(
//                     'https://assets2.lottiefiles.com/packages/lf20_tutvdkg0.json',
//                     height: 250,
//                   ),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: () {},
//                     child: const Text('Get Started'),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class FeatureCard extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   const FeatureCard({required this.icon, required this.title, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       elevation: 5,
//       child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           children: [
//             Icon(icon, size: 50, color: Colors.deepOrange),
//             const SizedBox(height: 10),
//             Text(
//               title,
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
