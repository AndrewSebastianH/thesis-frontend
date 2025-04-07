import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:thesis_frontend/providers/auth_provider.dart';
import 'package:thesis_frontend/screens/registration/link_accounts_page.dart';
import 'package:thesis_frontend/screens/registration/view_connection_code.dart';
import 'package:thesis_frontend/screens/registration/signin.dart';
import 'package:thesis_frontend/screens/registration/signup.dart';
import 'package:thesis_frontend/screens/registration/loading.dart';
import 'package:thesis_frontend/screens/home_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:thesis_frontend/widgets/navigation_shell.dart';
import 'package:thesis_frontend/widgets/registration_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  runApp(
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
        GoRoute(path: '/signin', builder: (context, state) => const SignIn()),

        ShellRoute(
          builder: (context, state, child) {
            final title = state.extra as String? ?? '';
            return RegistrationShell(title: title, child: child);
          },
          routes: [
            GoRoute(
              path: '/signup',
              builder: (context, state) => const SignUp(),
            ),
            GoRoute(
              path: '/see-connectioncode',
              builder: (context, state) {
                final code = state.extra as String;
                return ConnectionCodeScreen(code: code);
              },
            ),
            GoRoute(
              path: '/link-account',
              builder: (context, state) => const LinkAccountPage(),
            ),
          ],
        ),
        ShellRoute(
          builder: (context, state, child) {
            return NavigationShell(child: child);
          },
          routes: [
            GoRoute(path: '/', builder: (context, state) => const Loading()),
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomePage(),
            ),
            GoRoute(
              path: '/profile',
              builder: (context, state) => const Loading(),
            ),
            GoRoute(
              path: '/mail',
              builder: (context, state) => const Loading(),
            ),
          ],
        ),
      ],
    );

    return MaterialApp.router(
      title: 'Closer',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
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
