import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../utils/constants.dart';
import '../utils/weather_code_helper.dart';

class DailyForecastView extends StatelessWidget {
  final List<DailyForecast> daily;
  final TemperatureUnit unit;

  const DailyForecastView({
    super.key,
    required this.daily,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    if (daily.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            children: [
              Icon(Icons.calendar_today_rounded, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Text(
                '7-Day Forecast',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.18)),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: daily.length,
            separatorBuilder: (_, __) => Divider(color: Colors.white.withOpacity(0.12)),
            itemBuilder: (context, index) {
              final day = daily[index];
              final condition = WeatherCodeHelper.getInfo(day.weatherCode);

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    // Day of week
                    SizedBox(
                      width: 70,
                      child: Text(
                        day.dayName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    // Rain chance indicator
                    SizedBox(
                      width: 50,
                      child: Row(
                        children: [
                          Icon(Icons.water_drop,
                              size: 14,
                              color: day.rainProbability > 30
                                  ? Colors.lightBlueAccent
                                  : Colors.white.withOpacity(0.4)),
                          const SizedBox(width: 2),
                          Text(
                            '${day.rainProbability}%',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.75),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Condition Icon
                    Icon(condition.icon, color: Colors.white, size: 24),
                    const SizedBox(width: 14),

                    // Min Temp
                    Text(
                      day.minTemp.formatTemp(unit),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    // Temperature Bar Visual
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        height: 5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          gradient: const LinearGradient(
                            colors: [Colors.lightBlueAccent, Colors.orangeAccent],
                          ),
                        ),
                      ),
                    ),

                    // Max Temp
                    Text(
                      day.maxTemp.formatTemp(unit),
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
