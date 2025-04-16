import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:thesis_frontend/providers/auth_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// Screens
import 'package:thesis_frontend/screens/registration/link_accounts_page.dart';
import 'package:thesis_frontend/screens/registration/view_connection_code.dart';
import 'package:thesis_frontend/screens/registration/signin.dart';
import 'package:thesis_frontend/screens/registration/signup.dart';
import 'package:thesis_frontend/screens/registration/loading.dart';
import 'package:thesis_frontend/screens/registration/choose_role.dart';
import 'package:thesis_frontend/screens/main/home_page.dart';
// Widgets
import 'package:thesis_frontend/widgets/navigation_shell.dart';
import 'package:thesis_frontend/widgets/registration_shell.dart';
import 'package:thesis_frontend/widgets/transitions/slide_transition.dart';

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
      initialLocation: '/home',
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
        GoRoute(
          path: '/see-connectioncode',
          builder: (context, state) {
            final code = state.extra as String;
            return ConnectionCodeScreen(code: code);
          },
        ),
        GoRoute(
          path: '/choose-role',
          builder: (context, state) {
            final code = state.extra as String;
            return ChooseRoleScreen(connectionCode: code);
          },
        ),
        ShellRoute(
          builder: (context, state, child) {
            final title = state.extra as String? ?? '';
            return RegistrationShell(title: title, child: child);
          },
          routes: [
            GoRoute(
              path: '/signup',
              pageBuilder:
                  (context, state) => slideTransition(child: const SignUp()),
            ),

            GoRoute(
              path: '/link-account',
              pageBuilder:
                  (context, state) =>
                      slideTransition(child: const LinkAccountPage()),
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
              path: '/calendar',
              builder: (context, state) => const Loading(),
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
