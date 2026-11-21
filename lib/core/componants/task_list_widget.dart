import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/core/widgets/custom_alert_dialog_widget.dart';
import 'package:to_do/features/task_controller.dart';
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
    this.isSliver = false,
  });

  // Constructor إضافي لو حابب تناديه بشكل أوضح: TaskListWidget.sliver(...)
  const TaskListWidget.sliver({
    super.key,
    required this.tasks,
    required this.isLoading,
  }) : isSliver = true;

  final List<Task> tasks;
  final bool isLoading;
  final bool isSliver;

  // late final Function saveTasks;

  @override
  Widget build(BuildContext context) {
    // 1. حالة التحميل
    if (isLoading) {
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
  }

  Widget _buildTaskItem(Task task) {
    return TaskItemWidget(task: task);
  }
}

/// ويدجت مستقل لشكل المهمة الواحدة (يمنع تكرار الكود)
class TaskItemWidget extends StatelessWidget {
  const TaskItemWidget({super.key, required this.task});

  final Task task;

  // final Future<void> Function({
  //   required Task task,
  //   required TextEditingController name,
  //   required TextEditingController desc,
  //   required bool highPriority,
  // })
  // editTask;

  static final details = TaskDetailsOptionEnum.values
      .map((e) => PopupMenuItem(value: e, child: Text(e.name)))
      .toList();

  @override
  Widget build(BuildContext context) {
    final controller = context.read<TaskController>();
    return Card(
      child: ListTile(
        leading: Checkbox(
          value: task.isDone,
          onChanged: (value) => controller.toggleTask(task, value ?? false),
        ),
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
                  action: () => controller.deleteTask,
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
    final isHighPriority = ValueNotifier<bool>(task.highPriority);

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
        final controller = sheetContext.read<TaskController>();
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
                            ValueListenableBuilder<bool>(
                              valueListenable: isHighPriority,
                              builder: (context, currentValue, _) {
                                return Switch(
                                  value: currentValue,
                                  onChanged: (value) {
                                    isHighPriority.value = value;
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
                const SizedBox(height: 12),
                ConfirmButtonWidget(
                  confirmAction: () async {
                    if (key.currentState!.validate()) {
                      await controller.editTask(
                        task: task,
                        name: taskNameController.text.trim(),
                        desc: descriptionController.text.trim(),
                        highPriority: isHighPriority.value,
                      );
                      if (sheetContext.mounted) {
                        Navigator.of(sheetContext).pop();
                      }
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
    taskNameController.dispose();
    descriptionController.dispose();
    isHighPriority.dispose();
  }
}
