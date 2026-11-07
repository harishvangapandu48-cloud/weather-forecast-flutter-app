import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../utils/constants.dart';
import '../utils/weather_code_helper.dart';

class CurrentWeatherCard extends StatelessWidget {
  final WeatherModel weather;
  final TemperatureUnit unit;

  const CurrentWeatherCard({
    super.key,
    required this.weather,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final condition = WeatherCodeHelper.getInfo(
      weather.weatherCode,
      isDay: weather.isDay,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.25), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Weather Icon & Temperature Display
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                condition.icon,
                size: 64,
                color: Colors.white,
              ),
              const SizedBox(width: 16),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        weather.temperature.formatTemp(unit),
                        style: const TextStyle(
                          fontSize: 54,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                          height: 1.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Feels like ${weather.apparentTemperature.formatTemp(unit)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.85),
                        fontWeight: FontWeight.w400,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Condition Name Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              condition.description,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
