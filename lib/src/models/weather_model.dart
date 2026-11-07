import 'package:intl/intl.dart';

class HourlyForecast {
  final DateTime time;
  final double temperature;
  final int weatherCode;

  const HourlyForecast({
    required this.time,
    required this.temperature,
    required this.weatherCode,
  });

  String get formattedHour => DateFormat('h a').format(time);
}

class DailyForecast {
  final DateTime date;
  final double minTemp;
  final double maxTemp;
  final int weatherCode;
  final int rainProbability;

  const DailyForecast({
    required this.date,
    required this.minTemp,
    required this.maxTemp,
    required this.weatherCode,
    required this.rainProbability,
  });

  String get dayName {
    final now = DateTime.now();
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return 'Today';
    }
    return DateFormat('EEE').format(date);
  }
}

class WeatherModel {
  final String cityName;
  final String country;
  final double temperature;
  final double apparentTemperature;
  final int relativeHumidity;
  final double windSpeed;
  final double precipitation;
  final int weatherCode;
  final bool isDay;
  final DateTime lastUpdated;
  final List<HourlyForecast> hourly;
  final List<DailyForecast> daily;

  const WeatherModel({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.apparentTemperature,
    required this.relativeHumidity,
    required this.windSpeed,
    required this.precipitation,
    required this.weatherCode,
    required this.isDay,
    required this.lastUpdated,
    required this.hourly,
    required this.daily,
  });

  factory WeatherModel.fromJson({
    required Map<String, dynamic> json,
    required String cityName,
    required String country,
  }) {
    final current = json['current'] as Map<String, dynamic>? ?? {};
    final hourlyJson = json['hourly'] as Map<String, dynamic>? ?? {};
    final dailyJson = json['daily'] as Map<String, dynamic>? ?? {};

    // Parse Hourly (next 24 hours)
    final hourlyTimes = (hourlyJson['time'] as List<dynamic>? ?? []).cast<String>();
    final hourlyTemps = (hourlyJson['temperature_2m'] as List<dynamic>? ?? [])
        .map((e) => (e as num).toDouble())
        .toList();
    final hourlyCodes = (hourlyJson['weather_code'] as List<dynamic>? ?? [])
        .map((e) => (e as num).toInt())
        .toList();

    final List<HourlyForecast> hourlyList = [];
    final now = DateTime.now();
    for (int i = 0; i < hourlyTimes.length && hourlyList.length < 24; i++) {
      final parsedTime = DateTime.tryParse(hourlyTimes[i]) ?? now;
      hourlyList.add(
        HourlyForecast(
          time: parsedTime,
          temperature: i < hourlyTemps.length ? hourlyTemps[i] : 20.0,
          weatherCode: i < hourlyCodes.length ? hourlyCodes[i] : 0,
        ),
      );
    }

    // Parse Daily (up to 7 days)
    final dailyTimes = (dailyJson['time'] as List<dynamic>? ?? []).cast<String>();
    final dailyMaxTemps = (dailyJson['temperature_2m_max'] as List<dynamic>? ?? [])
        .map((e) => (e as num).toDouble())
        .toList();
    final dailyMinTemps = (dailyJson['temperature_2m_min'] as List<dynamic>? ?? [])
        .map((e) => (e as num).toDouble())
        .toList();
    final dailyCodes = (dailyJson['weather_code'] as List<dynamic>? ?? [])
        .map((e) => (e as num).toInt())
        .toList();
    final dailyRainProb =
        (dailyJson['precipitation_probability_max'] as List<dynamic>? ?? [])
            .map((e) => (e as num).toInt())
            .toList();

    final List<DailyForecast> dailyList = [];
    for (int i = 0; i < dailyTimes.length && i < 7; i++) {
      dailyList.add(
        DailyForecast(
          date: DateTime.tryParse(dailyTimes[i]) ?? now.add(Duration(days: i)),
          maxTemp: i < dailyMaxTemps.length ? dailyMaxTemps[i] : 25.0,
          minTemp: i < dailyMinTemps.length ? dailyMinTemps[i] : 18.0,
          weatherCode: i < dailyCodes.length ? dailyCodes[i] : 0,
          rainProbability: i < dailyRainProb.length ? dailyRainProb[i] : 10,
        ),
      );
    }

    return WeatherModel(
      cityName: cityName,
      country: country,
      temperature: (current['temperature_2m'] as num?)?.toDouble() ?? 22.0,
      apparentTemperature:
          (current['apparent_temperature'] as num?)?.toDouble() ?? 22.0,
      relativeHumidity: (current['relative_humidity_2m'] as num?)?.toInt() ?? 60,
      windSpeed: (current['wind_speed_10m'] as num?)?.toDouble() ?? 8.5,
      precipitation: (current['precipitation'] as num?)?.toDouble() ?? 0.0,
      weatherCode: (current['weather_code'] as num?)?.toInt() ?? 0,
      isDay: ((current['is_day'] as num?)?.toInt() ?? 1) == 1,
      lastUpdated: DateTime.tryParse(current['time'] as String? ?? '') ?? now,
      hourly: hourlyList,
      daily: dailyList,
    );
  }

  /// High quality mock weather data for testing or offline fallback
  factory WeatherModel.mock({
    String cityName = 'Bengaluru',
    String country = 'India',
  }) {
    final now = DateTime.now();
    return WeatherModel(
      cityName: cityName,
      country: country,
      temperature: 24.5,
      apparentTemperature: 25.0,
      relativeHumidity: 65,
      windSpeed: 11.2,
      precipitation: 0.0,
      weatherCode: 1, // Partly cloudy
      isDay: true,
      lastUpdated: now,
      hourly: List.generate(
        24,
        (index) => HourlyForecast(
          time: now.add(Duration(hours: index)),
          temperature: 22.0 + (index % 5),
          weatherCode: index % 3 == 0 ? 0 : (index % 3 == 1 ? 1 : 2),
        ),
      ),
      daily: List.generate(
        7,
        (index) => DailyForecast(
          date: now.add(Duration(days: index)),
          minTemp: 18.0 + (index % 3),
          maxTemp: 28.0 + (index % 4),
          weatherCode: (index % 4 == 0) ? 0 : (index % 4 == 1 ? 2 : 61),
          rainProbability: 10 + (index * 12) % 80,
        ),
      ),
    );
  }
}
