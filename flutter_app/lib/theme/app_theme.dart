import 'package:flutter/material.dart';

class AppTheme {
  // Primary Colors
  static const Color backgroundDeepBlue = Color(0xFF0A192F); // Deep Blue
  static const Color cardWhite = Color(0xFFFFFFFF); // White cards
  static const Color emeraldGreen = Color(0xFF00E676); // Emerald Green Accent
  static const Color emeraldGreenDark = Color(0xFF00C853);
  
  // Secondary Colors
  static const Color lightBlue = Color(0xFF112240); // Slightly lighter blue for dark elements
  static const Color textDark = Color(0xFF1E293B); // Dark text for white backgrounds
  static const Color textMuted = Color(0xFF94A3B8); // Muted grey text
  static const Color borderLight = Color(0xFFE2E8F0); // Light borders for white cards

  // Text Colors
  static const Color textLight = Color(0xFFF8FAFC); // White text for dark backgrounds
  
  // Custom Gradients
  static const LinearGradient emeraldGradient = LinearGradient(
    colors: [emeraldGreen, Color(0xFF00C853)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
