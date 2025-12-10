# Template Excel Absensi

## Struktur File Excel

Gunakan struktur berikut untuk membuat file Excel absensi yang kompatibel dengan aplikasi:

### Sheet Layout (Per Karyawan)

Setiap sheet Excel mewakili satu karyawan.

```
ROW 1: [Kosong/Header]
ROW 2: 
  - Column A: [Kosong]
  - Column B: [Kosong]
  - Column C-G: DEPARTMENT (contoh: "Quarry", "Office", "Staff")
  - Column H: [Kosong]
  - Column I-K: NAMA KARYAWAN (contoh: "John Doe")

ROW 3:
  - Column A-H: [Tanggal/Info tambahan]
  - Column I-K: USER ID (contoh: "EMP001")

ROW 4-11: [Header tambahan atau kosong]

ROW 12-42: DATA ABSENSI (31 hari)
  Setiap row mewakili satu hari (1-31):
  - Column A: [Nomor]
  - Column B: [Tanggal]
  - Column C: Jam Masuk Pagi 1
  - Column D: Jam Masuk Pagi 2
  - Column E: Jam Keluar Pagi
  - Column F: Jam Masuk Siang 1
  - Column G: Jam Masuk Siang 2
  - Column H: Jam Keluar Siang
  - Column I: Jam Masuk Lembur 1
  - Column J: Jam Masuk Lembur 2
  - Column K: Jam Keluar Lembur
```

## Contoh Pengisian

### Sheet 1: Employee - John Doe

| A | B | C | D | E | F | G | H | I | J | K |
|---|---|---|---|---|---|---|---|---|---|---|
| | | | | | | | | | | |
| | | Quarry | | | | | | John Doe | | |
| | | | | | | | | EMP001 | | |
| | | | | | | | | | | |
| ... (rows 4-11 kosong) |
| 1 | 01/01 | 07:00 | | 12:00 | 13:00 | | 17:00 | | | |
| 2 | 02/01 | 06:45 | | | | | 12:40 | | | |
| 3 | 03/01 | 09:00 | | | | | 18:00 | | | |
| 4 | 04/01 | 07:00 | | 12:00 | 13:00 | | 18:00 | 18:30 | | 21:00 |
| 5 | 05/01 | | | | | | | | | |
| ... (lanjutkan sampai row 42 untuk hari ke-31) |

### Sheet 2: Employee - Jane Smith

| A | B | C | D | E | F | G | H | I | J | K |
|---|---|---|---|---|---|---|---|---|---|---|
| | | | | | | | | | | |
| | | Office | | | | | | Jane Smith | | |
| | | | | | | | | EMP002 | | |
| | | | | | | | | | | |
| ... (rows 4-11 kosong) |
| 1 | 01/01 | 08:00 | | 12:00 | 13:00 | | 17:00 | | | |
| 2 | 02/01 | 08:15 | | | | | 17:30 | | | |
| ... (lanjutkan sampai row 42) |

## Tips Pengisian

1. **Format Waktu**: Gunakan format HH:MM (contoh: "07:00", "16:45")
2. **Department**: Tulis nama department di salah satu kolom C-G pada row 2
3. **Nama Karyawan**: Tulis nama lengkap di salah satu kolom I-K pada row 2
4. **User ID**: Tulis user ID di salah satu kolom I-K pada row 3
5. **Data Kosong**: Kosongkan sel jika karyawan tidak hadir atau tidak ada data
6. **Multiple Sheets**: Buat sheet terpisah untuk setiap karyawan

## Department yang Didukung

- **Staff**: Jam masuk 07:00
- **Quarry**: Jam masuk 07:00
- **Office**: Jam masuk 08:00
- **Intern**: Jam masuk 09:00
- **Beban**: Jam masuk 10:00

## Shift Kerja

- **Pagi**: 07:00 - 12:00
- **Siang**: 12:01 - 18:00
- **Lembur**: 18:01 - 23:59

## Catatan Penting

1. Aplikasi akan membaca semua sheet dalam file Excel
2. Setiap sheet diasumsikan mewakili satu karyawan
3. Jika data essential (nama atau user ID) kosong, sheet akan dilewati
4. Perhitungan otomatis menangani:
   - Masuk lebih awal (dihitung dari jam masuk department)
   - Terlambat (dihitung selisihnya)
   - Kerja lintas shift (otomatis digabung)
   - Data kosong (diabaikan)

## Download Template

Untuk memudahkan, Anda dapat membuat file Excel baru dengan struktur di atas, atau salin struktur dari contoh yang diberikan.

## Troubleshooting

### Error: "Employee name or UserID is empty"
- Pastikan row 2 kolom I-K berisi nama karyawan
- Pastikan row 3 kolom I-K berisi user ID

### Error: "Invalid time format"
- Periksa format waktu (harus HH:MM)
- Contoh valid: "07:00", "12:30", "18:45"
- Contoh invalid: "7:0", "7", "07-00"

### Perhitungan tidak sesuai
- Periksa department sudah benar
- Verifikasi jam masuk/keluar terisi dengan benar
- Pastikan tidak ada spasi atau karakter tambahan di nilai waktu
