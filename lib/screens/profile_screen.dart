import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:to_do/core/controller/theme_controller.dart';
import 'package:to_do/core/widgets/custom_alert_dialog_widget.dart';
import 'package:to_do/screens/user_details_screen.dart';
import 'package:to_do/screens/welcome_screen.dart';
import '../core/services/storage_manager.dart';
import '../core/services/user_details_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final userName = ''.obs;
  final motivationQuote = ''.obs;
  final RxBool isDarkMode = ThemeController.isDark().obs;
  final profilePicture = Rxn<File>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserInfo();
    // getThemeMode();
    getUserPic();
  }

  void getUserInfo() {
    userName.value = UserDetailsService(StorageManager()).getUserName();
    motivationQuote.value = UserDetailsService(
      StorageManager(),
    ).getUserMotivationQuote();
  }

  void getUserPic() {
    final path = StorageManager().read('profile_picture');
    if (path != null && File(path).existsSync()) {
      profilePicture.value = File(path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                'My Profile',
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.transparent,
                      child: ClipOval(
                        child: Obx(() {
                          if (profilePicture.value == null) {
                            return Image.asset(
                              'assets/me.jpg',
                              fit: BoxFit.cover,
                              height: 90,
                              width: 90,
                            );
                          }
                          return Image.file(
                            profilePicture.value!,
                            fit: BoxFit.cover,
                            height: 90,
                            width: 90,
                          );
                        }),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => showDialogSource(context),
                      child: Container(
                        height: 34,
                        width: 34,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                        child: Icon(Icons.camera_alt),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Align(
              alignment: Alignment.center,
              child: Obx(() {
                return Text(
                  userName.value,
                  style: Theme.of(context).textTheme.displayLarge,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                );
              }),
            ),
            Align(
              alignment: Alignment.center,
              child: Obx(() {
                return Text(
                  motivationQuote.value,
                  style: Theme.of(context).textTheme.displayMedium,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                );
              }),
            ),
            SizedBox(height: 24),
            Text(
              'Profile Info',
              style: Theme.of(context).textTheme.displayLarge,
            ),

            ListTile(
              onTap: () async {
                var result = await Get.to(
                  () => UserDetailsScreen(),
                  transition: Transition.circularReveal,
                  duration: Duration(seconds: 1),
                );
                if (result == null) return;
                result = result as Map<String, String>;
                userName.value = result['username']!;
                motivationQuote.value = result['MotivationQuote']!;
                await UserDetailsService(
                  StorageManager(),
                ).setUserName(result['username']!);
                await UserDetailsService(
                  StorageManager(),
                ).setUserMotivationQuote(result['MotivationQuote']!);
              },
              contentPadding: EdgeInsets.only(left: 0),
              leading: Icon(Icons.person_outline),
              title: Text('User Details'),
              trailing: Icon(Icons.arrow_forward),
            ),

            Divider(),
            ListTile(
              contentPadding: EdgeInsets.only(left: 0),
              leading: Icon(Icons.dark_mode_outlined),
              title: Text('Dark Mode'),
              trailing: Obx(() {
                return Switch(
                  value: isDarkMode.value,
                  onChanged: (value) async {
                    isDarkMode.toggle();
                    ThemeController().toggle();
                    StorageManager().write('isDarkMode', isDarkMode.value);
                  },
                );
              }),
            ),
            Divider(),
            ListTile(
              contentPadding: const EdgeInsets.only(left: 0),
              leading: const Icon(Icons.logout),
              title: Text('Log Out'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () => CustomAlertDialogWidget.show(
                context: context,
                title: 'Log Out',
                content: 'Are you sure you want to log out?',
                actionText: 'Log Out',
                action: _logout,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logout() async {
    // Erase all user data from default storage and reset first-time flag
    await StorageManager().erase();
    await StorageManager().write('isFirstTime', true);

    // Clear the whole navigation stack and redirect to WelcomeScreen
    Get.offAll(() => WelcomeScreen());
  }

  void showDialogSource(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Select image source'),
          children: [
            SimpleDialogOption(
              onPressed: () async {
                Get.back();
                final picker = await ImagePicker().pickImage(
                  source: ImageSource.camera,
                );
                await savePicture(picker);
              },
              child: Row(
                children: [
                  Icon(Icons.camera_alt),
                  SizedBox(width: 8),
                  Text('Camera'),
                ],
              ),
            ),
            SimpleDialogOption(
              onPressed: () async {
                Get.back();
                final picker = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                );
                await savePicture(picker);
              },
              child: Row(
                children: [
                  Icon(Icons.add_photo_alternate_outlined),
                  SizedBox(width: 8),
                  Text('Gallery'),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> savePicture(XFile? picker) async {
    if (picker != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final newPath = '${appDir.path}/${picker.name}';
      await File(picker.path).copy(newPath);
      profilePicture.value = File(newPath);
      StorageManager().write('profile_picture', newPath);
    }
  }
}
