import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:thesis_frontend/providers/user_provider.dart';
import '../../services/auth_api_service.dart';
import '../../widgets/custom_button.dart';
import '../../extensions/response_result_extension.dart';

class ConnectionCodeScreen extends StatefulWidget {
  const ConnectionCodeScreen({Key? key}) : super(key: key);

  @override
  State<ConnectionCodeScreen> createState() => _ConnectionCodeScreenState();
}

class _ConnectionCodeScreenState extends State<ConnectionCodeScreen> {
  String? connectionCode;
  bool isLoading = true;
  late UserProvider userProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userProvider = Provider.of<UserProvider>(context, listen: false);
  }

  @override
  void initState() {
    super.initState();
    fetchConnectionCode();
  }

  Future<void> fetchConnectionCode() async {
    try {
      final data =
          (await AuthService.getConnectionCode())
              .successOrThrow<Map<String, dynamic>>();
      if (mounted) {
        setState(() {
          connectionCode = data['code'];
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child:
              isLoading
                  ? const CircularProgressIndicator()
                  : Column(
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
                        connectionCode ?? "ERROR",
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF7F50),
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

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: CustomButton(
                          text: "Enter Connection Code",
                          onPressed: () {
                            context.push("/link-account");
                          },
                          isOutlined: true,
                        ),
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: CustomButton(
                          text: "Connect later",
                          onPressed: () {
                            userProvider.clear();
                            userProvider.setMockParentUserNoRelation();
                            context.go("/home");
                          },
                        ),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }
}
