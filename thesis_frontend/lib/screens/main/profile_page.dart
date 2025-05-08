import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:thesis_frontend/providers/auth_provider.dart';
import 'package:thesis_frontend/services/auth_api_service.dart';
import 'package:thesis_frontend/widgets/connect_prompt_card.dart';
import '../../providers/user_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    // userProvider.setMockParentUserNoRelation();
    final user = userProvider.user;
    final relatedUser = userProvider.relatedUser;

    final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

    Widget buildProfileCard(
      String title,
      int asset,
      String name,
      String email,
      String role,
      int exp,
      bool isSelf,
    ) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF9EC),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.brown.withAlpha(20),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Divider(color: Colors.brown.withAlpha(50), thickness: 1),
            const SizedBox(height: 6),
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(
                    "assets/images/avatars/$asset.png",
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        email,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        role,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Container(
                      //   padding: const EdgeInsets.symmetric(
                      //     vertical: 8,
                      //     horizontal: 12,
                      //   ),
                      //   decoration: BoxDecoration(
                      //     color: Colors.orange.shade100,
                      //     borderRadius: BorderRadius.circular(12),
                      //   ),
                      //   child: Text(
                      //     'EXP: $exp',
                      //     style: TextStyle(fontSize: 12),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE8D6),
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextButton(
                onPressed: () {
                  context.push('/profile/insights', extra: isSelf);
                },
                child: const Text(
                  'View Insight',
                  style: TextStyle(
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFF6DC),
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange[50],
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.settings, color: Colors.orange),
                onPressed: () {
                  _showSettingsModal(
                    context,
                    userProvider,
                    authProvider,
                    scaffoldMessengerKey,
                  );
                },
                tooltip: 'Settings',
              ),
            ),
          ),
        ],
      ),
      body:
          user == null
              ? const Center(child: Text('No user data'))
              : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Column(
                  children: [
                    buildProfileCard(
                      'You',
                      user.avatar ?? 1,
                      user.username,
                      user.email,
                      user.role ?? '',
                      user.expPoints,
                      true,
                    ),
                    if (relatedUser != null) ...[
                      buildProfileCard(
                        'Connected User',
                        relatedUser.avatar ?? 1,
                        relatedUser.username,
                        relatedUser.email,
                        relatedUser.role ?? '',
                        relatedUser.expPoints,
                        false,
                      ),
                    ] else
                      const ConnectPromptCard(),
                  ],
                ),
              ),
    );
  }
}

void _showSettingsModal(
  BuildContext context,
  UserProvider userProvider,
  AuthProvider authProvider,
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey,
) {
  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withAlpha(200),
    builder: (dialogContext) {
      return Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(dialogContext).pop(); // closes settings
                        Future.delayed(Duration.zero, () {
                          showDialog(
                            context: context,
                            builder:
                                (_) => EditProfileDialog(
                                  initialAvatarAsset:
                                      "assets/images/avatars/${userProvider.user?.avatar ?? 1}.png",
                                  initialUsername:
                                      userProvider.user?.username ?? '',
                                ),
                          );
                        });
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text("Edit Profile"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 22,
                        ),
                        textStyle: const TextStyle(fontSize: 14),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(dialogContext).pop(); // closes settings
                        Future.delayed(Duration.zero, () {
                          userProvider.clear();
                          authProvider.logout();
                          context.go('/signin');
                        });
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text("Log Out"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 22,
                        ),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class EditProfileDialog extends StatefulWidget {
  final String initialAvatarAsset;
  final String initialUsername;

  const EditProfileDialog({
    super.key,
    required this.initialAvatarAsset,
    required this.initialUsername,
  });

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  late TextEditingController _usernameController;
  late String _selectedAvatar;
  late UserProvider userProvider;

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    _usernameController = TextEditingController(text: widget.initialUsername);
    _selectedAvatar = widget.initialAvatarAsset;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  int _extractAvatarId(String path) {
    final match = RegExp(r'avatars/(\d+)\.png').firstMatch(path);
    if (match != null) {
      return int.parse(match.group(1)!);
    } else {
      throw Exception('Invalid avatar path: $path');
    }
  }

  void _saveChanges() async {
    final updatedUsername = _usernameController.text.trim();
    final updatedAvatar = _selectedAvatar;

    if (updatedUsername.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Username cannot be empty")));
      return;
    }

    final isUsernameChanged = updatedUsername != widget.initialUsername;
    final isAvatarChanged = updatedAvatar != widget.initialAvatarAsset;

    if (!isUsernameChanged && !isAvatarChanged) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("No changes made.")));
      Navigator.of(context).pop();
      return;
    }

    final int updatedAvatarId = _extractAvatarId(updatedAvatar);

    final response = await AuthService.updateProfile(
      newAvatar: updatedAvatarId,
      newUsername: updatedUsername,
    );

    if (response.success) {
      await userProvider.refreshUserInfo();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Updated profile")));
      Navigator.of(context).pop();
    }
  }

  void _selectAvatar() {
    showDialog(
      context: context,
      builder: (context) {
        final List<String> avatars = List.generate(
          4,
          (index) => 'assets/images/avatars/${index + 1}.png',
        );

        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Choose your Avatar',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 20),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children:
                      avatars.map((avatar) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedAvatar = avatar;
                            });
                            Navigator.of(context).pop();
                          },
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage: AssetImage(avatar),
                            backgroundColor: Colors.orange[50],
                          ),
                        );
                      }).toList(),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.deepOrange),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Edit Profile",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _selectAvatar,
              child: CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage(_selectedAvatar),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: "Username",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Save Changes",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
