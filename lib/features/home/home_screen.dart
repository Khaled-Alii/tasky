import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:to_do/core/constants/storage_key.dart';
import 'package:to_do/features/add_task/add_task_screen.dart';
import 'package:to_do/core/services/user_details_service.dart';
import 'package:to_do/features/tasks/high_priority_tasks_screen.dart';
import 'package:to_do/features/home/componants/achieved_tasks_widget.dart';
import 'package:to_do/core/componants/task_list_widget.dart';
import '../../core/controller/theme_controller.dart';
import '../../core/services/storage_manager.dart';
import '../../models/task_model.dart';
import 'dart:io';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RxString _name = ''.obs;
  final RxString _motivationQuote = ''.obs;
  final _tasks = <Task>[].obs;
  final _totalTasks = 0.obs;
  final _totalDoneTasks = 0.obs;
  final isLoading = false.obs;
  final _percentage = 0.0.obs;
  final first4HighPriorityTasks = <Task>[].obs;
  final isDarkMode = ThemeController.isDark().obs;
  final profilePicture = Rxn<File>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserInfo();
    loadTasks();
    getUserPic();
  }

  void getUserPic() {
    final path = UserDetailsService(StorageManager()).getUserProfilePicture();
    if (path != null && File(path).existsSync()) {
      profilePicture.value = File(path);
    }
  }

  void getUserInfo() {
    _name.value = UserDetailsService(StorageManager()).getUserName();
    _motivationQuote.value = UserDetailsService(
      StorageManager(),
    ).getUserMotivationQuote();
  }

  void loadTasks() {
    print('load tasks called');
    isLoading.value = true;
    try {
      final Iterable<dynamic> tasksMap = StorageManager().read('tasks') ?? [];
      _tasks.assignAll(tasksMap.map((task) => Task.fromJson(task)));
      first4HighPriorityTasks.assignAll(
        _tasks.where((e) => e.highPriority).take(4),
      );
      _totalTasks.value = _tasks.length;
      _totalDoneTasks.value = _tasks
          .where((task) => task.isDone == true)
          .length;
      _percentage.value = _totalTasks.value == 0
          ? 0
          : _totalDoneTasks.value / _totalTasks.value;
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveTasks() async {
    final tasksMap = _tasks.map((task) => task.toJson()).toList();
    await StorageManager().write('tasks', tasksMap);
    loadTasks();
  }

  Future<void> deleteTask(String? id) async {
    if (id == null) return;
    _tasks.removeWhere((t) => t.id == id);
    saveTasks();
  }

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
                          child: Obx(() {
                            if (profilePicture.value == null) {
                              return Image.asset(
                                'assets/me.jpg',
                                height: 42,
                                width: 42,
                                fit: BoxFit.cover,
                              );
                            }
                            return Image.file(
                              profilePicture.value!,
                              height: 42,
                              width: 42,
                              fit: BoxFit.cover,
                            );
                          }),
                        ),
                      ),
                      title: Obx(() {
                        return Text(
                          'Good Evening ,${_name.value}',
                          style: Theme.of(context).textTheme.displayMedium,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        );
                      }),
                      subtitle: Obx(() {
                        return Text(
                          _motivationQuote.value,
                          style: Theme.of(context).textTheme.displaySmall,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        );
                      }),
                      trailing: Obx(() {
                        return IconButton(
                          onPressed: () async {
                            isDarkMode.toggle();
                            ThemeController().toggle();
                            StorageManager().write(
                              StorageKey.isDarkMode,
                              isDarkMode.value,
                            );
                          },
                          icon: Icon(
                            isDarkMode.value
                                ? Icons.light_mode
                                : Icons.dark_mode,
                          ),
                        );
                      }),
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
                      totalDoneTasks: _totalDoneTasks,
                      totalTasks: _totalTasks,
                      percentage: _percentage,
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
                      child: Obx(() {
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                            color: const Color(0xFF15B86C),
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
                                          Checkbox(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            activeColor: const Color(
                                              0xFF15B86C,
                                            ),
                                            value: task.isDone,
                                            onChanged: (bool? value) {
                                              task.isDone = value ?? false;
                                              saveTasks();
                                              _tasks.refresh();
                                            },
                                          ),
                                          Expanded(
                                            child: Text(
                                              task.name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: task.isDone
                                                  ? Theme.of(
                                                      context,
                                                    ).textTheme.bodySmall
                                                  : Theme.of(
                                                      context,
                                                    ).textTheme.bodyMedium,
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
                                      await Get.to(
                                        () => const HighPriorityTasksScreen(),
                                      );
                                      loadTasks();
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
                      }),
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
              TaskListWidget.sliver(
                tasks: _tasks,
                isLoading: isLoading,
                saveTasks: saveTasks,
              ),
            ],
          ),
        ),

        floatingActionButton: SizedBox(
          height: 40,
          child: FloatingActionButton.extended(
            onPressed: () async {
              final bool? result = await Get.to(() => AddTask());
              result == true ? loadTasks() : null;
              setState(() {});
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
