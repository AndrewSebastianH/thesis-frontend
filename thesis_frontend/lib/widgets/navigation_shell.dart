import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationShell extends StatefulWidget {
  final Widget child;
  const NavigationShell({super.key, required this.child});

  @override
  _NavigationShellState createState() => _NavigationShellState();
}

class _NavigationShellState extends State<NavigationShell> {
  int _selectedIndex = 0;

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/calendar');
        break;
      case 2:
        context.go('/mail');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      extendBody: true, // Makes nav bar float over background
      floatingActionButton:
          _selectedIndex == 0
              ? Padding(
                padding: const EdgeInsets.only(top: 22),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.orange,
                  ),
                  padding: const EdgeInsets.all(4), // outline thickness
                  child: FloatingActionButton(
                    mini: true,
                    backgroundColor: Colors.white,
                    shape: const CircleBorder(),
                    onPressed: () => context.push('/create-task'),
                    child: const Icon(Icons.add, color: Colors.orange),
                  ),
                ),
              )
              : _selectedIndex == 2
              ? Padding(
                padding: const EdgeInsets.only(top: 22),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.orange,
                  ),
                  padding: const EdgeInsets.all(4),
                  child: FloatingActionButton(
                    mini: true,
                    backgroundColor: Colors.white,
                    shape: const CircleBorder(),
                    onPressed: () => _showMailOptions(context),
                    child: const Icon(Icons.edit, color: Colors.orange),
                  ),
                ),
              )
              : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onDestinationSelected,
            backgroundColor: Colors.amber[800],
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
            type: BottomNavigationBarType.fixed,
            elevation: 12,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month),
                label: 'Calendar',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.mail_rounded),
                label: 'Mail',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Mail related modals
  void _showMailOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Mail Options",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text("Compose Mail"),
                onTap: () {
                  Navigator.pop(context);
                  context.push('/compose-mail');
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text("Delete All Received Mails"),
                onTap: () {
                  _showConfirmDeleteDialog(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showConfirmDeleteDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Delete All Received Mails',
      barrierColor: Colors.black.withAlpha(40), // soft background dim
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Delete All Received Mails?",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Are you sure you want to delete all received mails?\nThis will also delete the mail from the sender.",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          // TODO: Actually trigger deleteAllMails API here
                          print("All received mails deleted.");
                        },
                        child: const Text("Delete All"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    );
  }
}
