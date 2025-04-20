// import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
// import 'package:http/http.dart' as http;
// import 'package:thesis_frontend/config/apiConfig.dart';
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

  @override
  void initState() {
    super.initState();
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

    setState(() {
      emotionEvents = eventMap;
      _selectedEvents = _getEventsForDay(_selectedDay ?? _focusedDay);
    });
  }

  List<EmotionLog> _getEventsForDay(DateTime day) {
    final normalized = DateTime.utc(day.year, day.month, day.day);
    return emotionEvents[normalized] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Emotion Calendar",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          TableCalendar<EmotionLog>(
            firstDay: DateTime.utc(2024, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: CalendarFormat.month,
            availableCalendarFormats: const {CalendarFormat.month: 'Month'},
            eventLoader: _getEventsForDay,
            onDaySelected: (selectedDay, focusedDay) {
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
                color: Color(0xFFFF7F50), // match the border
                fontWeight: FontWeight.bold,
              ),
            ),

            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isEmpty) return const SizedBox();
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:
                      events.map((e) {
                        final color =
                            (e).userId == '1' ? Colors.orange : Colors.blue;
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
          Expanded(
            child:
                _selectedEvents.isEmpty
                    ? const Center(child: Text("No emotion logs for this day."))
                    : ListView.builder(
                      itemCount: _selectedEvents.length,
                      itemBuilder: (context, index) {
                        final log = _selectedEvents[index];
                        return Card(
                          color:
                              log.userId == '1'
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
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            leading: CircleAvatar(
                              radius: 20,
                              backgroundColor:
                                  log.userId == '1'
                                      ? Colors.orange
                                      : Colors.blue,
                              child: Text(
                                log.userId,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              "${log.emotion[0].toUpperCase()}${log.emotion.substring(1)}",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              DateFormat.yMMMMd().format(log.date),
                              style: const TextStyle(fontSize: 12),
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
