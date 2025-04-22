import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/tasks_mdl.dart';
import '../../services/tasks_api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late BuildContext safeScaffoldContext;
  List<TaskModel> tasks = [];

  @override
  void initState() {
    super.initState();
    _checkMoodScreen();
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    final fetchedTasks = await TaskService.fetchTasks();
    if (!mounted) return;
    setState(() => tasks = fetchedTasks);
  }

  Future<void> _completeTask(TaskModel task) async {
    if (task.isCustomTask) {
      await TaskService.completeCustomTask(task.id);
    } else {
      await TaskService.completeSystemTask(task.id);
    }
    if (!mounted) return;
    setState(
      () => tasks.removeWhere((t) => t.id == task.id && t.type == task.type),
    );

    ScaffoldMessenger.of(safeScaffoldContext).showSnackBar(
      const SnackBar(content: Text("Task marked as completed! 🎉")),
    );
  }

  Future<void> _checkMoodScreen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('lastMoodScreenDate');

    final now = DateTime.now().copyWith(hour: 16);
    final currentDate = "${now.year}-${now.month}-${now.day}";
    final lastShownDate = prefs.getString('lastMoodScreenDate');

    if (lastShownDate != currentDate && now.hour >= 15) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showMoodDialog());
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
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset('assets/images/boybear_heart.png', width: 120),
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
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Text(emoji, style: const TextStyle(fontSize: 24)),
      ),
    );
  }

  Future<void> _submitMood(String mood) async {
    Navigator.of(context, rootNavigator: true).pop();
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final currentDate = "${now.year}-${now.month}-${now.day}";
    await prefs.setString('lastMoodScreenDate', currentDate);

    if (!mounted) return;
    _showDetailInputDialog(mood);
  }

  void _showDetailInputDialog(String mood) {
    final TextEditingController _detailController = TextEditingController();

    showDialog(
      context: context,
      barrierColor: Colors.orange[100],
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              "Write about your day?",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.orange[800],
              ),
            ),
            content: TextField(
              controller: _detailController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Type your thoughts here...",
                filled: true,
                fillColor: Colors.orange[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _finalizeMoodSubmission(mood, '');
                },
                child: const Text("Not now"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _finalizeMoodSubmission(mood, _detailController.text.trim());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Submit",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  Future<void> _finalizeMoodSubmission(String mood, String detail) async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final currentDate = "${now.year}-${now.month}-${now.day}";
    await prefs.setString('lastMoodScreenDate', currentDate);

    if (!mounted) return;

    ScaffoldMessenger.of(safeScaffoldContext).showSnackBar(
      SnackBar(
        content: Text(switch (mood) {
          "sad" => "Hope things feel better soon. 💛",
          "neutral" => "Thanks for checking in! 💪",
          "happy" => "Good to hear! 💖",
          _ => "Mood submitted.",
        }),
      ),
    );
  }

  void _showTaskDetails(TaskModel task) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.8),
      barrierDismissible: true,
      builder: (context) {
        return Stack(
          children: [
            Positioned(
              bottom: 175,
              child: Dialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        task.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (task.description != null &&
                          task.description!.trim().isNotEmpty)
                        Text(
                          task.description!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 14),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 100,
              left: MediaQuery.of(context).size.width / 2 - 36,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  _completeTask(task);
                },
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Stroke
                        Text(
                          "Complete",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            foreground:
                                Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 3
                                  ..color = Colors.black,
                          ),
                        ),
                        // Fill
                        Text(
                          "Complete",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final incompleteTasks = tasks.where((t) => !t.completed).toList();

    return Scaffold(
      body: Builder(
        builder: (scaffoldCtx) {
          safeScaffoldContext = scaffoldCtx;

          return Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/backgrounds/1.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  if (incompleteTasks.isNotEmpty) ...[
                    const Text(
                      "Tasks to do:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

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
                                    "You've completed all your tasks!\n Great Job! 🎊",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            )
                            : ListView.builder(
                              itemCount: incompleteTasks.length,
                              itemBuilder: (context, index) {
                                final task = incompleteTasks[index];
                                return Card(
                                  color:
                                      task.isCustomTask
                                          ? Colors.blue[50]
                                          : Colors.orange[50],
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 6,
                                    ),
                                    title: Text(
                                      task.title,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    subtitle: Text(
                                      task.isCustomTask
                                          ? 'Custom Task'
                                          : 'Repeats ${task.recurrenceInterval}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    trailing: ElevatedButton(
                                      onPressed: () => _completeTask(task),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        minimumSize: const Size(
                                          48,
                                          48,
                                        ), // Square size
                                        padding:
                                            EdgeInsets
                                                .zero, // No internal padding distortion,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                    onTap: () => _showTaskDetails(task),
                                  ),
                                );
                              },
                            ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
