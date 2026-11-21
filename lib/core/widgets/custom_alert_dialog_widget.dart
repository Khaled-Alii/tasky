import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAlertDialogWidget extends StatelessWidget {
  const CustomAlertDialogWidget({
    super.key,
    required this.title,
    required this.content,
    required this.actionText,
    required this.action,
  });

  final String title;
  final String content;
  final String actionText;
  final Function action;

  /// دالة مساعدة لفتح الـ Dialog مباشرة من أي مكان في التطبيق
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String content,
    required String actionText,
    required Function action,
  }) async {
    showDialog(
      context: context,
      builder: (_) => CustomAlertDialogWidget(
        title: title,
        content: content,
        actionText: actionText,
        action: action,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(title, style: Theme.of(context).textTheme.displayLarge),
      content: Text(content, style: Theme.of(context).textTheme.displayMedium),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text(
            'Cancel',
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE53935),
            foregroundColor: const Color(0xFFFFFCFC),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            action();
            Get.back();
          },
          child: Text(actionText),
        ),
      ],
    );
  }

}
