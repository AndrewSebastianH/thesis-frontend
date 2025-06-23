import 'package:flutter/material.dart';
import 'package:thesis_frontend/services/mail_api_service.dart';
import 'package:thesis_frontend/widgets/custom_button.dart';

class ComposeMailPage extends StatefulWidget {
  const ComposeMailPage({super.key});

  @override
  State<ComposeMailPage> createState() => _ComposeMailPageState();
}

class _ComposeMailPageState extends State<ComposeMailPage> {
  final _messageController = TextEditingController();
  final _subjectController = TextEditingController();

  bool _isFormValid = false;
  static const int _maxCharacters = 300;

  final Map<String, Map<String, String>> _templateMap = {
    "🙏 Apology": {
      "subject": "I'm sorry",
      "message":
          "Hi, I just wanted to sincerely apologize for what happened. It wasn’t my intention and I hope we can talk about it soon.",
    },
    "💖 Appreciation": {
      "subject": "Thank you so much!",
      "message":
          "Just wanted to let you know how much I appreciate everything you’ve done. It really means a lot to me. ❤️",
    },
    "🕊️ Forgiveness": {
      "subject": "Let’s make peace",
      "message":
          "I’ve been thinking about things, and I hope we can put the past behind us. I really value our relationship.",
    },

    "🙋 Request": {
      "subject": "Can I ask for your help?",
      "message":
          "Hi, I would like to ask if you could help me with something. Let me know if it’s possible. Thank you!",
    },
    "🌟 Encouragement": {
      "subject": "You’re doing great!",
      "message":
          "Hey! Just a little message to tell you that you’re doing amazing and I’m really proud of you. Keep going!",
    },
    "🎁 Gratitude": {
      "subject": "Feeling Grateful",
      "message":
          "I’ve been thinking lately how grateful I am to have you in my life. Thank you for everything you do.",
    },
    "✨ Motivation": {
      "subject": "Keep going!",
      "message":
          "I know things might feel tough sometimes, but you’ve got this! I believe in you — one step at a time. 💪",
    },
    "🧸 Comfort": {
      "subject": "Here for you",
      "message":
          "If you’re having a hard day, I’m always here if you want to talk or need someone to listen. 🤗",
    },
    "🎉 Congratulations": {
      "subject": "Congrats to you!",
      "message":
          "Wow, congratulations on your achievement! I’m so happy for you and proud of everything you’ve done. 🎉",
    },
  };

  @override
  void initState() {
    super.initState();
    _messageController.addListener(_validateForm);
  }

  void _validateForm() {
    setState(() {
      _isFormValid =
          _messageController.text.trim().isNotEmpty &&
          _messageController.text.length <= _maxCharacters;
    });
  }

  void _submitMail() async {
    final message = _messageController.text.trim();
    final subject =
        _subjectController.text.trim().isEmpty
            ? null
            : _subjectController.text.trim();

    if (message.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Message cannot be empty")));
      return;
    }

    final response = await MailApiService.sendMail(
      subject: subject,
      message: message,
    );

    if (!mounted) return;

    if (response.success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message ?? "Mail sent successfully!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message ?? "Failed to send mail")),
      );
    }
  }

  void _applyTemplate(String templateKey) {
    final template = _templateMap[templateKey];
    if (template != null) {
      setState(() {
        _subjectController.text = template['subject']!;
        _messageController.text = template['message']!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        title: const Text(
          "Compose Mail",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange[50],
        foregroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // Subject Field
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(20),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _subjectController,
                    decoration: const InputDecoration(
                      hintText: "Enter subject title here",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Message Field
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(20),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _messageController,
                    maxLines: 8,
                    maxLength: _maxCharacters,
                    decoration: const InputDecoration(
                      counterText: "",
                      hintText: "Write your mail here...",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Be kind and thoughtful 💌",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      "${_messageController.text.length}/$_maxCharacters",
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            _messageController.text.length > _maxCharacters
                                ? Colors.red
                                : Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Topic Templates Section
            const SizedBox(height: 8),
            Text(
              "Ideas",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children:
                    _templateMap.keys.map((templateKey) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(templateKey),
                          selected: false,
                          onSelected: (_) {
                            _applyTemplate(templateKey);
                          },
                          labelStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          backgroundColor: Colors.orange[100],
                          selectedColor: Colors.orange[300],
                        ),
                      );
                    }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // Send Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: CustomButton(
                text: 'Send Mail',
                onPressed: _submitMail,
                isEnabled: _isFormValid,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
