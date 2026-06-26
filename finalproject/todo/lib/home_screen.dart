import 'package:flutter/material.dart';

import 'add_task_screen.dart';
import 'app_theme.dart';
import 'db.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> allTasks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    setState(() => isLoading = true);

    try {
      allTasks = await DatabaseHelper.instance.getTasks();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to load tasks: $e"),
            backgroundColor: AppColors.dangerDark,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> deleteTask(int id, String name) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.delete_outline, color: AppColors.danger, size: 32),
        title: const Text("Delete Task"),
        content: Text('Are you sure you want to delete "$name"?'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await DatabaseHelper.instance.deleteTask(id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Task deleted"),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      fetchTasks();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to delete task: $e"),
            backgroundColor: AppColors.dangerDark,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> openAddTask() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddTaskScreen(),
      ),
    );

    if (result == true) {
      fetchTasks();
    } else {
      fetchTasks();
    }
  }

  Future<void> openEditTask(Map<String, dynamic> task) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTaskScreen(task: task),
      ),
    );

    if (result == true) {
      fetchTasks();
    } else {
      fetchTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: const Text("ToDo App"),
        centerTitle: true,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openAddTask,
        tooltip: "Add Task",
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        )
            : allTasks.isEmpty
            ? _buildEmptyState(theme)
            : RefreshIndicator(
          onRefresh: fetchTasks,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 4,
            ),
            itemCount: allTasks.length,
            itemBuilder: (context, index) {
              final task = allTasks[index];
              return _buildTaskCard(theme, task);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return RefreshIndicator(
      onRefresh: fetchTasks,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.checklist_rtl,
                      size: 48,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "No tasks yet",
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Tap the + button to add your first task",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(ThemeData theme, Map<String, dynamic> task) {
    final name = task['name'] ?? '';
    final date = task['date'] ?? '';
    final time = task['time'] ?? '';
    final description = task['description'] ?? '';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left accent bar — gives the card a quiet signature touch.
            Container(width: 5, color: AppColors.primary),

            Expanded(
              child: InkWell(
                onTap: () => openEditTask(task),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 14, 8, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            onPressed: () => openEditTask(task),
                            icon: const Icon(
                              Icons.edit_outlined,
                              size: 20,
                              color: AppColors.primary,
                            ),
                            tooltip: "Edit",
                          ),
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            onPressed: () => deleteTask(task['id'], name),
                            icon: const Icon(
                              Icons.delete_outline,
                              size: 20,
                              color: AppColors.danger,
                            ),
                            tooltip: "Delete",
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      Wrap(
                        spacing: 10,
                        runSpacing: 6,
                        children: [
                          _buildMetaChip(
                            icon: Icons.calendar_today_outlined,
                            label: date,
                            background: AppColors.primaryLight,
                            foreground: AppColors.primaryDark,
                          ),
                          _buildMetaChip(
                            icon: Icons.access_time,
                            label: time,
                            background: const Color(0xFFFFF7E6),
                            foreground: const Color(0xFFB45309),
                          ),
                        ],
                      ),

                      if (description.toString().isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Text(
                          description,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaChip({
    required IconData icon,
    required String label,
    required Color background,
    required Color foreground,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: foreground),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: foreground,
            ),
          ),
        ],
      ),
    );
  }
}