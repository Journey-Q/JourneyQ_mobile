import 'package:flutter/material.dart';

class AppTheme {
  // Primary colors
  static const Color primaryBlue = Color(0xFF0088cc);
  static const Color lightBlueBackground = Color(0xFFF8FAFC);
  
  // Gradient colors - updated to match your JourneyQ logo
  static const List<Color> gradientBlue = [
    Color(0xFF1E3A8A), // Dark blue from your logo
    Color(0xFF3B82F6), // Medium blue
    Color(0xFF06B6D4), // Cyan from your logo
  ];

  // Light Theme
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: MaterialColor(0xFF0088cc, {
      50: Color(0xFFE6F3FA),
      100: Color(0xFFCCE7F5),
      200: Color(0xFF99CFEB),
      300: Color(0xFF66B7E1),
      400: Color(0xFF339FD7),
      500: Color(0xFF0088cc),
      600: Color(0xFF006DA3),
      700: Color(0xFF00527A),
      800: Color(0xFF003752),
      900: Color(0xFF001C29),
    }),
    scaffoldBackgroundColor: Colors.white,
    
    colorScheme: ColorScheme.light(
      primary: primaryBlue,
      secondary: Color(0xFF33a3dd),
      surface: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.black,
    ),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: MaterialColor(0xFF0088cc, {
      50: Color(0xFFE6F3FA),
      100: Color(0xFFCCE7F5),
      200: Color(0xFF99CFEB),
      300: Color(0xFF66B7E1),
      400: Color(0xFF339FD7),
      500: Color(0xFF0088cc),
      600: Color(0xFF006DA3),
      700: Color(0xFF00527A),
      800: Color(0xFF003752),
      900: Color(0xFF001C29),
    }),
    colorScheme: ColorScheme.dark(
      primary: primaryBlue,
      secondary: Color(0xFF33a3dd),
      surface: Color(0xFF1E1E1E),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
    ),
  );

  // Gradient shader callback - updated to match your logo colors
  static ShaderCallback get gradientShader => (bounds) => LinearGradient(
    colors: gradientBlue,
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ).createShader(bounds);
}