/// Utility functions for date and time formatting
class DateUtils {
  /// Get Indonesian month name from month number (1-12)
  /// 
  /// Throws [RangeError] if month is not in the valid range 1-12
  static String getMonthName(int month) {
    if (month < 1 || month > 12) {
      throw RangeError.range(month, 1, 12, 'month', 'Month must be between 1 and 12');
    }
    
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return months[month - 1];
  }
}
