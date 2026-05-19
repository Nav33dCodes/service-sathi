import 'package:flutter/material.dart';

class AppTheme {
  // Primary Colors (OLED000 Theme)
  static const Color backgroundDeepBlue = Color(0xFF000000); // OLED True Black
  static const Color cardWhite = Color(0xFF0D0D0D); // Premium dark gray cards
  static const Color emeraldGreen = Color(0xFF00FF9D); // Neon Emerald Accent
  static const Color emeraldGreenDark = Color(0xFF00BFA5); // Cyber Teal Accent
  
  // Secondary Colors
  static const Color lightBlue = Color(0xFF121212); // Slightly lighter black surface
  static const Color textDark = Color(0xFFE2E8F0); // Light text for cards (formerly dark text)
  static const Color textMuted = Color(0xFF94A3B8); // Muted grey text
  static const Color borderLight = Color(0x1AFFFFFF); // Translucent borders for cards

  // Text Colors
  static const Color textLight = Color(0xFFFFFFFF); // Pure White text
  
  // Custom Gradients
  static const LinearGradient emeraldGradient = LinearGradient(
    colors: [emeraldGreen, Color(0xFF00BFA5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Glassmorphic Colors
  static const Color cardBackgroundTranslucent = Color(0x0CFFFFFF); // Frosty white translucent
  static const Color borderTranslucent = Color(0x15FFFFFF); // Ultra-fine glass border
}
