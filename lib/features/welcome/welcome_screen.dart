import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:to_do/core/services/storage_manager.dart';
import 'package:to_do/core/widgets/confirm_button_widget.dart';
import 'package:to_do/core/widgets/custom_text_field_widget.dart';

import '../../core/constants/storage_key.dart' show StorageKey;
import '../navigation/main_screen.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});

  final cont = TextEditingController();
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Form(
        key: _key,
        child: Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 16,
              children: [
                Image(
                  image: AssetImage('assets/icon.png'),
                  width: 42,
                  height: 42,
                ),
                Text(
                  'Tasky',
                  style: Theme.of(
                    context,
                  ).textTheme.displayLarge!.copyWith(fontSize: 28),
                ),
              ],
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Welcome To Tasky',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyLarge!.copyWith(fontSize: 24),
                                ),
                                SizedBox(width: 8),
                                SvgPicture.asset(
                                  'assets/hand.svg',
                                  height: 28,
                                  width: 28,
                                ),
                              ],
                            ),
                            Text(
                              'Your productivity journey starts here.',
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                            SizedBox(height: 24),
                            SvgPicture.asset(
                              'assets/pana.svg',
                              width: 215,
                              height: 205,
                            ),
                            SizedBox(height: 28),

                            CustomTextFieldWidget(
                              controller: cont,
                              hintText: "e.g. Sarah Khalid",
                              title: 'Full Name',
                              validate: (String? v) {
                                if (v == null || v.trim().isEmpty) {
                                  return 'invalid name';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24),
                      ConfirmButtonWidget(
                        confirmAction: () async {
                          if (_key.currentState!.validate()) {
                            await StorageManager().write(StorageKey.isFirstTime, false);
                            await StorageManager().write(
                              StorageKey.userName,
                              cont.text.trim(),
                            );
                            Get.off(() => MainScreen());
                          }
                        },
                        labelText: "Let’s Get Started",
                        labelIcon: null,
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      //   child: ElevatedButton(
                      //     onPressed: () {
                      //       if (!_key.currentState!.validate()) {
                      //         return;
                      //       }
                      //       StorageManager().write('isFirstTime', false);
                      //       StorageManager().write('username', cont.text.trim());
                      //       print(
                      //         'is that is first time? ${StorageManager().read('isFirstTime')}',
                      //       );
                      //       Get.off(() => MainScreen());
                      //     },
                      //     style: ElevatedButton.styleFrom(
                      //       foregroundColor: Color(0xFFFFFCFC),
                      //       backgroundColor: Color(0xFF14A662),
                      //       fixedSize: Size(MediaQuery.of(context).size.width, 40),
                      //     ),
                      //     child: Text(),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
