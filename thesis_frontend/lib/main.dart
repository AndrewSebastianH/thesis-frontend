import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:thesis_frontend/screens/main/insights_page.dart';
import 'package:thesis_frontend/screens/main/mail_page.dart';
// Providers
import './providers/auth_provider.dart';
import './providers/user_provider.dart';
// Screens
import 'screens/registration/choose_role_page.dart';
import 'screens/registration/signin_page.dart';
import 'screens/registration/signup_page.dart';
import './screens/registration/link_accounts_page.dart';
import 'screens/registration/view_connection_code_page.dart';

import './screens/main/home_page.dart';
import './screens/main/calendar_page.dart';
import './screens/main/create_task_page.dart';
import './screens/main/profile_page.dart';
import './screens/main/compose_mail.dart';

import 'widgets/loading.dart';

// Widgets
import './widgets/navigation_shell.dart';
import './widgets/registration_shell.dart';
import './widgets/transitions/slide_transition.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],

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
          path: '/view-connection-code',
          builder: (context, state) {
            return ConnectionCodeScreen();
          },
        ),
        GoRoute(
          path: '/choose-role',
          builder: (context, state) {
            return ChooseRoleScreen();
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

        GoRoute(
          path: '/create-task',
          builder: (context, state) => const CreateTaskPage(),
        ),
        GoRoute(
          path: '/compose-mail',
          builder: (context, state) => const ComposeMailPage(),
        ),
        GoRoute(
          path: '/profile/insights',
          builder: (context, state) {
            final showSelf =
                state.extra as bool? ?? true; //  default true if nothing passed
            return InsightsPage(showSelf: showSelf);
          },
        ),

        ShellRoute(
          builder: (context, state, child) {
            return NavigationShell(state: state, child: child);
          },
          routes: [
            GoRoute(path: '/', builder: (context, state) => const Loading()),
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomePage(),
            ),
            GoRoute(
              path: '/calendar',
              builder: (context, state) => const EmotionCalendarPage(),
            ),
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfilePage(),
            ),
            GoRoute(
              path: '/mail',
              builder: (context, state) => const MailInboxPage(),
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
        inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
      routerConfig: router,
      debugShowCheckedModeBanner: true,
    );
  }
}
