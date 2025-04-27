import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:thesis_frontend/services/insights_api_service.dart';
import 'package:thesis_frontend/models/insights_mdl.dart';

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

  @override
  void initState() {
    super.initState();
    showSelf = widget.showSelf;
    loadInsight();
  }

  Future<void> loadInsight() async {
    setState(() => isLoading = true);
    final fetchedInsight = await InsightApiService.fetchInsight(
      showSelf ? 'self' : 'related',
    );
    setState(() {
      insightData = fetchedInsight;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        title: const Text(
          "Insights",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange[50],
        foregroundColor: Colors.orange,
        elevation: 0,
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
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (!showSelf) {
                  setState(() {
                    showSelf = true;
                  });
                  loadInsight();
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: showSelf ? Colors.orange : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
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
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (showSelf) {
                  setState(() {
                    showSelf = false;
                  });
                  loadInsight();
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !showSelf ? Colors.orange : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
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
              title: Container(height: 32, width: 100, color: Colors.grey[300]),
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
