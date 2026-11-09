import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do/core/services/storage_manager.dart';
import 'package:to_do/widgets/task_list_widget.dart';

import '../models/task_model.dart';

class HighPriorityTasksScreen extends StatefulWidget {
  const HighPriorityTasksScreen({super.key});

  @override
  State<HighPriorityTasksScreen> createState() =>
      _HighPriorityTasksScreenState();
}

class _HighPriorityTasksScreenState extends State<HighPriorityTasksScreen> {
  final tasks = <Task>[].obs; // مهام الـ High Priority المعروضة
  List<Task> _otherTasks = []; // باقي المهام العادية للحفاظ عليها عند الحفظ
  final isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  void loadTasks() {
    isLoading.value = true;
    try {
      final data = StorageManager().read('tasks') ?? [];

      final allTasks = (data as List)
          .map((e) => Task.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      // فصل مهام الـ High Priority عن المهام العادية
      tasks.assignAll(allTasks.where((t) => t.highPriority));
      _otherTasks = allTasks.where((t) => !t.highPriority).toList();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveTasks() async {
    // 1. دمج المهام العادية مع مهام الـ High Priority (بعد التعديل أو الحذف)
    final updatedAllTasks = [..._otherTasks, ...tasks];
    updatedAllTasks.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    // 2. حفظ القائمة الكاملة في التخزين المحلي
    final tasksJson = updatedAllTasks.map((t) => t.toJson()).toList();
    await StorageManager().write('tasks', tasksJson);

    // 3. إعادة التحميل (حتى لو المستخدم عدّل مهمة وشال منها الـ High Priority تختفي فوراً من الشاشة دي)
    loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('High Priority Tasks'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TaskListWidget(
          tasks: tasks,
          isLoading: isLoading,
          saveTasks: saveTasks,
        ),
      ),
    );
  }
}
