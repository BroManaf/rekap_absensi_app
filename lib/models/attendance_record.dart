class AttendanceRecord {
  final DateTime date;
  final String? jamMasukPagi;
  final String? jamKeluarPagi;
  final String? jamMasukSiang;
  final String? jamKeluarSiang;
  final String? jamMasukLembur;
  final String? jamKeluarLembur;

  AttendanceRecord({
    required this.date,
    this.jamMasukPagi,
    this.jamKeluarPagi,
    this.jamMasukSiang,
    this.jamKeluarSiang,
    this.jamMasukLembur,
    this.jamKeluarLembur,
  });

  bool get hasData =>
      jamMasukPagi != null ||
      jamKeluarPagi != null ||
      jamMasukSiang != null ||
      jamKeluarSiang != null ||
      jamMasukLembur != null ||
      jamKeluarLembur != null;
}
