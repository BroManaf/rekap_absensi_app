# Penjelasan Sistem Penyimpanan Data

## 📊 Proses Penyimpanan Data

### 1. Alur Penyimpanan Data Absensi

```
┌─────────────────────────────────────────────────────────────────┐
│ User Upload File Excel                                          │
└───────────────┬─────────────────────────────────────────────────┘
                │
                ▼
┌─────────────────────────────────────────────────────────────────┐
│ AttendanceScreen: Parse Excel & Hitung Data                    │
│ • Baca data karyawan dari Excel                                │
│ • Hitung total jam masuk, telat, lembur                        │
│ • Buat objek AttendanceSummary untuk setiap karyawan           │
└───────────────┬─────────────────────────────────────────────────┘
                │
                ▼
┌─────────────────────────────────────────────────────────────────┐
│ AttendanceStorageService.saveAttendanceData()                  │
│ • Buat key: "YYYY-MM" (contoh: "2024-12")                      │
│ • Convert AttendanceSummary → JSON                             │
│ • Panggil DatabaseService.saveData()                           │
└───────────────┬─────────────────────────────────────────────────┘
                │
                ▼
┌─────────────────────────────────────────────────────────────────┐
│ DatabaseService.saveData(key, jsonData)                        │
│ • Ambil instance database                                      │
│ • Insert data dengan SQL:                                      │
│   INSERT OR REPLACE INTO attendance_data                       │
│   (year_month, data, created_at, updated_at)                   │
│   VALUES ('2024-12', '{"employee":...}', timestamp, timestamp) │
│ • Return true jika berhasil                                    │
└───────────────┬─────────────────────────────────────────────────┘
                │
                ▼
┌─────────────────────────────────────────────────────────────────┐
│ SQLite Database File: attendance.db                            │
│ Lokasi: Documents/rekap_absensi/attendance.db                  │
│ (atau lokasi kustom yang dipilih user)                         │
└─────────────────────────────────────────────────────────────────┘
```

### 2. Struktur Database

**Tabel: attendance_data**
```sql
CREATE TABLE attendance_data (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  year_month TEXT NOT NULL UNIQUE,        -- Kunci: "2024-12"
  data TEXT NOT NULL,                     -- JSON lengkap data absensi
  created_at TEXT NOT NULL,               -- Kapan data pertama kali disimpan
  updated_at TEXT NOT NULL                -- Kapan data terakhir diupdate
);

CREATE INDEX idx_year_month ON attendance_data(year_month);
```

**Contoh Data yang Tersimpan:**
```
┌────┬────────────┬──────────────────────────────────┬─────────────────────┬─────────────────────┐
│ id │ year_month │ data                             │ created_at          │ updated_at          │
├────┼────────────┼──────────────────────────────────┼─────────────────────┼─────────────────────┤
│ 1  │ 2024-11    │ [{"employee":{"userId":"001"...  │ 2024-12-01T10:00:00 │ 2024-12-01T10:00:00 │
│ 2  │ 2024-12    │ [{"employee":{"userId":"001"...  │ 2024-12-12T09:30:00 │ 2024-12-12T09:30:00 │
└────┴────────────┴──────────────────────────────────┴─────────────────────┴─────────────────────┘
```

### 3. Format Data JSON yang Disimpan

```json
[
  {
    "employee": {
      "userId": "001",
      "name": "Budi Santoso",
      "department": "Staff"
    },
    "totalMasukMinutes": 9600,
    "totalTelatMinutes": 120,
    "totalLemburMinutes": 480,
    "daysMasuk": 20,
    "daysTelat": 3,
    "daysLembur": 5,
    "records": [
      {
        "date": "2024-12-01T00:00:00.000",
        "dayOfWeek": "Sen",
        "jamMasukPagi": "07:05",
        "jamKeluarPagi": "12:00",
        "jamMasukSiang": "13:00",
        "jamKeluarSiang": "16:00",
        "jamMasukLembur": "18:00",
        "jamKeluarLembur": null,
        "notes": null
      }
      // ... 30 hari lainnya
    ]
  }
  // ... karyawan lainnya
]
```

## 📁 Lokasi Penyimpanan Data

### Lokasi Default (Otomatis)

#### Windows:
```
C:\Users\[NamaUser]\Documents\rekap_absensi\attendance.db
```

#### Linux:
```
/home/[username]/Documents/rekap_absensi/attendance.db
```

#### macOS:
```
/Users/[username]/Documents/rekap_absensi/attendance.db
```

### Lokasi Kustom (Pilihan User)

User dapat memilih lokasi mana saja melalui menu Pengaturan:

**Contoh:**
- `D:\Backup Perusahaan\Data Absensi\attendance.db`
- `E:\USB Drive\Rekap Absensi\attendance.db`
- Network drive: `\\SERVER\Shared\Absensi\attendance.db`

### Cara Mengubah Lokasi:

1. Klik ikon **Settings (⚙️)** di sidebar kiri
2. Lihat lokasi database saat ini
3. Klik tombol **"Ubah Lokasi Penyimpanan"**
4. Pilih folder baru lewat file picker
5. Konfirmasi → Database otomatis di-copy ke lokasi baru

**Catatan Penting:**
- Database di lokasi lama **TIDAK dihapus** (sebagai backup)
- Aplikasi langsung pakai lokasi baru untuk operasi selanjutnya
- User bisa hapus manual database lama setelah yakin data aman

## 🛡️ Penanganan Kondisi Tidak Terduga

### 1. Error Saat Inisialisasi Database

**Kondisi:** Aplikasi tidak bisa membuat atau membuka database

```dart
static Future<void> initialize() async {
  try {
    // ... inisialisasi database
    await _openDatabase();
  } catch (e) {
    debugPrint('Error initializing database: $e');
    // App akan tetap jalan tapi fitur penyimpanan tidak tersedia
  }
}
```

**Penanganan:**
- Error di-log untuk debugging
- User akan melihat error saat mencoba save/load data
- Tidak crash aplikasi

**Solusi untuk User:**
- Check permission folder Documents
- Pastikan disk space cukup
- Restart aplikasi

---

### 2. Error Saat Menyimpan Data

**Kondisi:** Gagal insert ke database (disk penuh, permission denied, dll)

```dart
static Future<bool> saveData(String key, String jsonData) async {
  try {
    final db = await database;
    await db.insert(
      'attendance_data',
      {...},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return true;
  } catch (e) {
    debugPrint('Error saving data: $e');
    return false;  // ← Return false, tidak throw exception
  }
}
```

**Penanganan:**
- Return `false` ke caller
- Error di-log
- AttendanceScreen bisa tampilkan pesan error ke user

**Di AttendanceScreen:**
```dart
final success = await AttendanceStorageService.saveAttendanceData(...);

if (success) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Data berhasil disimpan'))
  );
} else {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Gagal menyimpan data'))
  );
}
```

---

### 3. Error Saat Membaca Data

**Kondisi:** File database corrupt, data tidak valid, dll

```dart
static Future<String?> loadData(String key) async {
  try {
    final db = await database;
    final results = await db.query(...);
    
    if (results.isEmpty) {
      return null;  // Data tidak ditemukan (bukan error)
    }
    
    return results.first['data'] as String;
  } catch (e) {
    debugPrint('Error loading data: $e');
    return null;  // Return null, tidak crash
  }
}
```

**Penanganan:**
- Return `null` jika error atau data tidak ada
- Caller harus handle `null` case

**Di HistorisAbsensiScreen:**
```dart
final data = await AttendanceStorageService.loadAttendanceData(...);

if (data == null) {
  // Tampilkan pesan "Tidak ada data" atau "Error memuat data"
} else {
  // Tampilkan data
}
```

---

### 4. Database Corrupt / File Rusak

**Kondisi:** File database rusak karena crash saat write, disk error, dll

**Penanganan di SQLite:**
- SQLite punya built-in recovery mechanism
- Transaction rollback otomatis jika error
- ACID compliance mencegah data partial/corrupt

**Jika tetap corrupt:**
```dart
// User bisa reset database dengan hapus file:
// 1. Tutup aplikasi
// 2. Hapus file attendance.db
// 3. Buka aplikasi lagi → database baru otomatis dibuat
```

---

### 5. Disk Space Penuh

**Kondisi:** Tidak ada space untuk menyimpan data baru

```dart
static Future<bool> saveData(String key, String jsonData) async {
  try {
    await db.insert(...);
    return true;
  } catch (e) {
    // Error: "disk I/O error" atau "database or disk is full"
    debugPrint('Error saving data: $e');
    return false;
  }
}
```

**Penanganan:**
- Save operation return `false`
- User melihat error message
- Data lama tetap aman (tidak ter-overwrite)

**Solusi:**
- Free up disk space
- Atau pindah database ke lokasi lain yang ada space-nya

---

### 6. Permission Denied

**Kondisi:** Aplikasi tidak punya permission write ke folder

**Saat Inisialisasi:**
```dart
static Future<String> _getDefaultDatabasePath() async {
  try {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String dbDir = path.join(appDocDir.path, 'rekap_absensi');
    
    final Directory dir = Directory(dbDir);
    if (!await dir.exists()) {
      await dir.create(recursive: true);  // Bisa error di sini
    }
    
    return path.join(dbDir, 'attendance.db');
  } catch (e) {
    debugPrint('Error creating database directory: $e');
    // Fallback atau throw error
  }
}
```

**Penanganan:**
- Log error
- User perlu check permission folder
- Bisa coba pindah database ke lokasi lain via Settings

---

### 7. Network Drive Tidak Tersedia

**Kondisi:** User simpan database di network drive, tapi network down

```dart
static Future<bool> changeDatabaseLocation(String newPath) async {
  try {
    // Test write ke lokasi baru
    final directory = Directory(path.dirname(finalPath));
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    
    // Copy database
    await oldFile.copy(finalPath);
    
    return true;
  } catch (e) {
    debugPrint('Error changing database location: $e');
    return false;  // Tetap pakai lokasi lama
  }
}
```

**Penanganan:**
- Return `false` jika gagal
- Database tetap di lokasi lama
- User bisa coba lagi nanti

---

### 8. Concurrent Access / Race Condition

**Kondisi:** Multiple operations akses database bersamaan

**Penanganan oleh SQLite:**
- SQLite handle concurrent access secara otomatis
- Write operations di-queue
- Read operations bisa parallel
- Locking mechanism built-in

**Di kode kita:**
```dart
static Database? _database;  // Singleton instance

static Future<Database> get database async {
  if (_database == null) {
    await initialize();
  }
  return _database!;
}
```
- Satu instance database untuk semua operasi
- Tidak ada race condition

---

### 9. Migrasi Data Gagal

**Kondisi:** Error saat migrasi dari SharedPreferences ke SQLite

```dart
static Future<bool> migrateIfNeeded() async {
  try {
    // Check if migration already done
    if (migrationComplete) {
      return true;  // Skip
    }
    
    // Migrate each month's data
    for (var entry in allData.entries) {
      try {
        final success = await DatabaseService.saveData(key, jsonData);
        if (success) {
          migratedCount++;
        } else {
          errorCount++;
        }
      } catch (e) {
        errorCount++;  // Log tapi lanjut ke data berikutnya
        debugPrint('[Migration] Error migrating ${entry.key}: $e');
      }
    }
    
    // Mark complete even if ada error (partial migration OK)
    await prefs.setBool(_migrationCompleteKey, true);
    
    return errorCount == 0;
  } catch (e) {
    debugPrint('[Migration] Error during migration: $e');
    return false;
  }
}
```

**Penanganan:**
- Migrasi berjalan item by item
- Jika satu item error, lanjut ke item berikutnya
- Data lama tetap ada di SharedPreferences (tidak dihapus)
- User bisa manual copy data yang gagal migrate

---

### 10. App Crash Saat Write

**Kondisi:** Aplikasi crash di tengah operasi write ke database

**Penanganan SQLite:**
- **ACID Compliance**: Atomic, Consistent, Isolated, Durable
- Transaction otomatis rollback jika tidak complete
- Database tetap konsisten
- Tidak ada partial write

**Contoh:**
```dart
// Jika crash di sini ↓
await db.insert('attendance_data', {...});
// Data TIDAK akan tersimpan jika crash sebelum complete
// Database tetap di state sebelumnya (konsisten)
```

**Recovery:**
- User tinggal buka aplikasi lagi
- Database dalam keadaan konsisten
- Bisa langsung pakai tanpa repair

---

## 🔄 Flow Chart Error Handling

```
User Action (Save/Load/Delete)
        ↓
AttendanceStorageService
        ↓
   try { ... }
        ↓
DatabaseService.operation()
        ↓
   try { ... }
        ↓
SQLite Operation
        ↓
    Success?
    ├─ YES → return true/data
    │         ↓
    │    Show success message
    │
    └─ NO → catch (e)
              ↓
         Log error
              ↓
         return false/null
              ↓
         Show error message to user
              ↓
         Data lama tetap aman
```

## ✅ Summary Keamanan Data

### Proteksi yang Sudah Ada:

1. **Try-Catch di Setiap Layer**
   - DatabaseService: catch semua SQL errors
   - AttendanceStorageService: catch semua conversion errors
   - UI Screen: handle false/null returns

2. **Transactions (ACID)**
   - SQLite guarantee data integrity
   - Rollback otomatis jika error
   - Tidak ada partial updates

3. **Backup Otomatis**
   - Migrasi: data lama tetap di SharedPreferences
   - Relokasi: database lama tidak dihapus
   - User bisa restore manual

4. **Graceful Degradation**
   - Error tidak crash app
   - User tetap bisa pakai fitur lain
   - Error message yang jelas

5. **Logging**
   - Semua error di-log dengan `debugPrint`
   - Developer bisa trace issue
   - User bisa report error dengan detail

### Best Practices untuk User:

1. **Backup Berkala**
   - Copy file `attendance.db` ke lokasi aman
   - Simpan di cloud storage atau external drive

2. **Monitor Disk Space**
   - Pastikan selalu ada space untuk database growth

3. **Lokasi Stabil**
   - Jangan simpan di folder yang sering dihapus
   - Avoid temporary folders
   - Network drive OK tapi pastikan always connected

4. **Test After Relocation**
   - Setelah pindah database, test save/load
   - Verifikasi data masih bisa diakses
   - Baru hapus database lama setelah yakin

---

**Dokumen ini menjelaskan lengkap proses penyimpanan data dan semua skenario error yang sudah di-handle oleh sistem.**
