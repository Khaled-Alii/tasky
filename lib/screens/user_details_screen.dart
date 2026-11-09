import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do/core/services/user_details_service.dart';

import '../core/services/storage_manager.dart';
import '../core/widgets/confirm_button_widget.dart';
import '../core/widgets/custom_text_field_widget.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({super.key});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final userNameController = TextEditingController();
  final motivationController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userNameController.text = UserDetailsService(StorageManager()).getUserName();
    motivationController.text = UserDetailsService(StorageManager()).getUserMotivationQuote();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    userNameController.dispose();
    motivationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('User Details')),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
          child: Form(
            key: _key,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        CustomTextFieldWidget(
                          controller: userNameController,
                          hintText: 'User Name here',
                          maxLines: 1,
                          title: 'User Name',
                          validate: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Should Enter username';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 8),
                        CustomTextFieldWidget(
                          controller: motivationController,
                          hintText: 'One task at a time. One step closer.',
                          maxLines: 5,
                          title: 'Motivation Quote',
                          validate: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Should Enter Motivation Quote';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                // Spacer(),
                ConfirmButtonWidget(
                  confirmAction: () async {
                    if (_key.currentState!.validate()) {
                      Get.back(
                        result: {
                          'username': userNameController.text.trim(),
                          'MotivationQuote': motivationController.text.trim(),
                        },
                      );
                    }
                  },
                  labelText: 'Save Changes',
                  labelIcon: Icon(Icons.check, color: Color(0xFFFFFCFC)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
