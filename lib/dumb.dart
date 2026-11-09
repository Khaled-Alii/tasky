// import 'dart:math';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:to_do/screens/high_priority_tasks_screen.dart';
//
// class Dumb extends StatelessWidget {
//   const Dumb({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             border: BoxBorder.all(width: 0.6),
//           ),
//           child: Obx(() {
//             if (first4HighPriorityTasks.isEmpty) {
//               return SizedBox(
//                 width: double.infinity,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Text(
//                     'No high priority tasks',
//                     style: Theme.of(context).textTheme.displayMedium,
//                   ),
//                 ),
//               );
//             }
//
//             return Row(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 8),
//                         child: Text(
//                           'High Priority Tasks',
//                           style: Theme.of(context).textTheme.displaySmall!
//                               .copyWith(color: Color(0xFF15B86C)),
//                         ),
//                       ),
//
//                       ...first4HighPriorityTasks.reversed
//                           .where((e) => e.highPriority)
//                           .take(4)
//                           .map((task) {
//                             return Row(
//                               children: [
//                                 Checkbox(
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(4),
//                                   ),
//                                   activeColor: const Color(0xFF15B86C),
//                                   value: task.isDone,
//                                   onChanged: (bool? value) {
//                                     task.isDone = value ?? false;
//                                     saveTasks();
//                                     _tasks.refresh();
//                                   },
//                                 ),
//                                 Expanded(
//                                   child: Text(
//                                     task.name,
//                                     maxLines: 1,
//                                     overflow: TextOverflow.ellipsis,
//                                     style: TextStyle(
//                                       color: task.isDone
//                                           ? const Color(0xFFA0A0A0)
//                                           : const Color(0xFFFFFCFC),
//                                       fontSize: task.isDone ? 18 : 16,
//                                       fontWeight: FontWeight.w400,
//                                       decoration: task.isDone
//                                           ? TextDecoration.lineThrough
//                                           : TextDecoration.none,
//                                       decorationColor: const Color(0xFFA0A0A0),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             );
//                           }),
//                     ],
//                   ),
//                 ),
//
//                 Padding(
//                   padding: EdgeInsetsGeometry.only(right: 8, bottom: 16),
//                   child: Container(
//                     height: 40,
//                     width: 40,
//                     decoration: BoxDecoration(
//                       border: Border.all(color: const Color(0xFF6E6E6E)),
//                       shape: BoxShape.circle,
//                     ),
//                     child: Transform.rotate(
//                       angle: pi / 4,
//                       child: IconButton(
//                         onPressed: () async {
//                           await Get.to(() => HighPriorityTasksScreen());
//                           loadTasks();
//                         },
//                         icon: const Icon(
//                           Icons.arrow_upward,
//                           color: Color(0xFFC6C6C6),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           }),
//         ),
//         ListView.builder(shrinkWrap: true,itemBuilder: (context,index)=>Container())
//       ],
//     );
//   }
// }
