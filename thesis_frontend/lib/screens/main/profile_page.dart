import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:thesis_frontend/widgets/connect_prompt_card.dart';
import '../../providers/user_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    // userProvider.setMockParentUserNoRelation();
    final user = userProvider.user;
    final relatedUser = userProvider.relatedUser;

    Widget buildProfileCard(
      String title,
      String asset,
      String name,
      String email,
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
                CircleAvatar(radius: 40, backgroundImage: AssetImage(asset)),
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
                icon: const Icon(Icons.edit, color: Colors.orange),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder:
                        (context) => EditProfileDialog(
                          initialAvatarAsset: userProvider.userAvatarAsset,
                          initialUsername: user?.username ?? '',
                        ),
                  );
                },
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
                      userProvider.userAvatarAsset,
                      user.username,
                      user.email,
                      user.expPoints,
                      true,
                    ),
                    if (relatedUser != null) ...[
                      buildProfileCard(
                        'Connected User',
                        userProvider.relatedUserAvatarAsset,
                        relatedUser.username,
                        relatedUser.email,
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

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.initialUsername);
    _selectedAvatar = widget.initialAvatarAsset;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    final updatedUsername = _usernameController.text.trim();
    final updatedAvatar = _selectedAvatar;

    if (updatedUsername.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Username cannot be empty")));
      return;
    }

    // TODO: Send updatedUsername and updatedAvatar to backend
    print("New Username: $updatedUsername");
    print("New Avatar: $updatedAvatar");

    Navigator.of(context).pop(); // Close the dialog
  }

  void _selectAvatar() {
    // For now, just a simple toggle (mock). Later you can open a proper avatar picker.
    setState(() {
      _selectedAvatar =
          _selectedAvatar == 'assets/images/avatars/1.png'
              ? 'assets/images/bear_girl.png'
              : 'assets/images/bear_boy.png';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
