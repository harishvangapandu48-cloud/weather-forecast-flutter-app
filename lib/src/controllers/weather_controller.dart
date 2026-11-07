import 'package:flutter/foundation.dart';
import '../models/city_location.dart';
import '../models/weather_model.dart';
import '../services/weather_api_service.dart';
import '../utils/constants.dart';

class WeatherController extends ChangeNotifier {
  final WeatherApiService _apiService;

  CityLocation _currentCity = const CityLocation(
    name: 'Bengaluru',
    country: 'India',
    latitude: 12.9716,
    longitude: 77.5946,
  );

  WeatherModel? _weatherData;
  bool _isLoading = false;
  String? _errorMessage;
  TemperatureUnit _unit = TemperatureUnit.celsius;

  WeatherController({WeatherApiService? apiService})
      : _apiService = apiService ?? WeatherApiService();

  CityLocation get currentCity => _currentCity;
  WeatherModel? get weatherData => _weatherData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  TemperatureUnit get unit => _unit;

  Future<void> initialize() async {
    await fetchWeatherForCity(_currentCity);
  }

  Future<void> fetchWeatherForCity(CityLocation city) async {
    _isLoading = true;
    _errorMessage = null;
    _currentCity = city;
    notifyListeners();

    try {
      final weather = await _apiService.fetchWeather(
        latitude: city.latitude,
        longitude: city.longitude,
        cityName: city.name,
        country: city.country,
      );
      _weatherData = weather;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _weatherData = WeatherModel.mock(cityName: city.name, country: city.country);
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await fetchWeatherForCity(_currentCity);
  }

  void toggleTemperatureUnit() {
    _unit = _unit == TemperatureUnit.celsius
        ? TemperatureUnit.fahrenheit
        : TemperatureUnit.celsius;
    notifyListeners();
  }

  void setTemperatureUnit(TemperatureUnit newUnit) {
    if (_unit != newUnit) {
      _unit = newUnit;
      notifyListeners();
    }
  }
}
