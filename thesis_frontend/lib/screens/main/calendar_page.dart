import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:thesis_frontend/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:thesis_frontend/models/emotion_log_mdl.dart';
import 'package:thesis_frontend/services/emotion_api_service.dart';
import 'package:intl/intl.dart';

class EmotionCalendarPage extends StatefulWidget {
  const EmotionCalendarPage({super.key});

  @override
  State<EmotionCalendarPage> createState() => _EmotionCalendarPageState();
}

class _EmotionCalendarPageState extends State<EmotionCalendarPage> {
  Map<DateTime, List<EmotionLog>> emotionEvents = {};
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<EmotionLog> _selectedEvents = [];
  bool _isLoading = true;
  String _logFilter = 'All'; // Options: All, You, Relative

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.setMockParentUser();

    loadEmotionLogs();
  }

  Future<void> loadEmotionLogs() async {
    final logs = await EmotionService.fetchEmotionLogs();

    final Map<DateTime, List<EmotionLog>> eventMap = {};

    for (var log in logs) {
      final normalizedDate = DateTime.utc(
        log.date.year,
        log.date.month,
        log.date.day,
      );
      if (eventMap[normalizedDate] == null) {
        eventMap[normalizedDate] = [log];
      } else {
        eventMap[normalizedDate]!.add(log);
      }
    }

    if (!mounted) return;
    setState(() {
      emotionEvents = eventMap;
      _selectedEvents = _getEventsForDay(_selectedDay ?? _focusedDay);
      _isLoading = false;
    });
  }

  List<EmotionLog> _getEventsForDay(DateTime day) {
    final normalized = DateTime.utc(day.year, day.month, day.day);
    final logs = emotionEvents[normalized] ?? [];

    final currentUser = Provider.of<UserProvider>(context, listen: false).user;
    final relatedUser =
        Provider.of<UserProvider>(context, listen: false).relatedUser;

    if (_logFilter == 'You') {
      return logs.where((log) => log.userId == currentUser?.id).toList();
    } else if (_logFilter == 'Relative') {
      return logs.where((log) => log.userId == relatedUser?.id).toList();
    } else {
      return logs; // All
    }
  }

  void _showLogDetailsDialog(
    BuildContext context,
    EmotionLog log,
    String username,
    String avatarAsset,
    bool isCurrentUser,
  ) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Log Details',
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Container(
                    width: 320,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 24,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isCurrentUser ? Colors.orange[100] : Colors.blue[100],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color:
                            isCurrentUser ? Colors.orange : Colors.blueAccent,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(20),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 30), // to avoid X overlap
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage(avatarAsset),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "$username felt ${log.emotion}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          DateFormat.yMMMMd().format(log.date),
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.orange[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.orangeAccent),
                          ),
                          child: Text(
                            log.detail.isNotEmpty
                                ? log.detail
                                : "No additional notes provided.",
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Close (X) button
                Positioned(
                  top: 6,
                  right: 20,
                  child: IconButton(
                    icon: const Icon(
                      Icons.close_rounded,
                      size: 24,
                      color: Colors.grey,
                    ),
                    splashRadius: 20,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final currentUser = userProvider.user;
    final relatedUser = userProvider.relatedUser;

    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        title: const Text(
          "Emotion Calendar",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange[50],
      ),
      body: Column(
        children: [
          TableCalendar<EmotionLog>(
            rowHeight: 42,
            daysOfWeekHeight: 20,
            firstDay: DateTime.utc(2024, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: CalendarFormat.month,
            availableCalendarFormats: const {CalendarFormat.month: 'Month'},
            eventLoader: _getEventsForDay,
            onDaySelected: (selectedDay, focusedDay) {
              if (!mounted) return;
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                _selectedEvents = _getEventsForDay(selectedDay);
              });
            },

            calendarStyle: const CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: Color(0xFFFF7F50),
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.fromBorderSide(
                  BorderSide(color: Color(0xFFFF7F50), width: 2),
                ),
              ),
              todayTextStyle: TextStyle(
                color: Color(0xFFFF7F50),
                fontWeight: FontWeight.bold,
              ),
            ),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, date, _) {
                final logs = _getEventsForDay(date);

                // Only show emoji if there's exactly 1 event
                if (logs.length == 1 && _logFilter != 'All') {
                  final log = logs.first;
                  final emoji = switch (log.emotion) {
                    'happy' => '😊',
                    'neutral' => '😐',
                    'sad' => '😢',
                    _ => '',
                  };

                  return Center(
                    child: Text(emoji, style: const TextStyle(fontSize: 24)),
                  );
                }

                // Default day display
                return null;
              },
              markerBuilder: (context, date, events) {
                final logs = _getEventsForDay(date);

                // Hide marker if filter is not 'All' and there's only one log
                // if ((_logFilter != 'All' && logs.length == 1) || logs.isEmpty) {
                //   return const SizedBox.shrink();
                // }

                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:
                      logs.map((e) {
                        final color =
                            e.userId == currentUser?.id
                                ? Colors.orange
                                : Colors.blue;

                        return Container(
                          width: 6,
                          height: 6,
                          margin: const EdgeInsets.symmetric(horizontal: 0.5),
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        );
                      }).toList(),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              FilterChip(
                label: const Text("All"),
                selected: _logFilter == 'All',
                onSelected: (_) => setState(() => _logFilter = 'All'),
                selectedColor: Colors.orange[300], // background when selected
                backgroundColor:
                    Colors.orange[50], // background when NOT selected
                labelStyle: TextStyle(
                  color:
                      _logFilter == 'All' ? Colors.white : Colors.orange[800],
                  fontWeight: FontWeight.w600,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              FilterChip(
                label: const Text("My Logs"),
                selected: _logFilter == 'You',
                onSelected: (_) => setState(() => _logFilter = 'You'),
                selectedColor: Colors.orange[300],
                backgroundColor: Colors.orange[50],
                labelStyle: TextStyle(
                  color:
                      _logFilter == 'You' ? Colors.white : Colors.orange[800],
                  fontWeight: FontWeight.w600,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              FilterChip(
                label: const Text("Relative's "),
                selected: _logFilter == 'Relative',
                onSelected: (_) => setState(() => _logFilter = 'Relative'),
                selectedColor: Colors.orange[300],
                backgroundColor: Colors.orange[50],
                labelStyle: TextStyle(
                  color:
                      _logFilter == 'Relative'
                          ? Colors.white
                          : Colors.orange[800],
                  fontWeight: FontWeight.w600,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          Expanded(
            child:
                _isLoading
                    ? ListView.builder(
                      padding: const EdgeInsets.only(bottom: 80),
                      itemCount: 3,
                      itemBuilder:
                          (context, index) => const SkeletonEmotionCard(),
                    )
                    : _selectedEvents.isEmpty
                    ? const Padding(
                      padding: EdgeInsets.only(bottom: 80.0),
                      child: Center(
                        child: Text("No emotion logs for this day."),
                      ),
                    )
                    : ListView.builder(
                      itemCount: _selectedEvents.length,
                      itemBuilder: (context, index) {
                        final log = _selectedEvents[index];
                        final isCurrentUser = log.userId == currentUser?.id;
                        final username =
                            isCurrentUser
                                ? "You"
                                : relatedUser?.username ?? "Someone";
                        final avatarAsset =
                            isCurrentUser
                                ? userProvider.userAvatarAsset
                                : userProvider.relatedUserAvatarAsset;

                        return Card(
                          color:
                              isCurrentUser
                                  ? Colors.orange[100]
                                  : Colors.blue[100],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 16,
                          ),
                          child: ListTile(
                            onTap:
                                () => _showLogDetailsDialog(
                                  context,
                                  log,
                                  username,
                                  avatarAsset,
                                  isCurrentUser,
                                ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            leading: CircleAvatar(
                              radius: 20,
                              backgroundImage: AssetImage(avatarAsset),
                            ),
                            title: Text(
                              "${log.emotion[0].toUpperCase()}${log.emotion.substring(1)}",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat.yMMMMd().format(log.date),
                                  style: const TextStyle(fontSize: 12),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  isCurrentUser
                                      ? "You shared this feeling"
                                      : "$username shared this feeling",
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}

class SkeletonEmotionCard extends StatelessWidget {
  const SkeletonEmotionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          leading: const CircleAvatar(radius: 20),
          title: Container(
            height: 16,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6),
              Container(
                height: 10,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                height: 8,
                width: 120,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
