class Weather {
  final String cityName;
  final double temperature;
  final int weatherCode;
  final double windSpeed;
  final int humidity; 
  final String description; 

  Weather({
    required this.cityName,
    required this.temperature,
    required this.weatherCode,
    required this.windSpeed,
    required this.humidity,
    required this.description,
  });

  factory Weather.fromJson(Map<String, dynamic> json, String city) {
    final current = json['current_weather'];
    return Weather(
      cityName: city,
      temperature: current['temperature'].toDouble(),
      weatherCode: current['weathercode'],
      windSpeed: current['windspeed'].toDouble(),
      humidity: json['hourly']['relativehumidity_2m'][0] ?? 0, // Ambil data jam pertama
      description: _getWeatherDesc(current['weathercode']),
    );
  }

  // Helper untuk deskripsi cuaca
  static String _getWeatherDesc(int code) {
    if (code == 0) return "Cerah";
    if (code <= 3) return "Berawan";
    if (code >= 51 && code <= 67) return "Gerimis";
    if (code >= 71 && code <= 82) return "Hujan";
    return "Sebagian Berawan";
  }

  Map<String, dynamic> toMap() => {
    'cityName': cityName,
    'temperature': temperature,
    'weatherCode': weatherCode,
    'windSpeed': windSpeed,
    'humidity': humidity,
    'description': description,
  };

  factory Weather.fromMap(Map<String, dynamic> map) => Weather(
    cityName: map['cityName'],
    temperature: map['temperature'],
    weatherCode: map['weatherCode'],
    windSpeed: map['windSpeed'],
    humidity: map['humidity'] ?? 0,
    description: map['description'] ?? "N/A",
  );
}