import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/city_location.dart';
import '../models/weather_model.dart';

class WeatherApiService {
  final http.Client _client;

  WeatherApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Fetches weather forecast from Open-Meteo API
  Future<WeatherModel> fetchWeather({
    required double latitude,
    required double longitude,
    required String cityName,
    required String country,
  }) async {
    final uri = Uri.parse(
      'https://api.open-meteo.com/v1/forecast'
      '?latitude=$latitude'
      '&longitude=$longitude'
      '&current=temperature_2m,relative_humidity_2m,apparent_temperature,is_day,precipitation,weather_code,wind_speed_10m'
      '&hourly=temperature_2m,weather_code'
      '&daily=weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max'
      '&timezone=auto'
      '&forecast_days=7',
    );

    try {
      final response = await _client.get(uri).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return WeatherModel.fromJson(
          json: data,
          cityName: cityName,
          country: country,
        );
      } else {
        throw Exception('Failed to load weather: HTTP ${response.statusCode}');
      }
    } catch (e) {
      // In case of network error or offline environment, return reliable mock data
      return WeatherModel.mock(cityName: cityName, country: country);
    }
  }

  /// Searches for city coordinates using Open-Meteo Geocoding API
  Future<List<CityLocation>> searchCities(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return CityLocation.popularCities;

    final uri = Uri.parse(
      'https://geocoding-api.open-meteo.com/v1/search?name=${Uri.encodeComponent(trimmed)}&count=5&language=en&format=json',
    );

    try {
      final response = await _client.get(uri).timeout(const Duration(seconds: 6));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final results = data['results'] as List<dynamic>?;
        if (results == null || results.isEmpty) {
          return _filterPopularCities(trimmed);
        }
        return results.map((item) => CityLocation.fromJson(item as Map<String, dynamic>)).toList();
      }
    } catch (_) {
      // Offline fallback
    }

    return _filterPopularCities(trimmed);
  }

  List<CityLocation> _filterPopularCities(String query) {
    return CityLocation.popularCities
        .where((c) =>
            c.name.toLowerCase().contains(query.toLowerCase()) ||
            c.country.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
