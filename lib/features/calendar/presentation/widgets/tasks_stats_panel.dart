import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/subject.dart';
import '../../domain/entities/calendar_month.dart';

/// Collapsible statistics panel that shows counts of overdue, due soon and upcoming tasks.
class TasksStatsPanel extends StatefulWidget {
  final List<Subject> subjects;
  final CalendarMonth currentMonth;
  final bool initiallyCollapsed;

  const TasksStatsPanel({Key? key, required this.subjects, required this.currentMonth, this.initiallyCollapsed = false}) : super(key: key);

  @override
  State<TasksStatsPanel> createState() => _TasksStatsPanelState();
}

class _TasksStatsPanelState extends State<TasksStatsPanel> with SingleTickerProviderStateMixin {
  bool _collapsed = false;

  @override
  void initState() {
    super.initState();
    _collapsed = widget.initiallyCollapsed;
  }

  void _toggle() => setState(() => _collapsed = !_collapsed);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final List<_TaskInfo> tasks = [];
    for (final s in widget.subjects) {
      for (final a in s.activityTypes) {
        for (var day = 1; day <= widget.currentMonth.daysInMonth; day++) {
          final content = a.getEvent(day);
          if (content != null && content.trim().isNotEmpty) {
            final dt = DateTime(widget.currentMonth.year, widget.currentMonth.month, day);
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

    tasks.sort((a, b) => a.date.compareTo(b.date));
    final preview = tasks.where((t) => !t.date.isBefore(DateTime(now.year, now.month, now.day))).take(4).toList();

    // Header with toggle
    final header = Row(
      children: [
        const SizedBox(width: 6),
        const Icon(Icons.bar_chart, size: 18, color: Colors.black54),
        const SizedBox(width: 8),
        const Text('Resumen de tareas', style: TextStyle(fontWeight: FontWeight.bold)),
        const Spacer(),
        IconButton(
          padding: const EdgeInsets.all(6),
          constraints: const BoxConstraints(),
          icon: Icon(_collapsed ? Icons.expand_more : Icons.expand_less),
          onPressed: _toggle,
        ),
      ],
    );

    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: [
          Expanded(child: _StatCard(label: 'Vencidas', count: overdue, color: Colors.red.shade600, total: total)),
          const SizedBox(width: 8),
          Expanded(child: _StatCard(label: 'En 7 días', count: dueSoon, color: Colors.orange.shade600, total: total)),
          const SizedBox(width: 8),
          Expanded(child: _StatCard(label: 'Próximas', count: upcoming, color: Colors.green.shade600, total: total)),
          const SizedBox(width: 12),
          Container(
            width: 260,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 1))],
              border: Border.all(color: AppColors.subtleGrid.withOpacity(0.6), width: 0.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Próximas tareas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 6),
                if (preview.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Text('No hay tareas próximas', style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
                  )
                else
                  ...preview.map((t) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
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

    final compact = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Text('Vencidas: $overdue', style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.w600)),
          const SizedBox(width: 10),
          Text('En 7 días: $dueSoon', style: TextStyle(color: Colors.orange.shade700, fontWeight: FontWeight.w600)),
          const SizedBox(width: 10),
          Text('Próximas: $upcoming', style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.w600)),
        ],
      ),
    );

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // header row
          Container(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6), child: header),
          AnimatedCrossFade(
            firstChild: compact,
            secondChild: content,
            crossFadeState: _collapsed ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 220),
            firstCurve: Curves.easeOut,
            secondCurve: Curves.easeIn,
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
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 1))],
        border: Border.all(color: AppColors.subtleGrid.withOpacity(0.6), width: 0.5),
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
              Text('$count', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(height: 6),
          Text(total == 0 ? 'Sin tareas' : '${(percent * 100).round()}% del total', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
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
