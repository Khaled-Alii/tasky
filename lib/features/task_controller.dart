import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:to_do/core/constants/storage_key.dart';
import 'package:to_do/core/controller/theme_controller.dart';
import 'package:to_do/core/services/storage_manager.dart';
import 'package:to_do/core/services/user_details_service.dart';
import 'package:to_do/models/task_model.dart';

class TaskController extends ChangeNotifier {
  String name = '';
  String motivationQuote = '';
  List<Task> tasks = [];
  List<Task> first4HighPriorityTasks = [];
  int totalTasks = 0;
  int totalDoneTasks = 0;
  bool isLoading = false;
  double percentage = 0.0;
  bool isDarkMode = ThemeController.isDark();
  File? profilePicture;

  List<Task> get completedTasks => tasks.where((t) => t.isDone).toList();

  List<Task> get todoTasks => tasks.where((t) => !t.isDone).toList();

  List<Task> get highPriorityTasks =>
      tasks.where((t) => t.highPriority).toList();

  void init() {
    getUserInfo();
    loadTasks();
    getUserPic();
  }

  // 2. خلي التعديل والحذف والـ Toggle جوه الـ Controller نفسه
  Future<void> toggleTask(Task task, bool isDone) async {
    task.isDone = isDone;
    await saveTasks();
  }

  Future<void> editTask({
    required Task task,
    required String name,
    required String desc,
    required bool highPriority,
  }) async {
    task.name = name.trim();
    task.description = desc.trim();
    task.highPriority = highPriority;
    await saveTasks();
  }

  void getUserPic() {
    final path = UserDetailsService(StorageManager()).getUserProfilePicture();
    if (path != null && File(path).existsSync()) {
      profilePicture = File(path);
    }
  }

  void getUserInfo() {
    name = UserDetailsService(StorageManager()).getUserName();
    motivationQuote = UserDetailsService(
      StorageManager(),
    ).getUserMotivationQuote();
  }

  void loadTasks() {
    print('load tasks called');
    isLoading = true;
    try {
      final Iterable<dynamic> tasksMap =
          StorageManager().read(StorageKey.tasks) ?? [];
      tasks = tasksMap.map((task) => Task.fromJson(task)).toList();
      first4HighPriorityTasks = tasks
          .where((e) => e.highPriority)
          .take(4)
          .toList();
      totalTasks = tasks.length;
      totalDoneTasks = tasks.where((task) => task.isDone == true).length;
      percentage = totalTasks == 0 ? 0 : totalDoneTasks / totalTasks;
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
    }
    notifyListeners();
  }

  Future<void> saveTasks() async {
    final tasksMap = tasks.map((task) => task.toJson()).toList();
    await StorageManager().write(StorageKey.tasks, tasksMap);
    loadTasks();
  }

  Future<void> deleteTask(String? id) async {
    if (id == null) return;
    tasks.removeWhere((t) => t.id == id);
    saveTasks();
  }
}
