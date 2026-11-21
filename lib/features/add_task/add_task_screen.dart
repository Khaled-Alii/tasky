import 'dart:async';
import 'package:flutter/material.dart';
import 'package:to_do/core/constants/storage_key.dart';
import 'package:to_do/core/services/storage_manager.dart';
import 'package:to_do/models/task_model.dart';
import 'package:to_do/core/widgets/custom_text_field_widget.dart';
import 'package:uuid/uuid.dart';
import '../../core/widgets/confirm_button_widget.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _key = GlobalKey<FormState>();

  final taskNameController = TextEditingController();

  final descriptionController = TextEditingController();
  final highPriority = ValueNotifier<bool>(true);

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
      final List<dynamic> currentList =
          StorageManager().read(StorageKey.tasks) ?? [];
      currentList.add(task);
      await StorageManager().write(StorageKey.tasks, currentList);

      if (context.mounted) {
        Navigator.pop(context);
      }
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
                            ValueListenableBuilder(
                              valueListenable: highPriority,
                              builder:
                                  (BuildContext context, value, Widget? child) {
                                    return Switch(
                                      value: value,
                                      onChanged: (value) {
                                        highPriority.value = value;
                                      },
                                    );
                                  },
                            ),
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
