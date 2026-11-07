import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../utils/constants.dart';
import '../utils/weather_code_helper.dart';

class HourlyForecastView extends StatelessWidget {
  final List<HourlyForecast> hourly;
  final TemperatureUnit unit;

  const HourlyForecastView({
    super.key,
    required this.hourly,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    if (hourly.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            children: [
              Icon(Icons.access_time_rounded, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Text(
                'Hourly Forecast',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 135,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: hourly.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final item = hourly[index];
              final condition = WeatherCodeHelper.getInfo(item.weatherCode);

              return Container(
                width: 74,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white.withOpacity(0.18)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.formattedHour,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Icon(
                      condition.icon,
                      color: Colors.white,
                      size: 26,
                    ),
                    Text(
                      item.temperature.formatTemp(unit),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
