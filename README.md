# rekap_absensi_app

Aplikasi Flutter untuk mengelola dan merekap data absensi karyawan dari file Excel.

## Fitur Utama

### 1. Rekap Absensi Karyawan
- Upload file Excel dengan format absensi standar
- Parsing otomatis data karyawan dan department
- Perhitungan keterlambatan (LamaTelat) dan durasi kerja (LamaMasuk)
- Tampilan ringkasan per karyawan dengan total akumulasi 31 hari
- Support untuk berbagai department dengan jam kerja yang berbeda

### 2. Export Excel
- Upload dan proses multiple sheets Excel
- Ekstraksi data dari berbagai format Excel

### 3. Historis Absensi
- (Coming soon) Lihat riwayat data absensi

## Format File Excel

Lihat [EXCEL_FORMAT.md](EXCEL_FORMAT.md) untuk detail lengkap tentang format file Excel yang didukung.

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
