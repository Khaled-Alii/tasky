import 'package:flutter/material.dart';

import '../services/storage_manager.dart';

class ThemeController {
  static final ValueNotifier<ThemeMode> valueNotifier = ValueNotifier(
    ThemeMode.dark,
  );

  void init() {
    final isDarkMode = StorageManager().read('isDarkMode');
    valueNotifier.value = isDarkMode == null
        ? ThemeMode.dark
        : (isDarkMode ? ThemeMode.dark : ThemeMode.light);
  }

  void toggle() {
    valueNotifier.value = valueNotifier.value == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
  }

  static bool isDark() => valueNotifier.value == ThemeMode.dark;
}
