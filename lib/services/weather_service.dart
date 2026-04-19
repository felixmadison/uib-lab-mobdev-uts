import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_model.dart';

class WeatherService {
  Future<Weather> fetchWeather(String cityName) async {
    final prefs = await SharedPreferences.getInstance();

    try {
      // 1. Cari Koordinat (Lat/Lon) dari nama kota
      final geoUrl = 'https://geocoding-api.open-meteo.com/v1/search?name=$cityName&count=1';
      final geoRes = await http.get(Uri.parse(geoUrl)).timeout(const Duration(seconds: 10));
      
      if (geoRes.statusCode != 200) throw Exception("Gagal mencari kota");
      final geoData = jsonDecode(geoRes.body);
      
      if (geoData['results'] == null) throw Exception("Kota tidak ditemukan");
      final lat = geoData['results'][0]['latitude'];
      final lon = geoData['results'][0]['longitude'];
      final actualCityName = geoData['results'][0]['name'];

      final weatherUrl = 'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current_weather=true&hourly=relativehumidity_2m';
      final weatherRes = await http.get(Uri.parse(weatherUrl)).timeout(const Duration(seconds: 10));

      if (weatherRes.statusCode == 200) {
        final weather = Weather.fromJson(jsonDecode(weatherRes.body), actualCityName);
        
        // Simpan ke Cache (Offline Readiness)
        await prefs.setString('cached_weather', jsonEncode(weather.toMap()));
        return weather;
      } else {
        throw Exception("Gagal mengambil data cuaca");
      }

    } catch (e) {
      // Cek apakah error berasal dari kota tidak ditemukan
      // Jika pesannya mengandung "Kota tidak ditemukan", maka jangan ambil cache.
      if (e.toString().contains("Kota tidak ditemukan")) {
        rethrow; // Teruskan error "Kota tidak ditemukan" ke Provider
      }

      // Jika error karena masalah teknis (Internet mati/Timeout), baru ambil cache
      final cachedData = prefs.getString('cached_weather');
      if (cachedData != null) {
        return Weather.fromMap(jsonDecode(cachedData));
      }
      
      // Jika cache kosong dan internet mati
      throw Exception("Koneksi terputus dan tidak ada data tersimpan.");
    }
  }
}