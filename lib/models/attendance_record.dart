class AttendanceRecord {
  final DateTime date;
  final String? dayOfWeek; // Day abbreviation: Sen, Sel, Rab, Kam, Jum, Sab, Min
  final String? jamMasukPagi;
  final String? jamKeluarPagi;
  final String? jamMasukSiang;
  final String? jamKeluarSiang;
  final String? jamMasukLembur;
  final String? jamKeluarLembur;
  String? notes; // Editable notes for absence/sick leave

  AttendanceRecord({
    required this.date,
    this.dayOfWeek,
    this.jamMasukPagi,
    this.jamKeluarPagi,
    this.jamMasukSiang,
    this.jamKeluarSiang,
    this.jamMasukLembur,
    this.jamKeluarLembur,
    this.notes,
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
  
  /// Check if this is an absence day (no data, not Saturday, not Sunday)
  bool get isAbsence => !hasData && !isSaturday && !isSunday;
}
