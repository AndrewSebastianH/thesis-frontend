import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _messageController.addListener(_validateForm);
  }

  void _validateForm() {
    setState(() {
      _isFormValid =
          _messageController.text.trim().isNotEmpty &&
          _subjectController.text.trim().isNotEmpty &&
          _messageController.text.length <= _maxCharacters;
    });
  }

  void _submitMail() {
    final message = _messageController.text.trim();
    final subject = _subjectController.text.trim();

    if (message.isEmpty || subject.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Message and subject cannot be empty")),
      );
      return;
    }

    // TODO: Replace with actual send mail API
    print({'message': message});
    print({'subject': subject});

    Navigator.pop(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Mail sent successfully!")));
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
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.09),
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
