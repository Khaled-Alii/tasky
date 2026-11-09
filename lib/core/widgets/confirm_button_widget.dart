import 'package:flutter/material.dart';

class ConfirmButtonWidget extends StatelessWidget {
  const ConfirmButtonWidget({
    super.key,
    required this.confirmAction,
    required this.labelText,
    this.labelIcon,
  });

  final Future<void> Function() confirmAction;
  final String labelText;
  final Icon? labelIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ElevatedButton.icon(
        onPressed: confirmAction,
        label: Text(labelText, style: TextStyle(fontSize: 14)),
        icon: labelIcon,
        style: ElevatedButton.styleFrom(
          fixedSize: Size(MediaQuery.of(context).size.width, 40),
        ),
      ),
    );
  }
}
