import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
// import '../../models/user_mdl.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), centerTitle: true),
      body:
          user == null
              ? const Center(child: Text('No user data'))
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage(userProvider.userAvatarAsset),
                    ),
                    const SizedBox(height: 16),

                    // Username
                    Text(
                      user.username,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Email
                    Text(user.email, style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 24),

                    // EXP Points
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.star, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          'EXP: ${user.expPoints}',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // Logout Button
                    ElevatedButton(
                      onPressed: () {
                        // Add your logout logic here
                        userProvider.clear();
                        Navigator.of(
                          context,
                        ).pushNamedAndRemoveUntil('/login', (route) => false);
                      },
                      child: const Text('Log Out'),
                    ),
                  ],
                ),
              ),
    );
  }
}
