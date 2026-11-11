import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do/core/componants/task_list_widget.dart';

import '../../core/services/storage_manager.dart';
import '../../models/task_model.dart';

class CompletedTasksScreen extends StatefulWidget {
  const CompletedTasksScreen({super.key});

  @override
  State<CompletedTasksScreen> createState() => _CompletedTasksScreenState();
}

class _CompletedTasksScreenState extends State<CompletedTasksScreen> {
  final completedTasks = <Task>[].obs; // المهام المكتملة التي ستُعرض في الشاشة (.obs)
  List<Task> _uncompletedTasks = [];   // المهام غير المكتملة للاحتفاظ بها عند الحفظ

  final isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  void loadTasks() {
    isLoading.value = true;
    try {
      final List<dynamic> tasksMap = StorageManager().read('tasks') ?? [];

      final loadedTasks = tasksMap
          .map((task) => Task.fromJson(Map<String, dynamic>.from(task)))
          .toList();

      // فصل المهام المكتملة (للعرض) عن غير المكتملة (للحفظ)
      completedTasks.assignAll(
        loadedTasks.where((task) => task.isDone).toList(),
      );
      _uncompletedTasks = loadedTasks.where((task) => !task.isDone).toList();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveTasks() async {
    // 1. دمج المهام غير المكتملة مع المهام المكتملة المعروضة
    final allUpdatedTasks = [..._uncompletedTasks, ...completedTasks];

    // 2. ترتيب المهام حسب وقت الإنشاء للحفاظ على ترتيبها الأصلي
    allUpdatedTasks.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    // 3. حفظ الكل في التخزين المحلي
    final tasksMap = allUpdatedTasks.map((task) => task.toJson()).toList();
    await StorageManager().write('tasks', tasksMap);

    // 4. إعادة التحميل (حتى لو ألغيت علامة الصح عن مهمة تختفي فوراً من شاشة المكتملة)
    loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Completed Tasks')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TaskListWidget(
            tasks: completedTasks, // نمرر المهام المكتملة هنا
            isLoading: isLoading,
            saveTasks: saveTasks,
          ),
        ),
      ),
    );
  }
}