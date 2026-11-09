import 'package:get/get.dart';
import 'package:to_do/models/task_model.dart';

class TaskSingleton {
  static final taskSingleton = TaskSingleton._();

  TaskSingleton._();

  factory TaskSingleton() => taskSingleton;

  final tasksObs = <Task>[].obs;
  final tasks = <Task>[];
}
