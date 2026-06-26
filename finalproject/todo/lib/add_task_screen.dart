import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'db.dart';

class AddTaskScreen extends StatefulWidget {
  final Map<String, dynamic>? task;

  const AddTaskScreen({super.key, this.task});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  bool isEdit = false;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    if (widget.task != null) {
      isEdit = true;

      nameController.text = widget.task!['name'] ?? '';
      dateController.text = widget.task!['date'] ?? '';
      timeController.text = widget.task!['time'] ?? '';
      descriptionController.text = widget.task!['description'] ?? '';

      // Try to parse existing date/time so the pickers stay in sync.
      selectedDate = _tryParseDate(dateController.text);
      selectedTime = _tryParseTime(timeController.text);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    dateController.dispose();
    timeController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  // ---------- Helpers: parsing ----------

  DateTime? _tryParseDate(String value) {
    if (value.trim().isEmpty) return null;
    try {
      final parts = value.split('/');
      if (parts.length != 3) return null;
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      return DateTime(year, month, day);
    } catch (_) {
      return null;
    }
  }

  TimeOfDay? _tryParseTime(String value) {
    if (value.trim().isEmpty) return null;
    try {
      final cleaned = value.trim().toUpperCase();
      final isPM = cleaned.contains('PM');
      final isAM = cleaned.contains('AM');
      final numericPart =
      cleaned.replaceAll('AM', '').replaceAll('PM', '').trim();
      final parts = numericPart.split(':');
      if (parts.length != 2) return null;
      int hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      if (isPM && hour != 12) hour += 12;
      if (isAM && hour == 12) hour = 0;

      return TimeOfDay(hour: hour, minute: minute);
    } catch (_) {
      return null;
    }
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return "$day/$month/$year";
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? "AM" : "PM";
    return "$hour:$minute $period";
  }

  // ---------- Pickers ----------

  Future<void> pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dateController.text = _formatDate(picked);
      });
    }
  }

  Future<void> pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        selectedTime = picked;
        timeController.text = _formatTime(picked);
      });
    }
  }

  // ---------- Validators ----------

  String? validateName(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return "Please enter a task name";
    }
    if (trimmed.length < 3) {
      return "Task name must be at least 3 characters";
    }
    if (trimmed.length > 60) {
      return "Task name must be under 60 characters";
    }
    return null;
  }

  String? validateDate(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return "Please select a date";
    }

    final regex = RegExp(r'^\d{2}/\d{2}/\d{4}$');
    if (!regex.hasMatch(trimmed)) {
      return "Use date format dd/mm/yyyy";
    }

    final parsed = _tryParseDate(trimmed);
    if (parsed == null) {
      return "Enter a valid date";
    }

    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);
    if (parsed.isBefore(todayOnly)) {
      return "Date cannot be in the past";
    }

    return null;
  }

  String? validateTime(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return "Please select a time";
    }

    final regex = RegExp(r'^\d{1,2}:\d{2}\s?(AM|PM|am|pm)$');
    if (!regex.hasMatch(trimmed)) {
      return "Use time format hh:mm AM/PM";
    }

    final parsed = _tryParseTime(trimmed);
    if (parsed == null) {
      return "Enter a valid time";
    }

    // If the date is today, make sure the time hasn't already passed.
    if (selectedDate != null) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final chosenDateOnly =
      DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day);

      if (chosenDateOnly == today) {
        final chosenDateTime = DateTime(
          selectedDate!.year,
          selectedDate!.month,
          selectedDate!.day,
          parsed.hour,
          parsed.minute,
        );
        if (chosenDateTime.isBefore(now)) {
          return "Time has already passed today";
        }
      }
    }

    return null;
  }

  String? validateDescription(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return "Please enter a description";
    }
    if (trimmed.length < 5) {
      return "Description must be at least 5 characters";
    }
    if (trimmed.length > 250) {
      return "Description must be under 250 characters";
    }
    return null;
  }

  // ---------- Save ----------

  Future<void> saveTask() async {
    // Re-validate time in case the date changed after the time was set.
    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() => isSaving = true);

    try {
      Map<String, dynamic> data = {
        'name': nameController.text.trim(),
        'date': dateController.text.trim(),
        'time': timeController.text.trim(),
        'description': descriptionController.text.trim(),
      };

      if (isEdit) {
        await DatabaseHelper.instance.updateTask(data, widget.task!['id']);
      } else {
        await DatabaseHelper.instance.insertTask(data);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isEdit ? "Task updated" : "Task added"),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Something went wrong: $e"),
          backgroundColor: AppColors.dangerDark,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => isSaving = false);
      }
    }
  }

  void cancel() {
    if (!isSaving) {
      Navigator.pop(context);
    }
  }

  // ---------- UI ----------

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(isEdit ? "Edit Task" : "Add Task"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: AppColors.primaryLight,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.edit_note,
                                color: AppColors.primary,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "Task Details",
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: nameController,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: "Task Name",
                            hintText: "e.g. Submit assignment",
                            prefixIcon: Icon(Icons.task_alt, color: AppColors.primary),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                          ),
                          validator: validateName,
                        ),

                        const SizedBox(height: 16),

                        TextFormField(
                          controller: dateController,
                          readOnly: true,
                          onTap: pickDate,
                          decoration: InputDecoration(
                            labelText: "Date",
                            hintText: "dd/mm/yyyy",
                            prefixIcon: const Icon(
                              Icons.calendar_today_outlined,
                              color: AppColors.primary,
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(
                                Icons.edit_calendar_outlined,
                                color: AppColors.primary,
                              ),
                              onPressed: pickDate,
                              tooltip: "Pick date",
                            ),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                          ),
                          validator: validateDate,
                        ),

                        const SizedBox(height: 16),

                        TextFormField(
                          controller: timeController,
                          readOnly: true,
                          onTap: pickTime,
                          decoration: InputDecoration(
                            labelText: "Time",
                            hintText: "hh:mm AM/PM",
                            prefixIcon: const Icon(
                              Icons.access_time,
                              color: Color(0xFFB45309),
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(
                                Icons.schedule_outlined,
                                color: Color(0xFFB45309),
                              ),
                              onPressed: pickTime,
                              tooltip: "Pick time",
                            ),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                          ),
                          validator: validateTime,
                        ),

                        const SizedBox(height: 16),

                        TextFormField(
                          controller: descriptionController,
                          maxLines: 4,
                          maxLength: 250,
                          textInputAction: TextInputAction.done,
                          decoration: const InputDecoration(
                            labelText: "Description",
                            hintText: "Add some notes about this task",
                            alignLabelWithHint: true,
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(bottom: 60),
                              child: Icon(
                                Icons.notes_outlined,
                                color: AppColors.primary,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                          ),
                          validator: validateDescription,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: isSaving ? null : cancel,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textSecondary,
                          side: const BorderSide(color: AppColors.divider, width: 1.4),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: isSaving ? null : saveTask,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isSaving
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            color: Colors.white,
                          ),
                        )
                            : Text(isEdit ? "Update" : "Submit"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}