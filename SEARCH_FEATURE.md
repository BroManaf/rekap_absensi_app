# Fitur Pencarian (Search Feature)

## Deskripsi
Fitur pencarian memungkinkan pengguna untuk mencari karyawan berdasarkan **User ID** atau **Nama Karyawan** dalam tabel rekap absensi.

## Cara Menggunakan

1. Upload file Excel absensi seperti biasa
2. Setelah data ditampilkan, gunakan kolom pencarian di atas tabel
3. Ketik User ID atau nama karyawan yang ingin dicari
4. Tabel akan otomatis memfilter hasil sesuai kata kunci pencarian
5. Klik tombol "X" untuk menghapus pencarian dan menampilkan semua data

## Fitur

### 1. Pencarian Real-time
- Hasil pencarian muncul secara otomatis saat mengetik
- Tidak perlu menekan tombol "Enter" atau "Cari"

### 2. Pencarian Case-Insensitive
- Pencarian tidak membedakan huruf besar/kecil
- "JOHN" akan menemukan "John", "john", "JOHN", dll.

### 3. Pencarian Partial Match
- Tidak perlu mengetik nama lengkap
- Contoh: Mengetik "bud" akan menemukan "Budi", "Budiman", dll.
- Mengetik "123" akan menemukan User ID yang mengandung "123"

### 4. Feedback Visual
- **Saat ada hasil**: Menampilkan jumlah karyawan yang ditemukan
  - Contoh: "Menampilkan 3 dari 50 karyawan"
- **Saat tidak ada hasil**: Menampilkan pesan tidak ada hasil
  - Contoh: "Tidak ada hasil yang cocok dengan pencarian "xyz""

### 5. Tombol Clear (X)
- Muncul otomatis saat ada teks di kolom pencarian
- Klik untuk menghapus pencarian dan reset tampilan

## Contoh Penggunaan

### Contoh 1: Cari berdasarkan User ID
```
Ketik: "1234"
Hasil: Semua karyawan dengan User ID yang mengandung "1234"
```

### Contoh 2: Cari berdasarkan Nama
```
Ketik: "ahmad"
Hasil: Semua karyawan dengan nama mengandung "ahmad" (Ahmad, Muhammad, dll.)
```

### Contoh 3: Cari berdasarkan Nama sebagian
```
Ketik: "bud"
Hasil: Budi, Budiman, Budiawan, dll.
```

## Implementasi Teknis

### State Management
- `_searchQuery`: Menyimpan query pencarian saat ini
- `_searchController`: Controller untuk TextField pencarian
- `_filteredSummaries`: Getter yang mengembalikan hasil filter

### Algoritma Filtering
```dart
List<AttendanceSummary> get _filteredSummaries {
  if (_searchQuery.isEmpty) {
    return _summaries;
  }
  
  final query = _searchQuery.toLowerCase();
  return _summaries.where((summary) {
    final userId = summary.employee.userId.toLowerCase();
    final name = summary.employee.name.toLowerCase();
    return userId.contains(query) || name.contains(query);
  }).toList();
}
```

### UI Components
- **TextField**: Input untuk pencarian
  - Placeholder: "Cari berdasarkan User ID atau Nama Karyawan..."
  - Prefix Icon: Search icon (🔍)
  - Suffix Icon: Clear button (X) - conditional
- **Feedback Messages**: Informasi hasil pencarian
  - Success message: Warna grey
  - No results message: Warna orange

## Catatan
- Fitur pencarian hanya bekerja setelah file Excel berhasil diupload
- Pencarian tidak mempengaruhi data asli, hanya memfilter tampilan
- Klik "Upload Baru" akan mereset pencarian secara otomatis
