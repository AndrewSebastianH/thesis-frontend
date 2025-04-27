import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thesis_frontend/widgets/custom_button.dart';

class CreateTaskPage extends StatefulWidget {
  const CreateTaskPage({super.key});

  @override
  State<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  DateTime? _dueDate;
  bool _isRecurring = false;
  String _recurrenceInterval = 'daily';

  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_validateForm);
  }

  void _validateForm() {
    setState(() {
      _isFormValid = _titleController.text.trim().isNotEmpty;
    });
  }

  Future<void> _selectDueDate() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Set Due Date",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.event),
                  title: const Text("Pick a date"),
                  onTap: () async {
                    Navigator.pop(context);
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now().add(const Duration(days: 1)),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) {
                      setState(() {
                        _dueDate = picked;
                        _isRecurring = false;
                      });
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.clear),
                  title: const Text("Remove date"),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _dueDate = null;
                    });
                  },
                ),
              ],
            ),
          ),
    );
  }

  void _submitTask() {
    final title = _titleController.text.trim();
    final desc = _descController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Title cannot be empty")));
      return;
    }

    // 🔁 Replace with actual API call
    print({
      'title': title,
      'description': desc.isEmpty ? null : desc,
      'dueDate': _dueDate?.toIso8601String().split("T").first,
      'isRecurring': _isRecurring,
      'recurrenceInterval': _isRecurring ? _recurrenceInterval : null,
    });

    Navigator.pop(context); // Close page after submission
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        title: const Text(
          "Create Task",
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
                    controller: _titleController,
                    decoration: const InputDecoration(
                      hintText: "Enter task title here",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                  const Divider(),
                  TextField(
                    controller: _descController,
                    decoration: const InputDecoration(
                      hintText: "Enter task description here (optional)",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              "Task Options",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 12),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(20),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                children: [
                  if (!_isRecurring) // 🔥 Only show due date if NOT recurring
                    Column(
                      children: [
                        ListTile(
                          onTap: _selectDueDate,
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            _dueDate == null
                                ? "No due date"
                                : "Due: ${DateFormat.yMMMd().format(_dueDate!)}",
                            style: TextStyle(
                              color:
                                  _dueDate == null
                                      ? Colors.grey
                                      : Colors.black87,
                              fontWeight:
                                  _dueDate == null
                                      ? FontWeight.normal
                                      : FontWeight.w500,
                            ),
                          ),
                          trailing: const Icon(Icons.calendar_today),
                        ),
                        const Divider(),
                      ],
                    ),

                  if (_dueDate ==
                      null) // 🔥 Only show recurring toggle if NO due date set
                    Column(
                      children: [
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          value: _isRecurring,
                          onChanged: (val) {
                            setState(() {
                              _isRecurring = val;
                              if (_isRecurring)
                                _dueDate = null; // Just extra safety
                            });
                          },
                          activeColor: Colors.orange,
                          title: Text(
                            "Repeat this task?",
                            style: TextStyle(
                              color:
                                  _isRecurring ? Colors.black87 : Colors.grey,
                            ),
                          ),
                        ),

                        if (_isRecurring) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Text(
                                "Repeat: ",
                                style: TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(width: 8),
                              DropdownButton<String>(
                                value: _recurrenceInterval,
                                items: const [
                                  DropdownMenuItem(
                                    value: 'daily',
                                    child: Text(
                                      "Daily",
                                      style: TextStyle(color: Colors.black87),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 'weekly',
                                    child: Text(
                                      "Weekly",
                                      style: TextStyle(color: Colors.black87),
                                    ),
                                  ),
                                ],
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() => _recurrenceInterval = val);
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: CustomButton(
                text: 'Create Task',
                onPressed: _submitTask,
                isEnabled: _isFormValid,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
