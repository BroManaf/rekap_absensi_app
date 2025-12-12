# Verifikasi Integritas File Excel

## Gambaran Umum

Fitur penyimpanan file Excel dirancang untuk menyimpan file Excel asli dengan tepat, byte-per-byte, tanpa modifikasi apapun. Dokumen ini menjelaskan bagaimana sistem bekerja dan cara memverifikasi integritas file.

## Cara Kerja Sistem

### 1. Proses Upload dan Penyimpanan

Ketika user mengupload file Excel:

```dart
// File dibaca sebagai bytes mentah
var bytes = File(filePath).readAsBytesSync();  // Uint8List

// Bytes disimpan langsung ke database tanpa modifikasi
await DatabaseService.saveData(
  key, 
  jsonData, 
  excelFileBytes: bytes,  // Bytes asli disimpan
  excelFilename: filename
);
```

**Penting**: File dibaca sebelum diproses oleh Excel package, jadi bytes yang disimpan adalah file asli yang belum dimodifikasi.

### 2. Penyimpanan di Database

File disimpan sebagai BLOB di SQLite:

```sql
CREATE TABLE attendance_data (
  ...
  excel_file BLOB,           -- File bytes disimpan di sini
  excel_filename TEXT,       -- Nama file asli
  ...
)
```

SQLite menyimpan BLOB sebagai Uint8List, yang merupakan representasi bytes yang efisien dan akurat.

### 3. Proses Download

Ketika user mendownload file dari historis:

```dart
// Ambil bytes dari database (Uint8List)
final excelData = await DatabaseService.getExcelFile(key);
final bytes = excelData['bytes'] as List<int>;

// Tulis bytes langsung ke file
final file = File(savePath);
await file.writeAsBytes(bytes);
```

**Tidak ada konversi atau modifikasi** - bytes yang sama yang disimpan akan ditulis ke file.

## Verifikasi Integritas

### Debug Logging

Sistem sekarang memiliki logging komprehensif di mode debug:

```
[AttendanceScreen] Excel file loaded: Absensi_Desember_2024.xlsx, size: 45678 bytes
[DatabaseService] Saving Excel file: Absensi_Desember_2024.xlsx, size: 45678 bytes
[DatabaseService] Excel file saved successfully for key: 2024-12
[DatabaseService] Retrieved Excel file: Absensi_Desember_2024.xlsx, size: 45678 bytes
[HistorisScreen] Excel file ready for download: 45678 bytes
[HistorisScreen] File written to: /path/to/file.xlsx, size: 45678 bytes (original: 45678 bytes)
```

Jika ukuran file berbeda di salah satu tahap, akan terlihat di log.

### Cara Manual Memverifikasi

#### Metode 1: Bandingkan Ukuran File

1. Catat ukuran file Excel asli sebelum upload (klik kanan > Properties/Informasi)
2. Upload file ke aplikasi dan simpan
3. Download file dari historis
4. Bandingkan ukuran file yang didownload dengan ukuran asli

**Harus sama persis!**

#### Metode 2: Bandingkan Hash File (Advanced)

Menggunakan command line:

**Windows (PowerShell):**
```powershell
# File asli
Get-FileHash "C:\path\to\original.xlsx" -Algorithm MD5

# File yang didownload
Get-FileHash "C:\path\to\downloaded.xlsx" -Algorithm MD5
```

**Linux/Mac:**
```bash
# File asli
md5sum /path/to/original.xlsx

# File yang didownload  
md5sum /path/to/downloaded.xlsx
```

**Hash harus identik 100%** jika file byte-perfect.

#### Metode 3: Buka File di Excel

1. Buka file yang didownload di Microsoft Excel atau LibreOffice
2. Verifikasi:
   - ✅ Semua data terlihat dengan benar
   - ✅ Formatting (bold, colors, merged cells) utuh
   - ✅ Formulas (jika ada) masih berfungsi
   - ✅ Sheets/tabs semua ada
   - ✅ Tidak ada pesan error atau warning

## Troubleshooting

### File Rusak Setelah Download

**Gejala**: File Excel tidak bisa dibuka atau data hilang/corrupt

**Kemungkinan Penyebab**:

1. **File rusak sebelum upload**
   - Solusi: Coba upload file yang berbeda yang sudah diverifikasi baik

2. **Masalah permission saat menulis file**
   - Solusi: Pastikan folder tujuan memiliki write permission
   - Coba simpan ke lokasi berbeda (misalnya Desktop)

3. **Antivirus memblokir atau memodifikasi file**
   - Solusi: Temporarily disable antivirus, atau tambahkan exception

4. **Disk penuh atau corrupted**
   - Solusi: Pastikan ada cukup ruang disk

### Ukuran File Berbeda

**Jika log menunjukkan ukuran berbeda**:

1. Check apakah ada error di log sebelum/sesudah penyimpanan
2. Pastikan database tidak penuh atau corrupted
3. Coba dengan file Excel yang lebih kecil untuk testing
4. Restart aplikasi dan coba lagi

### File Terbuka Tapi Format Berubah

**Gejala**: File bisa dibuka tapi formatting hilang atau berbeda

**Ini TIDAK seharusnya terjadi** karena kita menyimpan file asli tanpa modifikasi.

Jika terjadi:
1. Verifikasi menggunakan hash/checksum (Metode 2 di atas)
2. Jika hash sama, kemungkinan:
   - Versi Excel berbeda (2003 vs 2019 vs 365)
   - Font yang digunakan tidak tersedia di komputer
   - Settings regional berbeda
3. Jika hash berbeda, ada bug - laporkan dengan:
   - File Excel sampel
   - Log debug lengkap
   - Langkah-langkah reproduksi

## Technical Details

### Mengapa Bytes Exact?

1. **Read**: `File.readAsBytesSync()` returns `Uint8List` - binary representation
2. **Store**: SQLite BLOB stores bytes as-is, no encoding/decoding
3. **Retrieve**: SQLite returns `Uint8List` directly
4. **Write**: `File.writeAsBytes()` writes binary data as-is

Tidak ada konversi string, encoding, atau transformasi lainnya.

### Type Handling

```dart
// Database returns Uint8List (which implements List<int>)
if (excelFileData is List<int>) {
  bytes = excelFileData;  // No copy, just type cast
}
```

Kita tidak menggunakan `List.from()` untuk menghindari unnecessary copy yang bisa introduce bugs.

## Testing

Unit test memverifikasi integritas byte-per-byte:

```dart
test('Save and retrieve Excel file as Uint8List', () async {
  final testExcelBytes = Uint8List.fromList(List<int>.generate(500, (i) => i % 256));
  
  // Save
  await DatabaseService.saveData(key, data, 
    excelFileBytes: testExcelBytes,
    excelFilename: 'test.xlsx'
  );
  
  // Retrieve  
  final excelData = await DatabaseService.getExcelFile(key);
  final retrievedBytes = excelData!['bytes'] as List<int>;
  
  // Verify every single byte
  for (int i = 0; i < testExcelBytes.length; i++) {
    expect(retrievedBytes[i], equals(testExcelBytes[i]));
  }
});
```

## Kesimpulan

Sistem dirancang untuk menjaga integritas file Excel 100%. Jika ada masalah:

1. Aktifkan debug mode dan check logs
2. Verifikasi ukuran file di setiap tahap
3. Gunakan hash comparison untuk memastikan
4. Report bug dengan informasi lengkap jika hash berbeda

File Excel yang didownload **harus identik byte-per-byte** dengan file yang diupload.
