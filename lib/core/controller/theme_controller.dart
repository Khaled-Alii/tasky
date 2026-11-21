import 'package:flutter/material.dart';
import 'package:to_do/core/constants/storage_key.dart';

import '../services/storage_manager.dart';

class ThemeController {
  static final ValueNotifier<ThemeMode> valueNotifier = ValueNotifier(
    ThemeMode.dark,
  );

  void init() {
    final isDarkMode = StorageManager().read(StorageKey.isDarkMode);
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
