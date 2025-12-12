# Panduan Fitur Penyimpanan File Excel

## Ringkasan Fitur

Fitur baru ini memungkinkan aplikasi untuk menyimpan file Excel asli bersama dengan data absensi yang telah diproses. Pengguna dapat mengunduh kembali file Excel asli kapan saja dari menu Historis Absensi.

## Cara Menggunakan

### 1. Upload dan Simpan File Excel

**Langkah-langkah:**

1. Buka menu **"Rekap Absensi"** dari sidebar
2. Upload file Excel dengan salah satu cara:
   - Drag & drop file ke area upload
   - Klik "click here" untuk memilih file
3. Sistem akan memproses file dan menampilkan data dalam tabel
4. Review data yang sudah diproses
5. Klik tombol **"Simpan Data"** (tombol hijau)
6. File Excel asli akan disimpan bersama dengan data absensi
7. Pesan konfirmasi akan muncul: "Data berhasil disimpan untuk [Bulan] [Tahun]"

**Catatan Penting:**
- File Excel akan disimpan sesuai dengan bulan dan tahun yang terdeteksi dari data
- Nama file asli akan dipertahankan untuk referensi
- Jika file Excel untuk periode yang sama sudah ada, akan diganti dengan file baru

### 2. Download File Excel dari Historis

**Langkah-langkah:**

1. Buka menu **"Historis Absensi"** dari sidebar
2. Pilih tahun dan bulan dari daftar di sidebar kiri
3. Data absensi untuk periode tersebut akan ditampilkan
4. Cari tombol **"Download Excel"** (tombol hijau) di sebelah tombol "Hapus Data"
5. Klik tombol **"Download Excel"**
6. Jika file Excel tersedia:
   - Dialog pemilihan lokasi penyimpanan akan muncul
   - Pilih folder tujuan dan nama file (nama default: `Absensi_[NamaBulan]_[Tahun].xlsx`)
   - Klik "Save"
7. File akan disimpan di lokasi yang dipilih
8. Pesan konfirmasi akan muncul: "File Excel berhasil disimpan: [nama_file]"

**Jika File Tidak Tersedia:**
- Pesan akan muncul: "File Excel tidak tersedia untuk periode ini"
- Ini terjadi jika data diimpor sebelum fitur ini ditambahkan
- Solusi: Upload ulang file Excel untuk periode tersebut

## Informasi Teknis

### Format Penyimpanan
- File disimpan sebagai data biner (BLOB) di database SQLite
- Nama file asli dipertahankan untuk referensi
- Tidak ada batasan ukuran file (tergantung kapasitas database)

### Kompatibilitas
- **Backward Compatible**: Data lama yang tidak memiliki file Excel tetap dapat diakses
- **Database Migration**: Database otomatis diperbarui ke versi 2
- **No Data Loss**: Tidak ada data yang hilang selama proses upgrade

### Keamanan
- File Excel tersimpan aman di database lokal
- Hanya pengguna dengan akses ke database yang dapat mengunduh file
- Validasi tipe file dilakukan saat download (hanya .xlsx dan .xls)

## Keuntungan Fitur Ini

1. **Audit Trail**: File asli dapat diakses kembali untuk verifikasi
2. **Backup Otomatis**: File Excel tersimpan bersama data
3. **Kemudahan Akses**: Download file Excel dengan mudah dari historis
4. **Integritas Data**: File asli tidak termodifikasi dan dapat dibandingkan dengan data yang diproses

## Tips Penggunaan

1. **Organisasi File**: Gunakan nama file yang deskriptif saat upload untuk memudahkan identifikasi
2. **Backup Berkala**: Lakukan backup database secara berkala untuk melindungi data dan file Excel
3. **Verifikasi Data**: Gunakan fitur download untuk membandingkan file asli dengan data yang diproses
4. **Bersihkan Data Lama**: Hapus data periode lama yang sudah tidak diperlukan untuk menghemat ruang

## Troubleshooting

### "File Excel tidak tersedia untuk periode ini"
**Penyebab**: Data diimpor sebelum fitur ini ditambahkan atau file Excel tidak ikut tersimpan  
**Solusi**: Upload ulang file Excel untuk periode tersebut

### "Format file Excel tidak valid"
**Penyebab**: Data di database rusak atau tidak sesuai format  
**Solusi**: Hapus data periode tersebut dan upload ulang

### Dialog penyimpanan tidak muncul
**Penyebab**: File picker mungkin diblokir atau sistem tidak mendukung  
**Solusi**: Pastikan aplikasi memiliki izin akses file sistem

### Ukuran database membengkak
**Penyebab**: Banyak file Excel besar tersimpan di database  
**Solusi**: Hapus data periode lama yang sudah tidak diperlukan

## Pertanyaan Umum (FAQ)

**Q: Apakah file Excel lama (sebelum fitur ini) akan hilang?**  
A: Tidak, data absensi lama tetap tersimpan. Hanya file Excel-nya yang tidak ada karena belum disimpan sebelumnya.

**Q: Bisakah saya mengganti file Excel untuk periode tertentu?**  
A: Ya, upload file baru untuk periode yang sama dan simpan. File lama akan diganti.

**Q: Apakah file Excel terenkripsi di database?**  
A: File disimpan sebagai BLOB di SQLite. Jika database terenkripsi, file juga terenkripsi.

**Q: Berapa ukuran maksimal file Excel yang bisa disimpan?**  
A: Tidak ada batasan khusus, tergantung kapasitas penyimpanan database Anda.

**Q: Apakah perlu backup khusus untuk file Excel?**  
A: Tidak, file Excel tersimpan di database. Backup database sudah mencakup file Excel.

## Dukungan

Jika mengalami masalah atau memiliki pertanyaan, silakan hubungi tim pengembang atau buat issue di repository GitHub.
