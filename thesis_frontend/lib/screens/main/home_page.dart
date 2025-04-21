import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late BuildContext safeScaffoldContext;

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
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            "How are you feeling today?",
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/boybear_heart.png',
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: MediaQuery.of(context).size.width * 0.45,
                ),
                const SizedBox(height: 10),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    _buildMoodButton("sad", "😢"),
                    _buildMoodButton("neutral", "😐"),
                    _buildMoodButton("happy", "😊"),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMoodButton(String mood, String emoji) {
    return GestureDetector(
      onTap: () => _submitMood(mood),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: Text(emoji, style: const TextStyle(fontSize: 24)),
      ),
    );
  }

  Future<void> _submitMood(String mood) async {
    Navigator.of(context, rootNavigator: true).pop();

    final now = DateTime.now();
    final prefs = await SharedPreferences.getInstance();
    final currentDate = "${now.year}-${now.month}-${now.day}";
    await prefs.setString('lastMoodScreenDate', currentDate);

    if (!mounted) return; // Dart-approved guard

    ScaffoldMessenger.of(safeScaffoldContext).showSnackBar(
      SnackBar(
        content: Text(switch (mood) {
          "sad" => "Hope things feel better soon. 💛",
          "neutral" => "Thanks for checking in! 💪",
          "happy" => "Good to hear! 💖",
          _ => "Submitted Mood: $mood",
        }),
      ),
    );
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
      body: Builder(
        builder: (scaffoldCtx) {
          safeScaffoldContext = scaffoldCtx;

          return Padding(
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
                                    onPressed:
                                        () => completeTask(originalIndex),
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
          );
        },
      ),
    );
  }
}
