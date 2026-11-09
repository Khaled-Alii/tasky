// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:to_do/core/controller/theme_controller.dart';
// import 'package:to_do/core/enums/task_details_option_enum.dart';
//
// import '../models/task_model.dart';
//
// class SliverTaskListWidget extends StatelessWidget {
//   const SliverTaskListWidget({
//     super.key,
//     required this.tasks,
//     required this.isLoading,
//     required this.saveTasks,
//   });
//
//   final RxList<Task> tasks;
//   final RxBool isLoading;
//   final Function saveTasks;
//
//   @override
//   Widget build(BuildContext context) {
//     final details = TaskDetailsOptionEnum.values
//         .map((e) => PopupMenuItem(value: e, child: Text(e.name)))
//         .toList();
//     return Obx(() {
//       // 1. حالة التحميل
//       if (isLoading.value) {
//         return const SliverToBoxAdapter(
//           child: Padding(
//             padding: EdgeInsets.symmetric(vertical: 40),
//             child: Center(
//               child: CircularProgressIndicator(color: Colors.white),
//             ),
//           ),
//         );
//       }
//
//       // 2. حالة القائمة فارغة
//       if (tasks.isEmpty) {
//         return SliverToBoxAdapter(
//           child: Padding(
//             padding: EdgeInsets.symmetric(vertical: 40),
//             child: Center(
//               child: Text(
//                 'No Tasks Yet..',
//                 style: Theme.of(
//                   context,
//                 ).textTheme.displayLarge!.copyWith(fontSize: 32),
//               ),
//             ),
//           ),
//         );
//       }
//
//       // 3. حالة وجود مهام (نستخدم SliverPadding مع SliverList.builder)
//       return SliverPadding(
//         padding: const EdgeInsets.only(bottom: 94),
//         sliver: SliverList.builder(
//           itemCount: tasks.length,
//           itemBuilder: (ctx, index) {
//             final task = tasks[index];
//             return Card.outlined(
//               child: ListTile(
//                 leading: Checkbox(
//                   value: task.isDone,
//                   onChanged: (bool? v) {
//                     task.isDone = v ?? false;
//                     tasks.refresh();
//                     saveTasks();
//                   },
//                 ),
//                 title: Text(
//                   task.name,
//                   style: task.isDone
//                       ? Theme.of(context).textTheme.headlineMedium
//                       : Theme.of(context).textTheme.headlineSmall,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 subtitle:
//                     (task.description?.isNotEmpty ?? false) && !task.isDone
//                     ? Text(
//                         task.description!,
//                         style: Theme.of(context).textTheme.labelSmall,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       )
//                     : null,
//                 trailing: PopupMenuButton<TaskDetailsOptionEnum>(
//                   onSelected: (value) {
//                     switch (value) {
//                       case TaskDetailsOptionEnum.edit:
//                         // TODO: Handle this case.
//                         break;
//                       case TaskDetailsOptionEnum.delete:
//                         // TODO: Handle this case.
//                         break;
//                     }
//                   },
//                   icon: Icon(
//                     Icons.more_vert,
//                     color: ThemeController.isDark()
//                         ? (task.isDone ? Color(0xFFA0A0A0) : Color(0xFFC6C6C6))
//                         : (task.isDone ? Color(0xFF6A6A6A) : Color(0xFF3A4640)),
//                   ),
//                   itemBuilder: (ctx) => details,
//                 ),
//               ),
//             );
//           },
//         ),
//       );
//     });
//   }
// }
