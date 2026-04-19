import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; 
import '../models/weather_model.dart';
import '../services/weather_service.dart';

class WeatherProvider with ChangeNotifier {
  Weather? _weather;
  bool _isLoading = false;
  String _errorMessage = '';
  bool _isOffline = false;
  List<String> _favoriteCities = []; // State kota favorit

  Weather? get weather => _weather;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get isOffline => _isOffline;
  List<String> get favoriteCities => _favoriteCities; // Getter untuk UI

  WeatherProvider() {
    _loadFavorites(); // Muat favorit saat startup
    searchWeather('Batam');
  }

  // Muat daftar favorit dari storage
  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    _favoriteCities = prefs.getStringList('fav_cities') ?? [];
    notifyListeners();
  }

  // Tambah atau hapus kota dari favorit
  Future<void> toggleFavorite(String cityName) async {
    final prefs = await SharedPreferences.getInstance();
    if (_favoriteCities.contains(cityName)) {
      _favoriteCities.remove(cityName);
    } else {
      _favoriteCities.add(cityName);
    }
    await prefs.setStringList('fav_cities', _favoriteCities);
    notifyListeners();
  }

  Future<void> searchWeather(String cityName) async {
    if (cityName.isEmpty) return;
    _isLoading = true;
    _errorMessage = '';
    _isOffline = false; 
    notifyListeners();

    try {
      final response = await WeatherService().fetchWeather(cityName);
      
      // Jika nama kota yang dicari berbeda dengan nama kota yang dikembalikan, berarti itu data CACHE.
      if (cityName.toLowerCase() != response.cityName.toLowerCase()) {
        _isOffline = true;
      } else {
        _isOffline = false;
      }
      
      _weather = response;
    } catch (e) {
      // Masuk ke sini hanya jika:
      // 1. Kota tidak ditemukan (Rethrow dari service)
      // 2. Internet mati DAN cache kosong
      _isOffline = false; 
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  LinearGradient get skyColor {
    if (_weather == null) return const LinearGradient(colors: [Colors.blue, Colors.lightBlueAccent]);
    int code = _weather!.weatherCode;
    
    if (code == 0 || code == 1) {
      return const LinearGradient(colors: [Colors.blue, Colors.lightBlueAccent], begin: Alignment.topCenter, end: Alignment.bottomCenter);
    } 
    else if (code == 2 || code == 3 || code >= 45 && code <= 48) {
      return const LinearGradient(colors: [Colors.blueGrey, Colors.grey], begin: Alignment.topCenter, end: Alignment.bottomCenter);
    } 
    else if (code >= 51 && code <= 99) {
      return LinearGradient(colors: [Colors.grey[800]!, Colors.grey[600]!], begin: Alignment.topCenter, end: Alignment.bottomCenter);
    }
    return const LinearGradient(colors: [Colors.blue, Colors.lightBlueAccent]);
  }
}