import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do/core/widgets/custom_alert_dialog_widget.dart';
import '../controller/theme_controller.dart';
import '../enums/task_details_option_enum.dart';
import '../widgets/confirm_button_widget.dart';
import '../widgets/custom_text_field_widget.dart';
import '../../models/task_model.dart';

class TaskListWidget extends StatelessWidget {
  const TaskListWidget({
    super.key,
    required this.tasks,
    required this.isLoading,
    required this.saveTasks,
    this.isSliver = false,
  });

  // Constructor إضافي لو حابب تناديه بشكل أوضح: TaskListWidget.sliver(...)
  const TaskListWidget.sliver({
    super.key,
    required this.tasks,
    required this.isLoading,
    required this.saveTasks,
  }) : isSliver = true;

  final RxList<Task> tasks;
  final RxBool isLoading;
  final Function saveTasks;
  final bool isSliver;

  Future<void> deleteTask(String? id) async {
    if (id == null) return;
    tasks.removeWhere((t) => t.id == id);
    saveTasks();
  }

  Future<void> editTask({
    required Task task,
    required TextEditingController name,
    required TextEditingController desc,
    required bool highPriority,
  }) async {
    // تحديث بيانات المهمة بالقيم الجديدة الراجعة من شاشة التعديل
    task.name = name.text.trim();
    task.description = desc.text.trim();
    task.highPriority = highPriority;
    tasks.refresh();
    await saveTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // 1. حالة التحميل
      if (isLoading.value) {
        const loader = Center(
          child: CircularProgressIndicator(color: Colors.white),
        );
        return isSliver
            ? const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: loader,
                ),
              )
            : loader;
      }

      // 2. حالة القائمة فارغة
      if (tasks.isEmpty) {
        final emptyText = Center(
          child: Text(
            'No Tasks Yet..',
            style: Theme.of(
              context,
            ).textTheme.displayLarge!.copyWith(fontSize: 32),
          ),
        );
        return isSliver
            ? SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: emptyText,
                ),
              )
            : emptyText;
      }

      // 3. حالة وجود مهام (Sliver)
      if (isSliver) {
        return SliverPadding(
          padding: const EdgeInsets.only(bottom: 94),
          sliver: SliverList.builder(
            itemCount: tasks.length,
            itemBuilder: (ctx, index) => _buildTaskItem(tasks[index]),
          ),
        );
      }

      // 4. حالة وجود مهام (ListView عادي)
      return ListView.builder(
        padding: const EdgeInsets.only(bottom: 94),
        itemCount: tasks.length,
        itemBuilder: (ctx, index) => _buildTaskItem(tasks[index]),
      );
    });
  }

  Widget _buildTaskItem(Task task) {
    return TaskItemWidget(
      task: task,
      onToggle: (bool? v) {
        task.isDone = v ?? false;
        saveTasks();
      },
      deleteTask: deleteTask,
      editTask: editTask,
    );
  }
}

/// ويدجت مستقل لشكل المهمة الواحدة (يمنع تكرار الكود)
class TaskItemWidget extends StatelessWidget {
  TaskItemWidget({
    super.key,
    required this.task,
    required this.onToggle,
    required this.deleteTask,
    required this.editTask,
  });

  final Task task;
  final void Function(bool?) onToggle;

  final Function(String? id) deleteTask;
  final Future<void> Function({
    required Task task,
    required TextEditingController name,
    required TextEditingController desc,
    required bool highPriority,
  })
  editTask;

  final details = TaskDetailsOptionEnum.values
      .map((e) => PopupMenuItem(value: e, child: Text(e.name)))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Checkbox(value: task.isDone, onChanged: onToggle),
        title: Text(
          task.name,
          style: task.isDone
              ? Theme.of(context).textTheme.headlineMedium
              : Theme.of(context).textTheme.headlineSmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: (task.description?.isNotEmpty ?? false) && !task.isDone
            ? Text(
                task.description!,
                style: Theme.of(context).textTheme.labelSmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: PopupMenuButton<TaskDetailsOptionEnum>(
          onSelected: (value) async {
            switch (value) {
              case TaskDetailsOptionEnum.edit:
                // TODO: Handle edit
                await _showBottomSheet(context: context, task: task);
                // editTask(task);
                break;
              case TaskDetailsOptionEnum.delete:
                CustomAlertDialogWidget.show(
                  context: context,
                  title: 'Delete',
                  content: 'Are you sure you want to delete task?',
                  actionText: 'Delete',
                  action: () => deleteTask(task.id),
                );
                break;
            }
          },
          icon: Icon(
            Icons.more_vert,
            color: ThemeController.isDark()
                ? (task.isDone
                      ? const Color(0xFFA0A0A0)
                      : const Color(0xFFC6C6C6))
                : (task.isDone
                      ? const Color(0xFF6A6A6A)
                      : const Color(0xFF3A4640)),
          ),
          itemBuilder: (ctx) => details,
        ),
      ),
    );
  }

  Future<void> _showBottomSheet({
    required BuildContext context,
    required Task task,
  }) async {
    final key = GlobalKey<FormState>();
    final taskNameController = TextEditingController(text: task.name);
    final descriptionController = TextEditingController(text: task.description);
    final highPriority = task.highPriority.obs;

    await showModalBottomSheet(
      elevation: 5,
      context: context,
      isScrollControlled: true,
      // ضروري للتمدد مع الكيبورد
      constraints: BoxConstraints(
        // أقصى طول مسموح به 90% من الشاشة (حتى لا يغطي الـ Status Bar)
        maxHeight: MediaQuery.of(context).size.height * 0.9,
        // لو تريد أن يأخذ حجم العناصر بالضبط احذف السطر القادم، أو اتركه ليكون نصف الشاشة كحد أدنى
        minHeight: MediaQuery.of(context).size.height * 0.5,
      ),
      builder: (sheetContext) {
        return Padding(
          // 1. السر هنا: إضافة ارتفاع الكيبورد للـ Padding السفلي باستخدام sheetContext
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 8.0,
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 16.0,
          ),
          child: Form(
            key: key,
            child: Column(
              // 2. إجبار العمود على أخذ أقل ارتفاع ممكن بدل 90% من الشاشة
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 3. استبدال Expanded بـ Flexible لكي لا يتمدد بدون داعي
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 20),
                        CustomTextFieldWidget(
                          controller: taskNameController,
                          hintText: null,
                          maxLines: 1,
                          validate: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Should Enter the task name';
                            }
                            return null;
                          },
                          title: 'Task Name',
                        ),
                        const SizedBox(height: 20),
                        CustomTextFieldWidget(
                          controller: descriptionController,
                          hintText: null,
                          maxLines: 5,
                          title: 'Task Description',
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "High Priority",
                              style: Theme.of(
                                sheetContext,
                              ).textTheme.displayMedium,
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
                const SizedBox(height: 12),
                ConfirmButtonWidget(
                  confirmAction: () async {
                    if (key.currentState!.validate()) {
                      await editTask(
                        task: task,
                        name: taskNameController,
                        desc: descriptionController,
                        highPriority: highPriority.value,
                      );
                      Get.back();
                    }
                  },
                  labelText: 'Confirm Task',
                  labelIcon: const Icon(Icons.done, color: Color(0xFFFFFCFC)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
