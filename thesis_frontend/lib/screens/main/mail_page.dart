import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:thesis_frontend/models/mail_mdl.dart';
import 'package:thesis_frontend/providers/user_provider.dart';
import 'package:thesis_frontend/services/mail_api_service.dart';

class MailInboxPage extends StatefulWidget {
  const MailInboxPage({super.key});

  @override
  State<MailInboxPage> createState() => _MailInboxPageState();
}

class _MailInboxPageState extends State<MailInboxPage> {
  bool showInbox = true;
  List<MailModel> inboxMails = [];
  List<MailModel> sentMails = [];
  bool isLoading = true;

  @override
  void initState() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.setMockParentUserNoRelation();
    super.initState();

    loadMails();
  }

  Future<void> loadMails() async {
    setState(() => isLoading = true);

    if (showInbox) {
      inboxMails = await MailApiService.fetchReceivedMails();
    } else {
      sentMails = await MailApiService.fetchSentMails();
    }

    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mails = showInbox ? inboxMails : sentMails;
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final hasConnection = userProvider.hasConnection;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.orange[50],
          appBar: AppBar(
            backgroundColor: Colors.orange[50],
            elevation: 0,
            title: const Text(
              'Mail',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: Stack(
                    children: [
                      AnimatedAlign(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        alignment:
                            showInbox
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                        child: Container(
                          width:
                              (MediaQuery.of(context).size.width - 32) /
                              2, // half of the container
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Material(
                              color:
                                  Colors
                                      .transparent, // make sure the area is tappable
                              child: InkWell(
                                borderRadius: BorderRadius.circular(30),
                                onTap: () {
                                  if (!showInbox) {
                                    setState(() {
                                      showInbox = true;
                                    });
                                    loadMails();
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 48, // Make sure it fills vertically
                                  child: Text(
                                    'Inbox',
                                    style: TextStyle(
                                      color:
                                          showInbox
                                              ? Colors.white
                                              : Colors.orange,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(30),
                                onTap: () {
                                  if (showInbox) {
                                    setState(() {
                                      showInbox = false;
                                    });
                                    loadMails();
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 48,
                                  child: Text(
                                    'Sent',
                                    style: TextStyle(
                                      color:
                                          !showInbox
                                              ? Colors.white
                                              : Colors.orange,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          body: Stack(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child:
                    isLoading
                        ? ListView.builder(
                          key: const ValueKey('loading'),
                          itemCount: 5,
                          itemBuilder:
                              (context, index) => const SkeletonMailCard(),
                        )
                        : mails.isEmpty
                        ? const Center(
                          key: ValueKey('empty'),
                          child: Text("No mails found."),
                        )
                        : ListView.builder(
                          key: ValueKey(showInbox),
                          itemCount: mails.length,
                          itemBuilder: (context, index) {
                            final mail = mails[index];
                            return Card(
                              color:
                                  mail.isRead
                                      ? Colors.brown.shade100
                                      : !showInbox && !mail.isRead
                                      ? Colors.lightGreen.shade100
                                      : Colors.orange[100],
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              child: ListTile(
                                onTap: () => _openMail(mail),
                                title: Text(
                                  mail.message,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  DateFormat.yMMMd().format(mail.createdAt),
                                ),
                                trailing:
                                    showInbox && !mail.isRead
                                        ? const Icon(
                                          Icons.mark_email_unread,
                                          color: Colors.red,
                                        )
                                        : !showInbox && !mail.isRead
                                        ? const Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                        )
                                        : const Icon(
                                          Icons.mark_email_read,
                                          color: Colors.black,
                                        ),
                              ),
                            );
                          },
                        ),
              ),
            ],
          ),
        ),
        // Blocking Layer if NOT connected
        if (!hasConnection)
          Positioned.fill(
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Container(
                  color: Colors.black.withAlpha(30),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 12, right: 12),
                          child: const Text(
                            "Connect with a relative to use the Mail feature.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            context.push('/view-connection-code');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            child: Text("Connect Now"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _openMail(MailModel mail) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentUser = userProvider.user;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Mail',
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 300,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
                border: Border.all(
                  color: showInbox ? Colors.orange : Colors.lightGreen.shade100,
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.close_rounded,
                          size: 20,
                          color: Colors.grey,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        splashRadius: 20,
                      ),
                    ],
                  ),

                  Image.asset(
                    showInbox
                        ? 'assets/images/bear_mail.png'
                        : 'assets/images/bear_sent.png',
                    width: 70,
                    height: 70,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    showInbox ? "You've got a mail!" : "Mail sent!",

                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: showInbox ? Colors.orange : Colors.lightGreen,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  // Add this white "paper" box!
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            showInbox
                                ? Colors.orange.withAlpha(30)
                                : Colors.lightGreen.shade100,
                      ),
                    ),
                    child: Text(
                      mail.message,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );

    if (!mail.isRead && mail.senderId != currentUser?.id) {
      MailApiService.readMail(mail.id);
      setState(() {
        mail.isRead = true;
      });
    }
  }
}

class SkeletonMailCard extends StatelessWidget {
  const SkeletonMailCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: ListTile(
          title: Container(
            height: 16,
            width: double.infinity,
            color: Colors.amber[100],
          ),
          subtitle: Container(height: 12, width: 100, color: Colors.amber[100]),
          trailing: Icon(Icons.email_outlined, color: Colors.amber[100]),
        ),
      ),
    );
  }
}
