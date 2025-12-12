# Panduan Migrasi Database: SharedPreferences ke SQLite

## 📋 Ringkasan Perubahan

Aplikasi Rekap Absensi telah diperbarui untuk menggunakan database SQLite sebagai pengganti SharedPreferences. Perubahan ini dilakukan untuk meningkatkan performa dan kemampuan menyimpan data dalam jumlah besar untuk penggunaan jangka panjang.

## 🎯 Alasan Migrasi

### Masalah dengan SharedPreferences:
- **Batasan Ukuran**: SharedPreferences dirancang untuk data kecil (preferensi aplikasi)
- **Performa**: Semakin besar data, semakin lambat operasi read/write
- **Tidak Scalable**: Tidak cocok untuk aplikasi yang digunakan jangka panjang dengan akumulasi data besar

### Keunggulan SQLite:
- **Efisien**: Dirancang khusus untuk menyimpan data terstruktur dalam jumlah besar
- **Performa Tinggi**: Indexing dan query optimization
- **Scalable**: Dapat menangani ribuan bahkan jutaan record tanpa penurunan performa
- **Reliable**: Database engine yang telah terbukti stabil dan aman

## 🔧 Perubahan Teknis

### 1. Dependencies Baru

Ditambahkan di `pubspec.yaml`:
```yaml
dependencies:
  sqflite_common_ffi: ^2.3.0  # SQLite untuk desktop (Windows, Linux, macOS)
  path_provider: ^2.1.1       # Untuk mendapatkan path aplikasi
```

### 2. Struktur Database

Database SQLite menggunakan tabel `attendance_data`:

| Kolom        | Tipe    | Deskripsi                                    |
|--------------|---------|----------------------------------------------|
| id           | INTEGER | Primary key (auto increment)                 |
| year_month   | TEXT    | Kunci untuk tahun-bulan (format: YYYY-MM)    |
| data         | TEXT    | JSON string berisi data absensi              |
| created_at   | TEXT    | Timestamp pembuatan                          |
| updated_at   | TEXT    | Timestamp update terakhir                    |

### 3. File-File Baru

#### `lib/services/database_service.dart`
Service utama untuk operasi database:
- Inisialisasi database
- Save/load/delete data
- Mengubah lokasi database
- Query semua data yang tersimpan

#### `lib/services/settings_service.dart`
Service untuk menyimpan pengaturan aplikasi (seperti path database):
- Menyimpan dan mengambil path database kustom
- Menggunakan SharedPreferences untuk settings saja (bukan data besar)

#### `lib/services/migration_service.dart`
Service untuk migrasi otomatis dari SharedPreferences ke SQLite:
- Deteksi data lama
- Migrasi data secara otomatis
- Menandai migrasi sudah selesai

#### `lib/screens/settings_screen.dart`
Layar pengaturan aplikasi:
- Menampilkan lokasi database saat ini
- Memungkinkan user memilih lokasi penyimpanan baru
- Membuka folder database di file explorer

## 💾 Lokasi Penyimpanan Database

### Lokasi Default:
- **Windows**: `C:\Users\[Username]\Documents\rekap_absensi\attendance.db`
- **Linux**: `/home/[username]/Documents/rekap_absensi/attendance.db`
- **macOS**: `/Users/[username]/Documents/rekap_absensi/attendance.db`

### Lokasi Kustom:
User dapat memilih lokasi penyimpanan sendiri melalui menu Pengaturan, misalnya:
- Folder khusus untuk backup
- Drive eksternal (USB, External HDD)
- Network drive (untuk sharing data antar komputer)

## 🔄 Migrasi Otomatis

Ketika aplikasi pertama kali dijalankan setelah update:

1. **Deteksi Data Lama**: Sistem memeriksa apakah ada data di SharedPreferences
2. **Migrasi Otomatis**: Data lama dipindahkan ke database SQLite
3. **Verifikasi**: Sistem memverifikasi semua data berhasil dipindahkan
4. **Tandai Selesai**: Flag disimpan agar migrasi tidak dijalankan lagi

**Catatan**: Data lama di SharedPreferences TIDAK dihapus secara otomatis sebagai backup. User dapat menghapusnya manual jika ingin menghemat ruang.

## 🎨 Fitur Baru: Pengaturan Database

### Mengakses Pengaturan:
1. Klik ikon **Settings** (⚙️) di sidebar kiri bawah
2. Layar pengaturan akan menampilkan informasi database

### Fitur di Layar Pengaturan:

#### 1. Informasi Lokasi Database
- Menampilkan path lengkap database saat ini
- Tombol untuk membuka folder database di file explorer

#### 2. Ubah Lokasi Penyimpanan
- Tombol "Ubah Lokasi Penyimpanan"
- Membuka dialog pemilihan folder
- Konfirmasi sebelum memindahkan database
- Database lama otomatis disalin ke lokasi baru

#### 3. Informasi Sistem
- Penjelasan tentang SQLite
- Tips penggunaan

## 📝 Cara Menggunakan

### Melihat Lokasi Database
1. Buka menu **Pengaturan** dari sidebar
2. Lihat bagian "Lokasi Penyimpanan Database"
3. Path database ditampilkan dalam kotak abu-abu

### Membuka Folder Database
1. Di menu Pengaturan, klik tombol **folder icon** (📁)
2. File explorer akan terbuka menampilkan folder database

### Mengubah Lokasi Database
1. Di menu Pengaturan, klik **"Ubah Lokasi Penyimpanan"**
2. Pilih folder tujuan baru
3. Konfirmasi perubahan
4. Database akan dipindahkan dan aplikasi akan menggunakan lokasi baru

## ⚠️ Hal Penting

### Keamanan Data:
- **Backup**: Selalu backup database sebelum memindahkan ke lokasi baru
- **Path Valid**: Pastikan lokasi tujuan memiliki permission write
- **Space**: Pastikan lokasi tujuan memiliki ruang disk yang cukup

### Best Practices:
- **Jangan** menyimpan database di folder temporary
- **Jangan** menyimpan database di folder yang sering dihapus
- **Gunakan** lokasi yang stabil dan permanen
- **Pertimbangkan** backup otomatis ke cloud storage atau external drive

## 🐛 Troubleshooting

### Database tidak dapat dibuka:
- Pastikan file `attendance.db` ada di lokasi yang dikonfigurasi
- Periksa permission folder
- Restart aplikasi

### Gagal memindahkan database:
- Periksa space disk
- Pastikan folder tujuan tidak read-only
- Tutup aplikasi lain yang mungkin mengakses database

### Data hilang setelah update:
- Cek lokasi default database
- Jalankan migrasi manual (hubungi developer)
- Restore dari backup

## 📊 Perbandingan Performa

| Aspek              | SharedPreferences | SQLite        |
|--------------------|-------------------|---------------|
| Data Size Limit    | ~1-2 MB           | Gigabytes     |
| Query Performance  | O(n)              | O(log n)      |
| Concurrent Access  | Single            | Multiple      |
| Data Integrity     | Basic             | ACID          |
| Indexing           | ❌                 | ✅             |
| Complex Queries    | ❌                 | ✅             |

## 🎯 Kompatibilitas

- ✅ Windows 10/11
- ✅ Linux (Ubuntu, Fedora, dll)
- ✅ macOS 10.14+
- ⚠️ Web (akan menggunakan IndexedDB, dalam pengembangan)
- ⚠️ Mobile (akan menggunakan sqflite standar, dalam pengembangan)

## 📞 Support

Jika mengalami masalah atau memiliki pertanyaan, silakan buat issue di repository GitHub.

---

**Update**: Desember 2024  
**Version**: 1.1.0
