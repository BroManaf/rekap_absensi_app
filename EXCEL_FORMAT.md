# Format File Excel Absensi

## Struktur File

### Baris 2 (Header Informasi)
- **Kolom C, D, E, F, G**: Jenis Department (contoh: "Staff", "Quarry", "Office", "Intern", "Beban")
- **Kolom I, J, K**: Nama Karyawan

### Baris 3 (Header Identitas)
- **Kolom C, D, E, F, G**: Tanggal/informasi tambahan
- **Kolom I, J, K**: User ID karyawan

### Baris 12-42 (Data Absensi untuk Tanggal 1-31)
Setiap baris mewakili satu hari (tanggal 1 sampai 31)

**Kolom:**
- **C & D**: Jam masuk pagi (contoh: "07:00")
- **E**: Jam keluar pagi (contoh: "12:00")
- **F & G**: Jam masuk siang (contoh: "12:30")
- **H**: Jam keluar siang (contoh: "18:00")
- **I & J**: Jam masuk lembur (contoh: "18:30")
- **K**: Jam keluar lembur (contoh: "21:00")

## Department dan Jam Kerja

| Department | Jam Masuk | Jam Keluar |
|------------|-----------|------------|
| Staff      | 07:00     | 17:00      |
| Quarry     | 07:00     | 17:00      |
| Office     | 08:00     | 17:00      |
| Intern     | 09:00     | 17:00      |
| Beban      | 10:00     | 17:00      |

## Definisi Shift

| Shift   | Jam Mulai | Jam Selesai |
|---------|-----------|-------------|
| Pagi    | 07:00     | 12:00       |
| Siang   | 12:01     | 18:00       |
| Lembur  | 18:01     | 23:59       |

## Contoh Perhitungan

### Contoh 1: Karyawan Quarry
- **Department**: Quarry (jam masuk: 07:00)
- **Masuk**: 09:00
- **Keluar**: 18:00

**Hasil:**
- **LamaTelat**: 120 menit (09:00 - 07:00)
- **LamaMasuk**: 540 menit (09:00 - 18:00)

### Contoh 2: Karyawan Quarry (Masuk Lebih Awal)
- **Department**: Quarry (jam masuk: 07:00)
- **Masuk Pagi**: 06:45
- **Keluar Siang**: 12:40

**Hasil:**
- **LamaTelat**: 0 menit (masuk lebih awal)
- **LamaMasuk**: 340 menit (dihitung dari 07:00 hingga 12:40)

### Contoh 3: Karyawan Office
- **Department**: Office (jam masuk: 08:00)
- **Masuk Pagi**: 07:50
- **Keluar Pagi**: 12:00
- **Masuk Siang**: 13:00
- **Keluar Siang**: 17:30

**Hasil:**
- **LamaTelat**: 0 menit (masuk lebih awal)
- **LamaMasuk**: 
  - Pagi: 240 menit (08:00 - 12:00, dihitung dari jam department)
  - Siang: 270 menit (13:00 - 17:30)
  - **Total**: 510 menit

## Format Waktu
Gunakan format HH:MM (contoh: "07:30", "16:45")

## Catatan
- Jika karyawan masuk lebih awal dari jam masuk department, perhitungan dimulai dari jam masuk department
- Jika karyawan masuk terlambat, selisihnya dihitung sebagai LamaTelat
- Total dihitung dari akumulasi 31 hari
- Sel kosong akan diabaikan dalam perhitungan
