import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:thesis_frontend/providers/user_provider.dart';
import 'package:thesis_frontend/services/insights_api_service.dart';
import 'package:thesis_frontend/models/insights_mdl.dart';
import 'package:thesis_frontend/widgets/connect_prompt_card.dart';

class InsightsPage extends StatefulWidget {
  final bool showSelf;
  const InsightsPage({super.key, this.showSelf = true});

  @override
  State<InsightsPage> createState() => _InsightsPageState();
}

class _InsightsPageState extends State<InsightsPage> {
  late bool showSelf;
  InsightModel? insightData;
  bool isLoading = true;
  String selectedRange = 'month';

  @override
  void initState() {
    super.initState();
    showSelf = widget.showSelf;
    loadInsight();
  }

  String _rangeLabel(String range) {
    switch (range) {
      case 'week':
        return 'Weekly';
      case '2weeks':
        return '2 Weeks';
      case 'month':
        return 'Monthly';
      default:
        return '';
    }
  }

  Future<void> loadInsight() async {
    setState(() => isLoading = true);
    final fetchedInsight = await InsightApiService.fetchInsight(
      showSelf ? 'self' : 'related',
      selectedRange,
    );
    setState(() {
      insightData = fetchedInsight;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        title: Text(
          "${_rangeLabel(selectedRange)} Insights ",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange[50],
        foregroundColor: Colors.orange,
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
                icon: const Icon(
                  Icons.filter_list_rounded,
                  color: Colors.orange,
                ),
                color: Colors.white,
                onSelected: (value) {
                  setState(() {
                    selectedRange = value;
                  });
                  loadInsight();
                },
                itemBuilder:
                    (context) => [
                      const PopupMenuItem(
                        value: 'week',
                        child: Text('This Week'),
                      ),
                      const PopupMenuItem(
                        value: '2weeks',
                        child: Text('Last 2 Weeks'),
                      ),
                      const PopupMenuItem(
                        value: 'month',
                        child: Text('Last Month'),
                      ),
                    ],
              ),
            ),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildToggle(),
            const SizedBox(height: 20),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child:
                    isLoading
                        ? _buildSkeletonLoader()
                        : !showSelf && !userProvider.hasConnection
                        ? ConnectPromptCard(
                          text: "Connect with a relative to share insights!",
                        )
                        : insightData == null
                        ? const Center(child: Text("No insights found."))
                        : ListView(
                          key: ValueKey(showSelf),
                          children: [
                            _buildCard(child: _buildEmotionSummary()),
                            const SizedBox(height: 20),
                            _buildCard(
                              child: _buildTaskSection(
                                "Top System Tasks",
                                insightData!.systemTasks,
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildCard(
                              child: _buildTaskSection(
                                "Top Custom Tasks",
                                insightData!.customTasks,
                              ),
                            ),
                          ],
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggle() {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
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
            alignment: showSelf ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              width: (MediaQuery.of(context).size.width - 64) / 2,
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
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () {
                      if (!showSelf) {
                        setState(() {
                          showSelf = true;
                        });
                        loadInsight();
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 48,
                      child: Text(
                        "You",
                        style: TextStyle(
                          color: showSelf ? Colors.white : Colors.orange,
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
                      if (showSelf) {
                        setState(() {
                          showSelf = false;
                        });
                        loadInsight();
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 48,
                      child: Text(
                        "Relative",
                        style: TextStyle(
                          color: !showSelf ? Colors.white : Colors.orange,
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
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildTaskSection(String title, List<TaskInsight> tasks) {
    if (tasks.isEmpty) {
      return const Text("No data yet.");
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 10),
        ...tasks.map(
          (task) => ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(
              Icons.check_circle_outline,
              color: Colors.orange,
            ),
            title: Text(task.title),
            trailing: Text("${task.completedTimes}x"),
          ),
        ),
      ],
    );
  }

  Widget _buildEmotionSummary() {
    final emotions = insightData!.emotions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Emotion Summary",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildEmotionCount("😢", emotions.sad),
            _buildEmotionCount("😐", emotions.neutral),
            _buildEmotionCount("😊", emotions.happy),
          ],
        ),
        const SizedBox(height: 10),
        Text("Most Common: ${emotions.mostCommonEmotion}"),
        const SizedBox(height: 4),
        Text("Last Emotion Log: ${emotions.lastEmotionDate ?? "N/A"}"),
      ],
    );
  }

  Widget _buildEmotionCount(String emoji, int count) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 28)),
        const SizedBox(height: 4),
        Text("$count"),
      ],
    );
  }

  Widget _buildSkeletonLoader() {
    return Skeletonizer(
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.only(
              left: 12,
              right: 12,
              top: 48,
              bottom: 48,
            ),
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: ListTile(
              leading: Icon(
                Icons.check_circle_outline,
                color: Colors.grey[300],
              ),

              title: Container(
                height: 32,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              trailing: Container(
                height: 16,
                width: 20,
                color: Colors.grey[300],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(20),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListTile(
              leading: Icon(
                Icons.check_circle_outline,
                color: Colors.grey[300],
              ),
              title: Container(height: 16, width: 100, color: Colors.grey[300]),
              trailing: Container(
                height: 16,
                width: 20,
                color: Colors.grey[300],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(20),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListTile(
              leading: Icon(
                Icons.check_circle_outline,
                color: Colors.grey[300],
              ),
              title: Container(height: 16, width: 120, color: Colors.grey[300]),
              trailing: Container(
                height: 16,
                width: 20,
                color: Colors.grey[300],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
