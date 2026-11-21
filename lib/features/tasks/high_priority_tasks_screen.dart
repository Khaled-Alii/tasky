import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:to_do/core/constants/storage_key.dart';
import 'package:to_do/core/services/storage_manager.dart';
import 'package:to_do/core/componants/task_list_widget.dart';
import 'package:to_do/features/task_controller.dart';

import '../../models/task_model.dart';

class HighPriorityTasksScreen extends StatelessWidget {
  const HighPriorityTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Completed Tasks')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<TaskController>(
            builder:
                (
                  BuildContext context,
                  TaskController controller,
                  Widget? child,
                ) {
                  return TaskListWidget(
                    tasks: controller
                        .highPriorityTasks, // نمرر المهام المكتملة هنا
                    isLoading: controller.isLoading,
                  );
                },
          ),
        ),
      ),
    );
  }
}
