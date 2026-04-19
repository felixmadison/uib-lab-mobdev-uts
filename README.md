# 🌦️ Weather App - UTS Mobile Development

Aplikasi prakiraan cuaca responsif yang dibangun menggunakan Flutter. Aplikasi ini memungkinkan pengguna mencari cuaca di berbagai kota, menyimpan kota favorit, dan mendukung penggunaan offline dengan sistem caching.

---

## 📂 Struktur Folder (Folder Structure)

Proyek ini menggunakan folder yang terpisah untuk memastikan kode tetap bersih, mudah dikelola, dan memiliki tanggung jawab yang terpisah.

```text
lib/
├── models/          # Berisi blueprint data (Weather Model) dan logika parsing JSON/Map.
├── providers/       # State Management: Mengatur logika bisnis dan sinkronisasi data ke UI.
├── services/        # Service Layer: Menangani permintaan API (Open-Meteo) dan SharedPreferences.
├── views/           # UI Layer: Berisi file utama layar (HomeScreen).
├── widgets/         # Reusable Widgets: Komponen UI yang digunakan berulang kali (Chip, Tile).
└── main.dart        # Titik masuk aplikasi dan konfigurasi MultiProvider.
```
## 🛠️ State Management: Provider
Aplikasi ini menggunakan Provider sebagai solusi State Management karena:

- Efisiensi & Standar Flutter: Provider adalah rekomendasi resmi dari tim Flutter untuk manajemen state tingkat menengah karena performanya yang ringan dan integrasi yang erat dengan widget tree.
- Separation of Concerns: Dengan Provider, logika bisnis dipisahkan sepenuhnya dari kode UI di *home_screen.dart* dengan tujuan mempermudah debugging dan pengujian.
- Reactive UI: Penggunaan *notifyListeners()* memungkinkan UI melakukan pembaruan secara otomatis dan instan setiap kali data cuaca atau status koneksi berubah.
- Sederhana: Provider sederhana dan cepat diimplementasikan tanpa mengurangi skalabilitas aplikasi.

---

## ✨ Fitur Utama & Penjelasan Teknis
**1. Offline Readiness (Caching)**
Aplikasi menggunakan SharedPreferences untuk menyimpan data cuaca terakhir yang berhasil diambil.
- Saat koneksi internet terputus, aplikasi tidak akan menampilkan layar kosong, melainkan mengambil data dari cache.
- Terdapat Banner Offline yang muncul secara otomatis untuk memberi tahu pengguna bahwa data yang dilihat adalah data terakhir yang tersimpan.

**2. Smart Error Handling**
Sistem error handling untuk membedakan jenis kesalahan:
- Kota Tidak Ditemukan: Jika user typo, aplikasi akan menampilkan pesan "Kota tidak ditemukan" tanpa mengaktifkan mode offline.
- Masalah Jaringan: Jika internet mati, aplikasi akan beralih ke data cache jika tersedia.

**3. Responsive & Adaptive UI**
- SingleChildScrollView: Mencegah overflow pada berbagai ukuran layar dan saat keyboard muncul.
- Dynamic Gradient: Latar belakang aplikasi berubah secara dinamis melalui getter skyColor mengikuti kode cuaca (Cerah = Biru, Berawan = Abu-abu, Hujan = Gelap).
- Reusable Widgets: Memisahkan komponen kecil ke folder widgets/ untuk menjaga konsistensi desain dan mempermudah pemeliharaan kode.

**4. Animasi & UX**
- AnimatedContainer: Memberikan transisi warna gradient yang halus saat cuaca berubah di HomeScreen.
- Shimmer Effect: Menampilkan placeholder animasi saat data sedang dimuat dari API untuk memberikan pengalaman visual yang lebih baik kepada pengguna.

---

## 🚀 Cara Menjalankan
Clone repository ini.
Jalankan flutter pub get untuk mengunduh dependencies (http, provider, shared_preferences, shimmer).
Jalankan aplikasi dengan flutter run.

--- 

**Felix Madison - 2026**
