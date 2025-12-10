class Department {
  final String name;
  final TimeOfDay jamMasuk;
  final TimeOfDay jamKeluar;

  Department({
    required this.name,
    required this.jamMasuk,
    required this.jamKeluar,
  });

  static Department fromString(String departmentName) {
    final name = departmentName.trim().toLowerCase();
    
    if (name.contains('staff')) {
      return Department(
        name: 'Staff',
        jamMasuk: const TimeOfDay(hour: 7, minute: 0),
        jamKeluar: const TimeOfDay(hour: 17, minute: 0),
      );
    } else if (name.contains('quarry')) {
      return Department(
        name: 'Quarry',
        jamMasuk: const TimeOfDay(hour: 7, minute: 0),
        jamKeluar: const TimeOfDay(hour: 17, minute: 0),
      );
    } else if (name.contains('office')) {
      return Department(
        name: 'Office',
        jamMasuk: const TimeOfDay(hour: 8, minute: 0),
        jamKeluar: const TimeOfDay(hour: 17, minute: 0),
      );
    } else if (name.contains('intern')) {
      return Department(
        name: 'Intern',
        jamMasuk: const TimeOfDay(hour: 9, minute: 0),
        jamKeluar: const TimeOfDay(hour: 17, minute: 0),
      );
    } else if (name.contains('beban')) {
      return Department(
        name: 'Beban',
        jamMasuk: const TimeOfDay(hour: 10, minute: 0),
        jamKeluar: const TimeOfDay(hour: 17, minute: 0),
      );
    }
    
    // Default to Staff if not recognized
    return Department(
      name: 'Staff',
      jamMasuk: const TimeOfDay(hour: 7, minute: 0),
      jamKeluar: const TimeOfDay(hour: 17, minute: 0),
    );
  }
}

class TimeOfDay {
  final int hour;
  final int minute;

  const TimeOfDay({required this.hour, required this.minute});

  int toMinutes() => hour * 60 + minute;

  @override
  String toString() => '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}
