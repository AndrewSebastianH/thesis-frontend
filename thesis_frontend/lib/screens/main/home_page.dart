import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/tasks_mdl.dart';
import '../../services/tasks_api_service.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late BuildContext safeScaffoldContext;
  List<TaskModel> tasks = [];
  String _filterType = 'All';

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

  List<TaskModel> get filteredTasks {
    if (_filterType == 'System') {
      return tasks.where((t) => !t.completed && !t.isCustomTask).toList();
    } else if (_filterType == 'Custom') {
      return tasks.where((t) => !t.completed && t.isCustomTask).toList();
    } else {
      return tasks.where((t) => !t.completed).toList();
    }
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

  // Show mood modal (1/2)
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

  // Function to show emoji buttons
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

  // Show reflection Modal (2/2)
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
                child: const Text(
                  "Not now",
                  style: TextStyle(color: Colors.black54),
                ),
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

  // Submit Mood and Reflection
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

  // Task press modal
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
              left: MediaQuery.of(context).size.width / 2 - 180,

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
                      const SizedBox(height: 12),

                      if (task.dueDate != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.orange.shade100),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_rounded,
                                size: 14,
                                color: Colors.orange,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "Complete before ${DateFormat.yMMMd().format(task.dueDate!)}",
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
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

  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Today's Goals",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange[50],
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: PopupMenuButton<String>(
                tooltip: "Filter tasks",
                icon: const Icon(
                  Icons.filter_alt_rounded,
                  color: Colors.orange,
                ),
                color: Colors.white, // background color of dropdown
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onSelected: (value) => setState(() => _filterType = value),
                itemBuilder:
                    (BuildContext context) => [
                      const PopupMenuItem(
                        value: 'All',
                        child: Text("Show All"),
                      ),
                      const PopupMenuItem(
                        value: 'System',
                        child: Text("Show Goals"),
                      ),
                      const PopupMenuItem(
                        value: 'Custom',
                        child: Text("Show Custom Tasks"),
                      ),
                    ],
              ),
            ),
          ),
        ],
      ),
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

                  // Task cards
                  Expanded(
                    child:
                        filteredTasks.isEmpty
                            ? const Center(
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 100),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("🎉", style: TextStyle(fontSize: 48)),
                                    SizedBox(height: 12),
                                    Text(
                                      "You've completed all your tasks!\nGreat Job! 🎊",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            : ListView.builder(
                              itemCount: filteredTasks.length,
                              itemBuilder: (context, index) {
                                final task = filteredTasks[index];
                                return Card(
                                  color:
                                      task.isCustomTask
                                          ? Colors.blue[100]
                                          : Colors.orange[100],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),
                                  child: ListTile(
                                    onTap: () => _showTaskDetails(task),
                                    title: Text(task.title),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          task.isCustomTask
                                              ? 'Custom Task'
                                              : 'Repeats ${task.recurrenceInterval}',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Colors.black38,
                                          ),
                                        ),
                                        if (task.dueDate != null) ...[
                                          const SizedBox(height: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: Colors.orange.shade100,
                                              ),
                                            ),
                                            child: Wrap(
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              spacing: 6,
                                              children: [
                                                const Icon(
                                                  Icons.calendar_today_rounded,
                                                  size: 14,
                                                  color: Colors.orange,
                                                ),
                                                Text(
                                                  "Complete before ${DateFormat.yMMMd().format(task.dueDate!)}",
                                                  style: const TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    trailing: ElevatedButton(
                                      onPressed: () => _completeTask(task),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.lightGreen[700],
                                        minimumSize: const Size(48, 48),
                                        padding: EdgeInsets.zero,
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
