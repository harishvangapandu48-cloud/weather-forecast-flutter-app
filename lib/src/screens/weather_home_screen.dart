import 'package:flutter/material.dart';
import '../controllers/weather_controller.dart';
import '../models/city_location.dart';
import '../utils/weather_code_helper.dart';
import '../widgets/city_search_delegate.dart';
import '../widgets/current_weather_card.dart';
import '../widgets/daily_forecast_view.dart';
import '../widgets/hourly_forecast_view.dart';
import '../widgets/weather_header.dart';
import '../widgets/weather_metric_card.dart';

class WeatherHomeScreen extends StatelessWidget {
  final WeatherController controller;

  const WeatherHomeScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final weather = controller.weatherData;
        final conditionInfo = weather != null
            ? WeatherCodeHelper.getInfo(weather.weatherCode, isDay: weather.isDay)
            : WeatherCodeHelper.getInfo(0);

        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: conditionInfo.gradientColors,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: controller.isLoading && weather == null
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                  : RefreshIndicator(
                      color: Colors.white,
                      backgroundColor: conditionInfo.gradientColors.first,
                      onRefresh: controller.refresh,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final isWide = constraints.maxWidth >= 750;

                          return SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            child: Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 1000),
                                child: Column(
                                  children: [
                                    WeatherHeader(
                                      controller: controller,
                                      onSearchTap: () async {
                                        final selected = await showSearch<CityLocation?>(
                                          context: context,
                                          delegate: CitySearchDelegate(),
                                        );
                                        if (selected != null) {
                                          controller.fetchWeatherForCity(selected);
                                        }
                                      },
                                      onSettingsTap: () {
                                        Navigator.pushNamed(context, '/settings');
                                      },
                                    ),
                                    const SizedBox(height: 20),

                                    if (controller.isLoading)
                                      const Padding(
                                        padding: EdgeInsets.symmetric(vertical: 8),
                                        child: LinearProgressIndicator(
                                          color: Colors.white,
                                          backgroundColor: Colors.white24,
                                        ),
                                      ),

                                    if (weather != null) ...[
                                      if (isWide)
                                        // Tablet & Desktop Responsive Split-View
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              flex: 5,
                                              child: Column(
                                                children: [
                                                  CurrentWeatherCard(
                                                    weather: weather,
                                                    unit: controller.unit,
                                                  ),
                                                  const SizedBox(height: 16),
                                                  WeatherMetricCard(weather: weather),
                                                  const SizedBox(height: 16),
                                                  _buildDetailsButton(context),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 24),
                                            Expanded(
                                              flex: 6,
                                              child: Column(
                                                children: [
                                                  HourlyForecastView(
                                                    hourly: weather.hourly,
                                                    unit: controller.unit,
                                                  ),
                                                  const SizedBox(height: 20),
                                                  DailyForecastView(
                                                    daily: weather.daily,
                                                    unit: controller.unit,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      else
                                        // Mobile View (Vertical Flow)
                                        Column(
                                          children: [
                                            CurrentWeatherCard(
                                              weather: weather,
                                              unit: controller.unit,
                                            ),
                                            const SizedBox(height: 16),
                                            WeatherMetricCard(weather: weather),
                                            const SizedBox(height: 16),
                                            _buildDetailsButton(context),
                                            const SizedBox(height: 20),
                                            HourlyForecastView(
                                              hourly: weather.hourly,
                                              unit: controller.unit,
                                            ),
                                            const SizedBox(height: 20),
                                            DailyForecastView(
                                              daily: weather.daily,
                                              unit: controller.unit,
                                            ),
                                          ],
                                        ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailsButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: BorderSide(color: Colors.white.withOpacity(0.3)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/details');
        },
        icon: const Icon(Icons.analytics_outlined, size: 20),
        label: const Text(
          'View Detailed Atmosphere Metrics',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ),
    );
  }
}
