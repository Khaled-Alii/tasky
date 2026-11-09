import 'package:flutter/material.dart';

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  //scaffold
  scaffoldBackgroundColor: Color(0xFF181818),

  colorScheme: ColorScheme.dark(primaryContainer: Color(0xFF282828)),

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
        color: Color(0xFF6E6E6E), // Dark theme border color
        width: 2.0,
      );
    }),
  ),
  //list tile
  listTileTheme: ListTileThemeData(
    //title
    titleTextStyle: TextStyle(
      color: const Color(0xFFFFFCFC),
      fontSize: 16,
      fontWeight: FontWeight.w400,
      decorationColor: const Color(0xFFA0A0A0),
    ),
    //subtitle
    subtitleTextStyle: const TextStyle(
      color: Color(0xFFC6C6C6),
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    //trailing
  ),

  //appbar
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF181818),
    foregroundColor: Color(0xFFFFFCFC),
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w400,
      color: Color(0xFFFFFCFC),
    ),
    centerTitle: true,
  ),

  //elevated button
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF15B86C),
      foregroundColor: Color(0xFFFFFCFC),
    ),
  ),

  //switch
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

  //card theme
  cardTheme: CardThemeData(elevation: 5, color: const Color(0xFF282828)),

  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF181818),
    selectedItemColor: Color(0xFF15B86C),
    unselectedItemColor: Color(0xFFC6C6C6),
    type: BottomNavigationBarType.fixed,
  ),

  //text
  textTheme: TextTheme(
    displaySmall: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 14,
      color: Color(0xFFFFFCFC),
    ),
    displayMedium: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 16,
      color: Color(0xFFFFFCFC),
    ),
    displayLarge: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 20,
      color: Color(0xFFFFFCFC),
    ),
    labelMedium: TextStyle(
      fontWeight: FontWeight.w400,
      color: Colors.white,
      fontSize: 16,
    ),
    bodySmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: const Color(0xFFA0A0A0),
      decoration: TextDecoration.lineThrough,
      decorationColor: const Color(0xFFA0A0A0),
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: const Color(0xFFFFFCFC),
      decoration: TextDecoration.none,
      decorationColor: const Color(0xFFA0A0A0),
    ),
    headlineSmall: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: const Color(0xFFFFFCFC),
      decoration: TextDecoration.none,
      decorationColor: const Color(0xFFA0A0A0),
    ),
    headlineMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w400,
      color: const Color(0xFFA0A0A0),
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
    hintStyle: TextStyle(fontWeight: FontWeight.w400, color: Color(0xFF6D6D6D)),
    filled: true,
    fillColor: Color(0xFF282828),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: Color(0xFF15B86C),
    linearTrackColor: Color(0xFF6D6D6D),
    circularTrackColor: Color(0xFF6D6D6D),
  ),
  iconTheme: IconThemeData(color: Color(0xFFFFFCFC)),

  dividerColor: Color(0xFF6E6E6E),

  splashFactory: NoSplash.splashFactory,

  popupMenuTheme: PopupMenuThemeData(
    color: Color(0xFF181818),
    elevation: 2,
    shadowColor: Color(0xFF15B86C),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(color: Color(0xFF15B86C), width: 0.5),
    ),
    textStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    ),
  ),
);
