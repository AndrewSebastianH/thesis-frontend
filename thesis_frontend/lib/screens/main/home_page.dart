import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;

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

    // TEMP: clear for debugging
    await prefs.remove('lastMoodScreenDate'); // or await prefs.clear();

    final now = DateTime.now().copyWith(hour: 16);
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
      useRootNavigator: true,
      barrierDismissible: false,
      barrierColor: Colors.orange[100],
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.orange[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              12,
            ), // Less rounded than default
          ),
          title: const Text(
            "How are you feeling today?",
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/boybear_heart.png',
                width: 100,
                height: 100,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildMoodButton("sad", "😢"),
                  const SizedBox(width: 12),
                  _buildMoodButton("neutral", "😐"),
                  const SizedBox(width: 12),
                  _buildMoodButton("happy", "😊"),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMoodButton(String mood, String emoji) {
    return GestureDetector(
      onTap: () => _submitMood(mood),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: Text(emoji, style: const TextStyle(fontSize: 28)),
      ),
    );
  }

  Future<void> _submitMood(String mood) async {
    Navigator.of(context, rootNavigator: true).pop();

    final messenger = ScaffoldMessenger.of(context);
    final now = DateTime.now();
    final prefs = await SharedPreferences.getInstance();
    final currentDate = "${now.year}-${now.month}-${now.day}";
    await prefs.setString('lastMoodScreenDate', currentDate);

    try {
      // Simulate API call or success
      switch (mood) {
        case "sad":
          // Simulate a sad mood submission
          messenger.showSnackBar(
            SnackBar(content: Text("Hope things feel better soon 💛.")),
          );
          break;
        case "neutral":
          // Simulate a neutral mood submission
          messenger.showSnackBar(
            SnackBar(content: Text("Thanks for checking in 💪.")),
          );
          break;
        case "happy":
          // Simulate a happy mood submission
          messenger.showSnackBar(SnackBar(content: Text("Good to hear! 💖.")));
          break;
        default:
          messenger.showSnackBar(
            SnackBar(content: Text("Submitted Mood: $mood")),
          );
      }
      // final response = await ...
    } catch (e) {
      if (mounted) {
        messenger.showSnackBar(
          const SnackBar(content: Text("Failed to submit mood")),
        );
      }
    }
  }

  // Future<void> _submitMood(String mood) async {
  //   Navigator.of(context, rootNavigator: true).pop();

  //   // Store that we've shown the mood screen today
  //   final prefs = await SharedPreferences.getInstance();
  //   final now = DateTime.now();
  //   final currentDate = "${now.year}-${now.month}-${now.day}";
  //   await prefs.setString('lastMoodScreenDate', currentDate);

  //   // Send mood to backend
  //   try {
  //     // final response = await http.post(
  //     //   Uri.parse('https://your-api-url.com/api/mood'),
  //     //   headers: {'Content-Type': 'application/json'},
  //     //   body: '{"mood": "$mood"}',
  //     // );

  //     // if (response.statusCode == 200) {
  //     //   ScaffoldMessenger.of(
  //     //     context,
  //     //   ).showSnackBar(SnackBar(content: Text("Mood submitted: $mood")));
  //     // } else {
  //     //   throw Exception("Failed to submit mood");
  //     // }
  //   } catch (e) {
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(const SnackBar(content: Text("Failed to submit mood")));
  //   }
  // }

  void completeTask(int index) {
    if (!mounted) return;
    setState(() {
      tasks[index]['completed'] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final incompleteTasks = tasks.where((task) => !task['completed']).toList();

    return Scaffold(
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
