import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,

  scaffoldBackgroundColor: Color(0xFFF6F7F9),

  colorScheme: ColorScheme.light(primaryContainer: Color(0xFFFFFFFF)),

  checkboxTheme: CheckboxThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    fillColor: WidgetStateProperty.resolveWith<Color>((states) {
      if (states.contains(WidgetState.selected)) {
        return const Color(0xFF15B86C); // Active fill color
      }
      return Colors.transparent; // Unchecked background
    }),
    side: WidgetStateBorderSide.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return const BorderSide(color: Color(0xFF15B86C), width: 2.0);
      }
      return const BorderSide(
        color: Color(0xFFD1DAD6), // Light theme border color
        width: 2.0,
      );
    }),
  ),

  listTileTheme: ListTileThemeData(
    titleTextStyle: TextStyle(
      color: const Color(0xFF161F1B),
      fontSize: 16,
      fontWeight: FontWeight.w400,
      decoration: TextDecoration.none,
      decorationColor: const Color(0xFFA0A0A0),
    ),
    subtitleTextStyle: const TextStyle(
      color: Color(0xFF3A4640),
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFFF6F7F9),
    foregroundColor: Color(0xFF161F1B),
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w400,
      color: Color(0xFF161F1B),
    ),
    centerTitle: true,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF15B86C),
      foregroundColor: Color(0xFFFFFCFC),
    ),
  ),
  switchTheme: SwitchThemeData(
    trackColor: WidgetStateProperty.resolveWith((state) {
      if (state.contains(WidgetState.selected)) {
        return Color(0xFF15B86C);
      }
      return Colors.transparent;
    }),
    thumbColor: WidgetStateProperty.resolveWith((state) {
      if (state.contains(WidgetState.selected)) {
        return Color(0xFFFFFCFC);
      }
      return Color(0xFF9E9E9E);
    }),
  ),

  cardTheme: CardThemeData(elevation: 5, color: const Color(0xFFFFFFFF)),

  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Color(0xFFF6F7F9),
    selectedItemColor: Color(0xFF15B86C),
    unselectedItemColor: Color(0xFF3A4640),
    type: BottomNavigationBarType.fixed,
  ),

  //text
  textTheme: TextTheme(
    displaySmall: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 14,
      color: Color(0xFF161F1B),
    ),
    displayMedium: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 16,
      color: Color(0xFF161F1B),
    ),
    displayLarge: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 20,
      color: Color(0xFF161F1B),
    ),
    labelMedium: TextStyle(
      fontWeight: FontWeight.w400,
      color: Colors.black,
      fontSize: 16,
    ),
    bodySmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: const Color(0xFF6A6A6A),
      decoration: TextDecoration.lineThrough,
      decorationColor: const Color(0xFFA0A0A0),
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: const Color(0xFF161F1B),
      decoration: TextDecoration.none,
      decorationColor: const Color(0xFFA0A0A0),
    ),
    headlineSmall: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: const Color(0xFF161F1B),
      decoration: TextDecoration.none,
      decorationColor: const Color(0xFFA0A0A0),
    ),
    headlineMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w400,
      color: const Color(0xFF6A6A6A),
      decoration: TextDecoration.lineThrough,
      decorationColor: const Color(0xFFA0A0A0),
    ),
    labelSmall: TextStyle(
      color: Color(0xFFC6C6C6),
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
  ),

  //text form
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: TextStyle(fontWeight: FontWeight.w400, color: Color(0xFFD1DAD6)),
    filled: true,
    fillColor: Colors.white,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: Colors.black, width: 0.5),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: Colors.black, width: 0.5),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: Colors.black, width: 0.5),
    ),
  ),

  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: Color(0xFF15B86C),
    linearTrackColor: Color(0xFF9E9E9E),
    circularTrackColor: Color(0xFF9E9E9E),
  ),
  iconTheme: IconThemeData(color: Color(0xFF161F1B)),

  dividerColor: Color(0xFFD1DAD6),

  splashFactory: NoSplash.splashFactory,
  popupMenuTheme: PopupMenuThemeData(
    color: Color(0xFFF6F7F9),
    elevation: 2,
    shadowColor: Color(0xFF15B86C),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(color: Color(0xFF15B86C), width: 0.5),
    ),
    textStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
  ),
);
