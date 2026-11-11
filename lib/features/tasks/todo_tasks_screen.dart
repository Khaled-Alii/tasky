import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do/core/services/storage_manager.dart';
import 'package:to_do/core/componants/task_list_widget.dart';

import '../../models/task_model.dart';

class TodoTasksScreen extends StatefulWidget {
  const TodoTasksScreen({super.key});

  @override
  State<TodoTasksScreen> createState() => _TodoTasksScreenState();
}

class _TodoTasksScreenState extends State<TodoTasksScreen> {
  List<Task> _completedTasks = []; // نحتفظ بالمهام المكتملة هنا
  final tasks = <Task>[].obs; // المهام غير المكتملة (المعروضة)
  final isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  void loadTasks() {
    isLoading.value = true;
    try {
      // 1. القراءة كـ List<dynamic> لتجنب الكراش
      final List<dynamic> tasksMap = StorageManager().read('tasks') ?? [];

      final loadedTasks = tasksMap
          .map((task) => Task.fromJson(Map<String, dynamic>.from(task)))
          .toList();

      // 2. فصل المهام المكتملة عن غير المكتملة
      _completedTasks = loadedTasks.where((task) => task.isDone).toList();
      tasks.assignAll(loadedTasks.where((task) => !task.isDone).toList());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveTasks() async {
    // 1. دمج المهام المكتملة مع قائمة المهام الحالية (بعد التعديل أو الحذف أو التعليم كـ Done)
    final allUpdatedTasks = [..._completedTasks, ...tasks];

    // 2. ترتيب المهام حسب وقت الإنشاء للحفاظ على ترتيبها الأصلي
    allUpdatedTasks.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    // 3. حفظ الكل في التخزين المحلي
    final tasksMap = allUpdatedTasks.map((task) => task.toJson()).toList();
    await StorageManager().write('tasks', tasksMap);

    // 4. إعادة التحميل (بحيث لو علمت على مهمة كـ Done تختفي فوراً من شاشة To Do)
    loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('To Do Tasks')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TaskListWidget(
            tasks: tasks,
            isLoading: isLoading,
            saveTasks: saveTasks,
          ),
        ),
      ),
    );
  }
}