import 'package:flutter/material.dart';

class WeatherConditionInfo {
  final String description;
  final IconData icon;
  final List<Color> gradientColors;

  const WeatherConditionInfo({
    required this.description,
    required this.icon,
    required this.gradientColors,
  });
}

class WeatherCodeHelper {
  /// Interprets WMO Weather interpretation codes
  static WeatherConditionInfo getInfo(int code, {bool isDay = true}) {
    switch (code) {
      case 0:
        return WeatherConditionInfo(
          description: isDay ? 'Clear Sky' : 'Clear Night',
          icon: isDay ? Icons.wb_sunny_rounded : Icons.nightlight_round,
          gradientColors: isDay
              ? [const Color(0xFF1E88E5), const Color(0xFF64B5F6)]
              : [const Color(0xFF0D1B2A), const Color(0xFF1B263B)],
        );
      case 1:
      case 2:
        return WeatherConditionInfo(
          description: 'Partly Cloudy',
          icon: isDay ? Icons.wb_cloudy_rounded : Icons.nights_stay_rounded,
          gradientColors: isDay
              ? [const Color(0xFF2196F3), const Color(0xFF90CAF9)]
              : [const Color(0xFF111827), const Color(0xFF1F2937)],
        );
      case 3:
        return WeatherConditionInfo(
          description: 'Overcast',
          icon: Icons.cloud_rounded,
          gradientColors: isDay
              ? [const Color(0xFF455A64), const Color(0xFF90A4AE)]
              : [const Color(0xFF1E293B), const Color(0xFF334155)],
        );
      case 45:
      case 48:
        return const WeatherConditionInfo(
          description: 'Foggy',
          icon: Icons.foggy,
          gradientColors: [Color(0xFF546E7A), Color(0xFF78909C)],
        );
      case 51:
      case 53:
      case 55:
        return const WeatherConditionInfo(
          description: 'Drizzle',
          icon: Icons.grain_rounded,
          gradientColors: [Color(0xFF37474F), Color(0xFF607D8B)],
        );
      case 61:
      case 63:
      case 65:
        return const WeatherConditionInfo(
          description: 'Rain',
          icon: Icons.water_drop_rounded,
          gradientColors: [Color(0xFF1976D2), Color(0xFF0D47A1)],
        );
      case 71:
      case 73:
      case 75:
      case 77:
        return const WeatherConditionInfo(
          description: 'Snow',
          icon: Icons.ac_unit_rounded,
          gradientColors: [Color(0xFF4A6572), Color(0xFF344955)],
        );
      case 80:
      case 81:
      case 82:
        return const WeatherConditionInfo(
          description: 'Rain Showers',
          icon: Icons.thunderstorm_rounded,
          gradientColors: [Color(0xFF1565C0), Color(0xFF283593)],
        );
      case 85:
      case 86:
        return const WeatherConditionInfo(
          description: 'Snow Showers',
          icon: Icons.severe_cold_rounded,
          gradientColors: [Color(0xFF37474F), Color(0xFF455A64)],
        );
      case 95:
      case 96:
      case 99:
        return const WeatherConditionInfo(
          description: 'Thunderstorm',
          icon: Icons.bolt_rounded,
          gradientColors: [Color(0xFF311B92), Color(0xFF512DA8)],
        );
      default:
        return WeatherConditionInfo(
          description: 'Partly Cloudy',
          icon: Icons.cloud_queue_rounded,
          gradientColors: [const Color(0xFF1E88E5), const Color(0xFF64B5F6)],
        );
    }
  }
}
