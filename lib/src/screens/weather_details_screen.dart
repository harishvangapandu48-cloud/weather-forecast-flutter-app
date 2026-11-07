import 'package:flutter/material.dart';
import '../controllers/weather_controller.dart';
import '../utils/constants.dart';
import '../utils/weather_code_helper.dart';

class WeatherDetailsScreen extends StatelessWidget {
  final WeatherController controller;

  const WeatherDetailsScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final weather = controller.weatherData;
    if (weather == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Atmospheric Metrics')),
        body: const Center(child: Text('No weather data available')),
      );
    }

    final condition = WeatherCodeHelper.getInfo(weather.weatherCode, isDay: weather.isDay);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        foregroundColor: Colors.white,
        title: Text('${controller.currentCity.name} Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top summary banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: condition.gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Icon(condition.icon, size: 54, color: Colors.white),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          condition.description,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Current: ${weather.temperature.formatTemp(controller.unit)} (Feels like ${weather.apparentTemperature.formatTemp(controller.unit)})',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Atmospheric Parameters',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Grid of Metrics
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.4,
              children: [
                _buildCard(
                  icon: Icons.water_drop,
                  title: 'Humidity',
                  value: '${weather.relativeHumidity}%',
                  subtitle: weather.relativeHumidity > 70 ? 'High moisture' : 'Comfortable',
                  iconColor: Colors.lightBlueAccent,
                ),
                _buildCard(
                  icon: Icons.air,
                  title: 'Wind Speed',
                  value: '${weather.windSpeed.toStringAsFixed(1)} km/h',
                  subtitle: weather.windSpeed > 20 ? 'Moderate breeze' : 'Light air',
                  iconColor: Colors.tealAccent,
                ),
                _buildCard(
                  icon: Icons.grain,
                  title: 'Precipitation',
                  value: '${weather.precipitation.toStringAsFixed(1)} mm',
                  subtitle: weather.precipitation > 0 ? 'Rainfall detected' : 'Dry conditions',
                  iconColor: Colors.blueAccent,
                ),
                _buildCard(
                  icon: weather.isDay ? Icons.wb_sunny : Icons.nightlight_round,
                  title: 'Solar Phase',
                  value: weather.isDay ? 'Daytime' : 'Nighttime',
                  subtitle: weather.isDay ? 'Sun above horizon' : 'Moon visible',
                  iconColor: Colors.amberAccent,
                ),
                _buildCard(
                  icon: Icons.thermostat,
                  title: 'Dew Point',
                  value: (weather.temperature - ((100 - weather.relativeHumidity) / 5))
                      .formatTemp(controller.unit),
                  subtitle: 'Calculated estimate',
                  iconColor: Colors.orangeAccent,
                ),
                _buildCard(
                  icon: Icons.speed,
                  title: 'Air Pressure',
                  value: '1013.2 hPa',
                  subtitle: 'Standard sea-level',
                  iconColor: Colors.purpleAccent,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(icon, color: iconColor, size: 20),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.white38, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
