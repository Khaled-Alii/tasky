// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:to_do/models/task_model.dart';
// import 'package:to_do/core/widgets/custom_text_field_widget.dart';
// import '../core/widgets/confirm_button_widget.dart';
//
// class EditTaskScreen extends StatefulWidget {
//   const EditTaskScreen({super.key});
//
//   @override
//   State<EditTaskScreen> createState() => _EditTaskState();
// }
//
// class _EditTaskState extends State<EditTaskScreen> {
//   final _key = GlobalKey<FormState>();
//
//   final taskNameController = TextEditingController();
//
//   final descriptionController = TextEditingController();
//
//   RxBool highPriority = true.obs;
//
//   late final Task result;
//
//
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     taskNameController.dispose();
//     descriptionController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     result = Get.arguments as Task;
//     taskNameController.text = result.name;
//     descriptionController.text = result.description ?? '';
//     return _showBottomSheet();
//   }
//
//
// }
