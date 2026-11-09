import 'package:flutter/material.dart';

class CustomTextFieldWidget extends StatelessWidget {
  const CustomTextFieldWidget({
    super.key,
    required this.controller,
    required this.hintText,
    this.maxLines,
    this.validate,
    required this.title,
  });

  final String title;
  final TextEditingController controller;
  final String? hintText;
  final int? maxLines;
  final String? Function(String? value)? validate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.displayMedium),
        SizedBox(height: 8),
        TextFormField(
          style: Theme.of(context).textTheme.labelMedium,
          controller: controller,
          maxLines: maxLines,
          validator: validate,
          decoration: InputDecoration(hint: Text(hintText ?? '')),
        ),
      ],
    );
  }
}
