class AttendanceRecord {
  final DateTime date;
  final String? dayOfWeek; // Day abbreviation: Sen, Sel, Rab, Kam, Jum, Sab, Min
  final String? jamMasukPagi;
  final String? jamKeluarPagi;
  final String? jamMasukSiang;
  final String? jamKeluarSiang;
  final String? jamMasukLembur;
  final String? jamKeluarLembur;

  AttendanceRecord({
    required this.date,
    this.dayOfWeek,
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

  /// Check if this is a Sunday (Minggu)
  bool get isSunday => dayOfWeek?.toLowerCase() == 'min';

  /// Check if this is a Saturday (Sabtu)
  bool get isSaturday => dayOfWeek?.toLowerCase() == 'sab';
}
