# rekap_absensi_app

Aplikasi Flutter untuk mengelola dan merekap data absensi karyawan dari file Excel.

## Fitur Utama

### 1. Rekap Absensi Karyawan
- Upload file Excel dengan format absensi standar
- Parsing otomatis data karyawan dan department
- Perhitungan keterlambatan (LamaTelat) dan durasi kerja (LamaMasuk)
- Tampilan ringkasan per karyawan dengan total akumulasi 31 hari
- Support untuk berbagai department dengan jam kerja yang berbeda
- **Fitur Pencarian**: Cari karyawan berdasarkan User ID atau Nama (lihat [SEARCH_FEATURE.md](SEARCH_FEATURE.md))
- **Penyimpanan Database**: Menggunakan SQLite untuk performa optimal dengan data besar

### 2. Export Excel
- Upload dan proses multiple sheets Excel
- Ekstraksi data dari berbagai format Excel

### 3. Historis Absensi
- Lihat riwayat data absensi per bulan
- Penyimpanan permanen data absensi

### 4. Pengaturan
- **Konfigurasi Lokasi Database**: Pilih lokasi penyimpanan database sesuai keinginan
- Pindahkan database ke folder khusus, drive eksternal, atau network drive
- Lihat [DATABASE_MIGRATION_GUIDE.md](DATABASE_MIGRATION_GUIDE.md) untuk informasi lengkap

## Format File Excel

Lihat [EXCEL_FORMAT.md](EXCEL_FORMAT.md) untuk detail lengkap tentang format file Excel yang didukung.

**⚠️ PERUBAHAN PENTING (Desember 2024):**
- Kolom "Jam Masuk Lembur" sekarang berfungsi sebagai **jam keluar akhir**, bukan jam masuk lembur
- Jam keluar siang berubah dari 18:00 menjadi 16:00
- Lembur dihitung mulai dari jam 17:01 (dihitung dari 17:00)
- Waktu 16:00-17:01 TIDAK dihitung sebagai jam kerja

Lihat [OVERTIME_LOGIC_UPDATE.md](OVERTIME_LOGIC_UPDATE.md) dan [OVERTIME_VISUAL_GUIDE.md](OVERTIME_VISUAL_GUIDE.md) untuk penjelasan detail.

## Teknologi

- Flutter (Dart)
- Package: excel, file_picker, desktop_drop
- Support: Windows, macOS, Linux, Web

## Cara Menggunakan

1. Jalankan aplikasi
2. Pilih menu "Rekap Absensi" dari sidebar
3. Upload file Excel dengan cara:
   - Drag & drop file ke area upload, atau
   - Klik "click here" untuk memilih file
4. Lihat hasil rekap absensi di tabel yang muncul

## Department yang Didukung

| Department | Jam Masuk | Jam Keluar |
|------------|-----------|------------|
| Staff      | 07:00     | 17:00      |
| Quarry     | 07:00     | 17:00      |
| Office     | 08:00     | 17:00      |
| Intern     | 09:00     | 17:00      |
| Beban      | 10:00     | 17:00      |
