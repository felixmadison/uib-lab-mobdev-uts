// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../providers/weather_provider.dart';
import '../widgets/weather_info_tile.dart'; 
import '../widgets/favorite_chip.dart';    

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
Widget build(BuildContext context) {
  final provider = context.watch<WeatherProvider>();

  return Scaffold(
    resizeToAvoidBottomInset: false,
    body: AnimatedContainer(
      duration: const Duration(seconds: 1),
      width: double.infinity,
      height: double.infinity, 
      decoration: BoxDecoration(gradient: provider.skyColor),
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
            ),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // 1. SEARCH BAR
                TextField(
                  onSubmitted: (value) =>
                      context.read<WeatherProvider>().searchWeather(value),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Cari Kota...',
                    hintStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: const Icon(Icons.search, color: Colors.white),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.2),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none),
                  ),
                ),

                const SizedBox(height: 10),

                // 2. DAFTAR FAVORIT
                if (provider.favoriteCities.isNotEmpty)
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: provider.favoriteCities.length,
                        itemBuilder: (context, index) {
                          final city = provider.favoriteCities[index];
                          return FavoriteChip(
                            city: city,
                            onTap: () => provider.searchWeather(city),
                            onDelete: () => provider.toggleFavorite(city),
                          );
                        },
                      ),
                    ),

                  const SizedBox(height: 10),

                if (provider.isOffline && provider.weather != null)
                  _buildOfflineBanner(),

                const SizedBox(height: 40),

                // 3. LOGIKA UI
                if (provider.isLoading)
                  _buildShimmer()
                else if (provider.errorMessage.isNotEmpty)
                  _buildError(context, provider.errorMessage)
                else if (provider.weather != null)
                  _buildWeatherContent(context, provider),
                
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

  Widget _buildOfflineBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.orangeAccent.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off, color: Colors.white, size: 20),
          SizedBox(width: 10),
          Flexible(
            child: Text(
              "Koneksi Gagal. Menampilkan Data Terakhir.",
              style: TextStyle(
                  color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.white.withOpacity(0.4),
      highlightColor: Colors.white.withOpacity(0.8),
      child: Column(
        children: [
          Container(height: 40, width: 200, color: Colors.white),
          const SizedBox(height: 20),
          Container(height: 100, width: 150, color: Colors.white),
          const SizedBox(height: 40),
          Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20))),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.location_off, size: 80, color: Colors.white),
        const SizedBox(height: 16),
        Text(message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 18)),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () =>
              context.read<WeatherProvider>().searchWeather('Batam'),
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white, foregroundColor: Colors.blue),
          child: const Text("Coba Lagi"),
        )
      ],
    );
  }

  Widget _buildWeatherContent(BuildContext context, WeatherProvider provider) {
    final weather = provider.weather!;
    final isFav = provider.favoriteCities.contains(weather.cityName);

    return Column(
      children: [
        IconButton(
          icon: Icon(isFav ? Icons.favorite : Icons.favorite_border,
              color: Colors.redAccent, size: 40),
          onPressed: () => provider.toggleFavorite(weather.cityName),
        ),
        Text(weather.cityName,
            style: const TextStyle(
                fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white)),
        Text("${weather.temperature}°C",
            style: const TextStyle(
                fontSize: 80, fontWeight: FontWeight.w300, color: Colors.white)),
        const SizedBox(height: 30),
        Wrap(
          spacing: 15,
          runSpacing: 15,
          alignment: WrapAlignment.center,
          children: [
            WeatherInfoTile(
                icon: Icons.air, label: "Angin", value: "${weather.windSpeed} km/h"),
            WeatherInfoTile(
                icon: Icons.wb_sunny_outlined,
                label: "Cuaca",
                value: weather.description),
            WeatherInfoTile(
                icon: Icons.water_drop_outlined,
                label: "Kelembapan",
                value: "${weather.humidity}%"),
            WeatherInfoTile(
                icon: Icons.eco_outlined, label: "Udara", value: "Baik"),
          ],
        )
      ],
    );
  }
}