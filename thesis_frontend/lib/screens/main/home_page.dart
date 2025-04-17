import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> tasks = [
    {'title': 'Task 1', 'completed': false},
    {'title': 'Task 2', 'completed': false},
    {'title': 'Gulingkan pemerintahan', 'completed': false},
  ];

  @override
  void initState() {
    super.initState();
    _checkMoodScreen();
  }

  Future<void> _checkMoodScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final currentDate = "${now.year}-${now.month}-${now.day}";
    final lastShownDate = prefs.getString('lastMoodScreenDate');

    if (lastShownDate != currentDate && now.hour >= 15) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showMoodDialog();
      });
    }
  }

  void _showMoodDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Force user to pick a mood
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("How are you feeling today?"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildMoodButton("Happy", "😊"),
              _buildMoodButton("Neutral", "😐"),
              _buildMoodButton("Sad", "😢"),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMoodButton(String mood, String emoji) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(45),
          backgroundColor: const Color(0xFFFF7F50),
          foregroundColor: Colors.white,
        ),
        onPressed: () => _submitMood(mood.toLowerCase()),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("$emoji $mood", style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }

  Future<void> _submitMood(String mood) async {
    Navigator.pop(context); // Close dialog

    // Store that we've shown the mood screen today
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final currentDate = "${now.year}-${now.month}-${now.day}";
    await prefs.setString('lastMoodScreenDate', currentDate);

    // Send mood to backend
    try {
      final response = await http.post(
        Uri.parse('https://your-api-url.com/api/mood'),
        headers: {'Content-Type': 'application/json'},
        body: '{"mood": "$mood"}',
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Mood submitted: $mood")));
      } else {
        throw Exception("Failed to submit mood");
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to submit mood")));
    }
  }

  void completeTask(int index) {
    setState(() {
      tasks[index]['completed'] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final incompleteTasks = tasks.where((task) => !task['completed']).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "To do list app",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFFF7F50),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text("Task to do:", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            Expanded(
              child:
                  incompleteTasks.isEmpty
                      ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("🎉", style: TextStyle(fontSize: 48)),
                            SizedBox(height: 12),
                            Text(
                              "You've completed all your tasks for today! Great job!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                      : ListView.builder(
                        itemCount: incompleteTasks.length,
                        itemBuilder: (context, index) {
                          final task = incompleteTasks[index];
                          final originalIndex = tasks.indexOf(task);
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              title: Text(task['title']),
                              trailing: ElevatedButton(
                                onPressed: () => completeTask(originalIndex),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
