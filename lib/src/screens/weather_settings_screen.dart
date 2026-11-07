import 'package:flutter/material.dart';
import '../controllers/weather_controller.dart';
import '../models/city_location.dart';
import '../utils/constants.dart';

class WeatherSettingsScreen extends StatelessWidget {
  final WeatherController controller;

  const WeatherSettingsScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: const Color(0xFF0F172A),
          appBar: AppBar(
            backgroundColor: const Color(0xFF1E293B),
            elevation: 0,
            foregroundColor: Colors.white,
            title: const Text('Settings & Preferences'),
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _buildSectionTitle('Temperature Unit'),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    RadioListTile<TemperatureUnit>(
                      activeColor: Colors.lightBlueAccent,
                      title: const Text('Celsius (°C)', style: TextStyle(color: Colors.white)),
                      subtitle: const Text('Metric standard', style: TextStyle(color: Colors.white54)),
                      value: TemperatureUnit.celsius,
                      groupValue: controller.unit,
                      onChanged: (val) {
                        if (val != null) controller.setTemperatureUnit(val);
                      },
                    ),
                    Divider(color: Colors.white.withOpacity(0.08), height: 1),
                    RadioListTile<TemperatureUnit>(
                      activeColor: Colors.lightBlueAccent,
                      title: const Text('Fahrenheit (°F)', style: TextStyle(color: Colors.white)),
                      subtitle: const Text('Imperial standard', style: TextStyle(color: Colors.white54)),
                      value: TemperatureUnit.fahrenheit,
                      groupValue: controller.unit,
                      onChanged: (val) {
                        if (val != null) controller.setTemperatureUnit(val);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              _buildSectionTitle('Quick Select Cities'),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: CityLocation.popularCities.map((city) {
                  final isSelected = controller.currentCity.name == city.name;
                  return ChoiceChip(
                    label: Text(city.name),
                    selected: isSelected,
                    selectedColor: Colors.lightBlueAccent,
                    backgroundColor: const Color(0xFF1E293B),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.black87 : Colors.white,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        controller.fetchWeatherForCity(city);
                        Navigator.pop(context);
                      }
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 28),

              _buildSectionTitle('About Weather Forecast App'),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🌤️ Weather Forecast Flutter App',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Powered by Open-Meteo REST API & Flutter Material 3. Features clean architecture, responsive breakpoints, hourly & 7-day forecasts, and complete laboratory experiments 1–10.',
                      style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 4),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
