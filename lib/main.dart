import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do/core/controller/theme_controller.dart';
import 'package:to_do/core/services/storage_manager.dart';
import 'package:to_do/screens/main_screen.dart';
import 'package:to_do/screens/welcome_screen.dart';
import 'core/theme/dark_theme.dart';
import 'core/theme/light_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageManager().init();
  final bool isFirstTime = StorageManager().read('isFirstTime') ?? true;
  ThemeController().init();
  print('is that is first time? $isFirstTime');
  runApp(MyApp(isFirstTime: isFirstTime));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isFirstTime});

  final bool isFirstTime;

  @override
  Widget build(BuildContext context) {
    final value = ThemeController.valueNotifier;
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: value,
      builder: (BuildContext context, ThemeMode value, Widget? child) {
        return GetMaterialApp(
          darkTheme: darkTheme,
          theme: lightTheme,
          themeMode: value,
          home: isFirstTime ? WelcomeScreen() : MainScreen(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
