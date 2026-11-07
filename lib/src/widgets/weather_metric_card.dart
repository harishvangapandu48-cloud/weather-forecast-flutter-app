import 'package:flutter/material.dart';
import '../models/weather_model.dart';

class WeatherMetricCard extends StatelessWidget {
  final WeatherModel weather;

  const WeatherMetricCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildMetric(
            icon: Icons.water_drop_outlined,
            label: 'Humidity',
            value: '${weather.relativeHumidity}%',
          ),
          _divider(),
          _buildMetric(
            icon: Icons.air_rounded,
            label: 'Wind',
            value: '${weather.windSpeed.toStringAsFixed(1)} km/h',
          ),
          _divider(),
          _buildMetric(
            icon: Icons.umbrella_outlined,
            label: 'Precipitation',
            value: '${weather.precipitation.toStringAsFixed(1)} mm',
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 40,
      color: Colors.white.withOpacity(0.25),
    );
  }

  Widget _buildMetric({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.75),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
