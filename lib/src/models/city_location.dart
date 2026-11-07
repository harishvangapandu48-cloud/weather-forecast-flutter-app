class CityLocation {
  final String name;
  final String country;
  final double latitude;
  final double longitude;
  final String? admin1;

  const CityLocation({
    required this.name,
    required this.country,
    required this.latitude,
    required this.longitude,
    this.admin1,
  });

  String get displayName =>
      admin1 != null && admin1!.isNotEmpty ? '$name, $admin1, $country' : '$name, $country';

  factory CityLocation.fromJson(Map<String, dynamic> json) {
    return CityLocation(
      name: json['name'] as String? ?? 'Unknown',
      country: json['country'] as String? ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      admin1: json['admin1'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'country': country,
        'latitude': latitude,
        'longitude': longitude,
        'admin1': admin1,
      };

  static const List<CityLocation> popularCities = [
    CityLocation(name: 'London', country: 'United Kingdom', latitude: 51.5074, longitude: -0.1278),
    CityLocation(name: 'New York', country: 'United States', latitude: 40.7128, longitude: -74.0060),
    CityLocation(name: 'Tokyo', country: 'Japan', latitude: 35.6762, longitude: 139.6503),
    CityLocation(name: 'Paris', country: 'France', latitude: 48.8566, longitude: 2.3522),
    CityLocation(name: 'Bengaluru', country: 'India', latitude: 12.9716, longitude: 77.5946),
    CityLocation(name: 'Sydney', country: 'Australia', latitude: -33.8688, longitude: 151.2093),
    CityLocation(name: 'Dubai', country: 'United Arab Emirates', latitude: 25.2048, longitude: 55.2708),
    CityLocation(name: 'Singapore', country: 'Singapore', latitude: 1.3521, longitude: 103.8198),
  ];
}
