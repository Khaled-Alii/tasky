import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do/core/services/storage_manager.dart';
import 'package:to_do/models/task_model.dart';
import 'package:to_do/core/widgets/custom_text_field_widget.dart';
import 'package:uuid/uuid.dart';

import '../../core/widgets/confirm_button_widget.dart';
import '../navigation/main_screen.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final _key = GlobalKey<FormState>();

  final taskNameController = TextEditingController();

  final descriptionController = TextEditingController();

  RxBool highPriority = true.obs;

  Future<void> addTask() async {
    if (_key.currentState?.validate() ?? false) {
      final task = Task(
        id: Uuid().v4(),
        name: taskNameController.text.trim(),
        description: descriptionController.text.isEmpty
            ? null
            : descriptionController.text.trim(),
        highPriority: highPriority.value,
        isDone: false,
      ).toJson();

      ///To Do make it when back
      final List<dynamic> currentList = StorageManager().read('tasks') ?? [];
      currentList.add(task);
      await StorageManager().write('tasks', currentList);
      Get.back(result: true);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    taskNameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(centerTitle: false, title: const Text('New Task')),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        CustomTextFieldWidget(
                          controller: taskNameController,
                          hintText: "Finish UI design for login screen",
                          maxLines: 1,
                          validate: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Should Enter the task name';
                            }
                            return null;
                          },
                          title: 'Task Name',
                        ),

                        SizedBox(height: 20),

                        CustomTextFieldWidget(
                          controller: descriptionController,
                          hintText:
                              "Finish onboarding UI and hand off to devs by Thursday.",
                          maxLines: 5,
                          title: 'Task Description',
                        ),
                        SizedBox(height: 8),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "High Priority",
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                            Obx(() {
                              return Switch(
                                value: highPriority.value,
                                onChanged: (value) {
                                  highPriority.value = value;
                                },
                              );
                            }),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    ConfirmButtonWidget(
                      confirmAction: addTask,
                      labelText: 'Add Task',
                      labelIcon: Icon(Icons.add, color: Color(0xFFFFFCFC)),
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
