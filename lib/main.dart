import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'src/controllers/weather_controller.dart';
import 'src/screens/weather_details_screen.dart';
import 'src/screens/weather_home_screen.dart';
import 'src/screens/weather_settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  final controller = WeatherController();
  await controller.initialize();

  runApp(WeatherForecastApp(controller: controller));
}

class WeatherForecastApp extends StatelessWidget {
  final WeatherController controller;

  const WeatherForecastApp({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Forecast',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E88E5),
          brightness: Brightness.dark,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => WeatherHomeScreen(controller: controller),
        '/details': (context) => WeatherDetailsScreen(controller: controller),
        '/settings': (context) => WeatherSettingsScreen(controller: controller),
      },
    );
  }
}
