import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/calendar_month.dart';

/// Widget para el encabezado del calendario con los días del mes
class CalendarHeader extends StatelessWidget {
  final CalendarMonth month;
  final double cellWidth;
  final double firstColumnWidth;

  const CalendarHeader({
    super.key,
    required this.month,
    required this.cellWidth,
    required this.firstColumnWidth,
  });

  @override
  Widget build(BuildContext context) {
    // Now this header only renders the days row (no left column).
    return Container(
      color: AppColors.header,
      height: 72,
      child: Row(
        children: List.generate(month.daysInMonth, (index) {
          final day = index + 1;
          final dayName = month.getDayName(day);

          return Container(
            width: cellWidth,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: AppColors.verticalDivider, width: 0.5),
                right: BorderSide(color: AppColors.verticalDivider, width: 0.5),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  dayName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '$day',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
