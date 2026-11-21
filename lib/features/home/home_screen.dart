import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:to_do/core/constants/storage_key.dart';
import 'package:to_do/features/add_task/add_task_screen.dart';
import 'package:to_do/core/services/user_details_service.dart';
import 'package:to_do/features/task_controller.dart';
import 'package:to_do/features/tasks/high_priority_tasks_screen.dart';
import 'package:to_do/features/home/componants/achieved_tasks_widget.dart';
import 'package:to_do/core/componants/task_list_widget.dart';
import '../../core/controller/theme_controller.dart';
import '../../core/services/storage_manager.dart';
import '../../models/task_model.dart';
import 'dart:io';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        child: ClipOval(
                          child: Selector<TaskController, File?>(
                            selector: (context, controller) =>
                                controller.profilePicture,
                            builder: (context, file, child) {
                              if (file == null) {
                                return Image.asset(
                                  'assets/me.jpg',
                                  height: 42,
                                  width: 42,
                                  fit: BoxFit.cover,
                                );
                              }
                              return Image.file(
                                file,
                                height: 42,
                                width: 42,
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                      ),
                      title: Selector<TaskController, String>(
                        selector:
                            (BuildContext p1, TaskController controller) =>
                                controller.name,
                        builder:
                            (BuildContext context, String name, Widget? child) {
                              return Text(
                                'Good Evening ,$name',
                                style: Theme.of(
                                  context,
                                ).textTheme.displayMedium,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              );
                            },
                      ),
                      subtitle: Selector<TaskController, String>(
                        builder:
                            (
                              BuildContext context,
                              motivationQuote,
                              Widget? child,
                            ) => Text(
                              motivationQuote,
                              style: Theme.of(context).textTheme.displaySmall,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),

                        selector: (BuildContext p1, TaskController p2) =>
                            p2.motivationQuote,
                      ),

                      trailing: Selector<TaskController, bool>(
                        builder:
                            (BuildContext context, isDarkMode, Widget? child) =>
                                IconButton(
                                  onPressed: () async {
                                    isDarkMode = !isDarkMode;
                                    ThemeController().toggle();
                                    StorageManager().write(
                                      StorageKey.isDarkMode,
                                      isDarkMode,
                                    );
                                  },
                                  icon: Icon(
                                    isDarkMode
                                        ? Icons.light_mode
                                        : Icons.dark_mode,
                                  ),
                                ),

                        selector: (BuildContext p1, TaskController p2) =>
                            p2.isDarkMode,
                      ),
                    ),
                    Align(
                      alignment: AlignmentGeometry.centerLeft,
                      child: Text(
                        'Yuhuu ,Your work Is',
                        style: Theme.of(
                          context,
                        ).textTheme.displayLarge!.copyWith(fontSize: 32),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'almost done !',
                          style: Theme.of(
                            context,
                          ).textTheme.displayLarge!.copyWith(fontSize: 32),
                        ),
                        SvgPicture.asset('assets/hand.svg'),
                      ],
                    ),
                    SizedBox(height: 16),
                    AchievedTasksWidget(
                      totalDoneTasks: context
                          .read<TaskController>()
                          .totalDoneTasks,
                      totalTasks: context.read<TaskController>().totalTasks,
                      percentage: context.read<TaskController>().percentage,
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(width: 0.6),
                      ),
                      child: Selector<TaskController, List<Task>>(
                        builder:
                            (
                              BuildContext context,
                              first4HighPriorityTasks,
                              Widget? child,
                            ) {
                              if (first4HighPriorityTasks.isEmpty) {
                                return SizedBox(
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Text(
                                      'No high priority tasks',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.displayMedium,
                                    ),
                                  ),
                                );
                              }

                              // تصفية وتجهيز العناصر للعرض
                              final displayTasks = first4HighPriorityTasks
                                  .where((e) => e.highPriority)
                                  .take(4)
                                  .toList();

                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                          ),
                                          child: Text(
                                            'High Priority Tasks',
                                            style: Theme.of(context)
                                                .textTheme
                                                .displaySmall!
                                                .copyWith(
                                                  color: const Color(
                                                    0xFF15B86C,
                                                  ),
                                                ),
                                          ),
                                        ),
                                        ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          padding: EdgeInsets.zero,
                                          itemCount: displayTasks.length,
                                          itemBuilder: (context, index) {
                                            final task = displayTasks[index];
                                            return Row(
                                              children: [
                                                Selector<
                                                  TaskController,
                                                  Function
                                                >(
                                                  builder:
                                                      (
                                                        BuildContext context,
                                                        value,
                                                        Widget? child,
                                                      ) {
                                                        return Checkbox(
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  4,
                                                                ),
                                                          ),
                                                          activeColor:
                                                              const Color(
                                                                0xFF15B86C,
                                                              ),
                                                          value: task.isDone,
                                                          onChanged:
                                                              (bool? value) {
                                                                task.isDone =
                                                                    value ??
                                                                    false;
                                                                value;
                                                              },
                                                        );
                                                      },
                                                  selector:
                                                      (
                                                        BuildContext p1,
                                                        TaskController p2,
                                                      ) {
                                                        return p2.saveTasks;
                                                      },
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    task.name,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: task.isDone
                                                        ? Theme.of(
                                                            context,
                                                          ).textTheme.bodySmall
                                                        : Theme.of(context)
                                                              .textTheme
                                                              .bodyMedium,
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      right: 8,
                                      bottom: 16,
                                    ),
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: const Color(0xFF6E6E6E),
                                        ),
                                        shape: BoxShape.circle,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primaryContainer,
                                      ),
                                      child: Transform.rotate(
                                        angle: pi / 4,
                                        child: IconButton(
                                          onPressed: () async {
                                            await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const HighPriorityTasksScreen(),
                                              ),
                                            );
                                            if (!context.mounted) return;
                                            context
                                                .read<TaskController>()
                                                .loadTasks();
                                          },
                                          icon: const Icon(
                                            Icons.arrow_upward,
                                            color: Color(0xFFC6C6C6),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                        selector: (BuildContext p1, TaskController p2) {
                          return p2.first4HighPriorityTasks;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16, top: 24),
                      child: Text(
                        'My Tasks',
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                    ),
                  ],
                ),
              ),
              Consumer<TaskController>(
                builder: (BuildContext context, homeController, Widget? child) {
                  return TaskListWidget.sliver(
                    tasks: homeController.tasks,
                    isLoading: homeController.isLoading,
                  );
                },
              ),
            ],
          ),
        ),

        floatingActionButton: SizedBox(
          height: 40,
          child: FloatingActionButton.extended(
            onPressed: () async {
              final bool? result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddTaskScreen()),
              );
              if (!context.mounted) return;
              result == true
                  ? context.read<TaskController>().loadTasks()
                  : null;
            },
            backgroundColor: Color(0xFF15B86C),
            foregroundColor: Color(0xFFFFFCFC),
            label: Text('Add New Task'),
            icon: Icon(Icons.add),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ),
      ),
    );
  }
}
