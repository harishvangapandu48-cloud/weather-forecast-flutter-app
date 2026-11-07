import 'package:flutter/material.dart';
import '../models/city_location.dart';
import '../services/weather_api_service.dart';

class CitySearchDelegate extends SearchDelegate<CityLocation?> {
  final WeatherApiService _apiService;

  CitySearchDelegate({WeatherApiService? apiService})
      : _apiService = apiService ?? WeatherApiService();

  @override
  String get searchFieldLabel => 'Search city (e.g. Tokyo, London)...';

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E293B),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.white60),
        border: InputBorder.none,
      ),
      scaffoldBackgroundColor: const Color(0xFF0F172A),
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear, color: Colors.white70),
          onPressed: () {
            query = '';
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.white),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    return FutureBuilder<List<CityLocation>>(
      future: _apiService.searchCities(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.lightBlueAccent),
          );
        }

        final cities = snapshot.data ?? [];
        if (cities.isEmpty) {
          return Center(
            child: Text(
              'No cities found matching "$query"',
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
          );
        }

        return ListView.separated(
          itemCount: cities.length,
          separatorBuilder: (_, __) =>
              Divider(color: Colors.white.withOpacity(0.1), height: 1),
          itemBuilder: (context, index) {
            final city = cities[index];
            return ListTile(
              leading: const Icon(Icons.location_city, color: Colors.lightBlueAccent),
              title: Text(
                city.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                city.displayName,
                style: const TextStyle(color: Colors.white60),
              ),
              trailing: const Icon(Icons.north_west, color: Colors.white38, size: 18),
              onTap: () {
                close(context, city);
              },
            );
          },
        );
      },
    );
  }
}
