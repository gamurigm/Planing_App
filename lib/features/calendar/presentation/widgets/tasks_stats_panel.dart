import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/subject.dart';
import '../../domain/entities/calendar_month.dart';

/// Small statistics panel that shows counts of overdue, due soon and upcoming tasks.
class TasksStatsPanel extends StatelessWidget {
  final List<Subject> subjects;
  final CalendarMonth currentMonth;

  const TasksStatsPanel({Key? key, required this.subjects, required this.currentMonth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    // Build list of DateTimes for each non-empty event in the month
    final List<_TaskInfo> tasks = [];
    for (final s in subjects) {
      for (final a in s.activityTypes) {
        for (var day = 1; day <= currentMonth.daysInMonth; day++) {
          final content = a.getEvent(day);
          if (content != null && content.trim().isNotEmpty) {
            final dt = DateTime(currentMonth.year, currentMonth.month, day);
            tasks.add(_TaskInfo(subject: s.name, activity: a.name, date: dt, title: content));
          }
        }
      }
    }

    final total = tasks.length;
    final overdue = tasks.where((t) => t.date.isBefore(DateTime(now.year, now.month, now.day))).length;
    final dueSoon = tasks.where((t) {
      final diff = t.date.difference(DateTime(now.year, now.month, now.day)).inDays;
      return diff >= 0 && diff <= 7;
    }).length;
    final upcoming = total - overdue - dueSoon;

    // get top 4 nearest upcoming tasks
    tasks.sort((a, b) => a.date.compareTo(b.date));
    final preview = tasks.where((t) => !t.date.isBefore(DateTime(now.year, now.month, now.day))).take(4).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Expanded(child: _StatCard(label: 'Vencidas', count: overdue, color: Colors.red.shade600, total: total)),
          const SizedBox(width: 12),
          Expanded(child: _StatCard(label: 'En 7 días', count: dueSoon, color: Colors.orange.shade600, total: total)),
          const SizedBox(width: 12),
          Expanded(child: _StatCard(label: 'Próximas', count: upcoming, color: Colors.green.shade600, total: total)),
          const SizedBox(width: 18),
          // Preview list
          Container(
            width: 320,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 2))],
              border: Border.all(color: AppColors.verticalDivider.withOpacity(0.6), width: 0.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Próximas tareas', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                if (preview.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text('No hay tareas próximas', style: TextStyle(color: Colors.grey.shade700)),
                  )
                else
                  ...preview.map((t) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(color: _colorForDate(t.date, now), borderRadius: BorderRadius.circular(2)),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(t.title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 2),
                                  Text('${t.subject} · ${t.activity} · ${_formatDate(t.date)}', style: TextStyle(fontSize: 11, color: Colors.grey.shade700)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _colorForDate(DateTime date, DateTime now) {
    final d0 = DateTime(now.year, now.month, now.day);
    if (date.isBefore(d0)) return Colors.red.shade600;
    final diff = date.difference(d0).inDays;
    if (diff <= 7) return Colors.orange.shade600;
    return Colors.green.shade600;
  }

  String _formatDate(DateTime dt) => '${dt.day}/${dt.month}/${dt.year}';
}

class _StatCard extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final int total;

  const _StatCard({Key? key, required this.label, required this.count, required this.color, required this.total}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final percent = total == 0 ? 0.0 : (count / total).clamp(0.0, 1.0);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
        border: Border.all(color: AppColors.verticalDivider.withOpacity(0.6), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 12, height: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
              const Spacer(),
              Text('$count', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(height: 8),
          Text(total == 0 ? 'Sin tareas' : '${(percent * 100).round()}% del total', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        ],
      ),
    );
  }
}

class _TaskInfo {
  final String subject;
  final String activity;
  final DateTime date;
  final String title;

  _TaskInfo({required this.subject, required this.activity, required this.date, required this.title});
}
