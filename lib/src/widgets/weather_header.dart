import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controllers/weather_controller.dart';
import '../utils/constants.dart';

class WeatherHeader extends StatelessWidget {
  final WeatherController controller;
  final VoidCallback onSearchTap;
  final VoidCallback onSettingsTap;

  const WeatherHeader({
    super.key,
    required this.controller,
    required this.onSearchTap,
    required this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateStr = DateFormat('EEEE, MMM d').format(now);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Location & Date
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.white, size: 22),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      controller.currentCity.name,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Padding(
                padding: const EdgeInsets.only(left: 28),
                child: Text(
                  '${controller.currentCity.country} • $dateStr',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.85),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),

        // Action Buttons: Unit Toggle & Search
        Row(
          children: [
            // Unit Toggle Badge
            InkWell(
              onTap: controller.toggleTemperatureUnit,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Text(
                  controller.unit == TemperatureUnit.celsius ? '°C' : '°F',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Search Icon
            IconButton(
              icon: const Icon(Icons.search_rounded, color: Colors.white, size: 26),
              tooltip: 'Search City',
              onPressed: onSearchTap,
            ),

            // Settings / Details Icon
            IconButton(
              icon: const Icon(Icons.settings_outlined, color: Colors.white, size: 24),
              tooltip: 'Settings',
              onPressed: onSettingsTap,
            ),
          ],
        ),
      ],
    );
  }
}
