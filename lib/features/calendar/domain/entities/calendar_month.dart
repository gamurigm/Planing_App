/// Entidad que representa un mes del calendario
class CalendarMonth {
  final int year;
  final int month;
  final int daysInMonth;
  final int firstWeekday; // 1 = lunes, 7 = domingo

  CalendarMonth({
    required this.year,
    required this.month,
    required this.daysInMonth,
    required this.firstWeekday,
  });

  factory CalendarMonth.fromDateTime(DateTime date) {
    final firstDay = DateTime(date.year, date.month, 1);
    final lastDay = DateTime(date.year, date.month + 1, 0);

    // Ajustar para que lunes = 1, domingo = 7
    int weekday = firstDay.weekday;

    return CalendarMonth(
      year: date.year,
      month: date.month,
      daysInMonth: lastDay.day,
      firstWeekday: weekday,
    );
  }

  String getMonthName() {
    const months = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];
    return months[month - 1];
  }

  String getDayName(int day) {
    final date = DateTime(year, month, day);
    const weekdays = [
      'Lunes',
      'Martes',
      'Miércoles',
      'Jueves',
      'Viernes',
      'Sábado',
      'Domingo',
    ];
    return weekdays[date.weekday - 1];
  }
}
