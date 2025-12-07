import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/subject.dart';
import 'cell_editor_dialog.dart';
import 'day_cell.dart';

/// Widget para la fila de una materia con todas sus actividades
class SubjectRow extends StatelessWidget {
  final Subject subject;
  final int daysInMonth;
  final double cellWidth;
  final double cellHeight;
  final double firstColumnWidth;
  final Function(String subjectId, String activityType, int day, String content)
  onCellUpdated;

  const SubjectRow({
    super.key,
    required this.subject,
    required this.daysInMonth,
    required this.cellWidth,
    required this.cellHeight,
    required this.firstColumnWidth,
    required this.onCellUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Fila de título de la materia (compacta)
        Container(
          height: 36,
          color: AppColors.primary,
          child: Row(
            children: [
              Container(
                width: firstColumnWidth,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                alignment: Alignment.centerLeft,
                child: Text(
                  subject.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(color: AppColors.subtleGrid, width: 0.5),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Filas de actividades
        ...subject.activityTypes.map((activity) {
          return Container(
            height: cellHeight,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.subtleGrid, width: 0.5),
              ),
            ),
            child: Row(
              children: [
                // Columna de nombre de actividad
                Container(
                  width: firstColumnWidth,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: AppColors.activityLabelBg,
                      border: Border(
                        right: BorderSide(color: AppColors.subtleGrid, width: 0.5),
                      ),
                    ),
                  child: Text(
                    activity.name,
                    style: TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
                // Celdas de días (el scroll horizontal lo controla el padre)
                Expanded(
                  child: Row(
                    children: List.generate(daysInMonth, (index) {
                      final day = index + 1;
                      final content = activity.getEvent(day) ?? '';

                      return DayCell(
                        width: cellWidth,
                        height: cellHeight,
                        content: content,
                        colorForContent: (c) => _getCellColor(c),
                        onTap: () => _showEditDialog(
                          context,
                          subject.id,
                          activity.name,
                          day,
                          content,
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  void _showEditDialog(
    BuildContext context,
    String subjectId,
    String activityType,
    int day,
    String currentContent,
  ) {
    showDialog(
      context: context,
      builder: (context) => CellEditorDialog(
        initialContent: currentContent.isNotEmpty ? currentContent : null,
        onSave: (newContent) {
          onCellUpdated(subjectId, activityType, day, newContent);
        },
      ),
    );
  }

  Color _getCellColor(String content) {
    final lower = content.toLowerCase();
    if (lower.contains('parcial') || lower.contains('examen')) {
      return Colors.red.shade600;
    } else if (lower.contains('prueba')) {
      return Colors.orange.shade600;
    } else if (lower.contains('conjunta')) {
      return Colors.red.shade700;
    } else if (lower.contains('proyecto')) {
      return AppColors.accent;
    }
    return AppColors.primary.withOpacity(0.85);
  }
}
