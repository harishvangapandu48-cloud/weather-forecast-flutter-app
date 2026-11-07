import 'package:flutter/material.dart';

/// Application colors, gradients, and typography constants
class AppColors {
  // Primary Gradient (Day / Clear)
  static const Color primaryBlue = Color(0xFF1E88E5);
  static const Color lightBlue = Color(0xFF64B5F6);
  static const Color darkBlue = Color(0xFF0D47A1);

  // Backgrounds
  static const Color bgDark = Color(0xFF0F172A);
  static const Color bgDarkCard = Color(0xFF1E293B);
  static const Color bgLight = Color(0xFFF0F4F8);
  static const Color bgLightCard = Color(0xFFFFFFFF);

  // Accent & Conditions
  static const Color sunnyGold = Color(0xFFFFA000);
  static const Color cloudGrey = Color(0xFF90A4AE);
  static const Color rainBlue = Color(0xFF0288D1);
  static const Color snowCyan = Color(0xFF80DEEA);
  static const Color thunderPurple = Color(0xFF7E57C2);

  // Glassmorphism card overlay
  static const Color glassWhite = Color(0x22FFFFFF);
  static const Color glassBorder = Color(0x33FFFFFF);

  // Text colors
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
}

/// Temperature Unit configuration
enum TemperatureUnit {
  celsius,
  fahrenheit;

  String get symbol => this == TemperatureUnit.celsius ? '°C' : '°F';
}

/// Helper extension to convert temperatures
extension TemperatureExtension on double {
  double toFahrenheit() => (this * 9 / 5) + 32;
  double toCelsius() => (this - 32) * 5 / 9;

  String formatTemp(TemperatureUnit unit) {
    if (unit == TemperatureUnit.fahrenheit) {
      return '${toFahrenheit().round()}°F';
    }
    return '${round()}°C';
  }
}
