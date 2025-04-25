import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:thesis_frontend/models/mail_mdl.dart';
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

    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        title: Text(
          showInbox ? 'Inbox' : 'Sent Mails',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                showInbox = !showInbox;
              });
              loadMails();
            },
            child: Text(showInbox ? 'Sent' : 'Inbox'),
          ),
        ],
        backgroundColor: Colors.orange[50],
      ),
      body:
          isLoading
              ? ListView.builder(
                itemCount: 5, // 5 fake skeleton mails
                itemBuilder: (context, index) => const SkeletonMailCard(),
              )
              : mails.isEmpty
              ? const Center(child: Text("No mails found."))
              : ListView.builder(
                itemCount: mails.length,
                itemBuilder: (context, index) {
                  final mail = mails[index];
                  return Card(
                    color:
                        mail.isRead
                            ? Colors.brown.shade100
                            : Colors.orange[100],
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    child: ListTile(
                      title: Text(mail.message),
                      subtitle: Text(DateFormat.yMMMd().format(mail.createdAt)),
                      trailing:
                          showInbox && !mail.isRead
                              ? const Icon(
                                Icons.mark_email_unread,
                                color: Colors.red,
                              )
                              : const Icon(
                                Icons.mark_email_read,
                                color: Colors.black,
                              ),
                    ),
                  );
                },
              ),
    );
  }
}

// Fake skeleton mail card for loading state
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
