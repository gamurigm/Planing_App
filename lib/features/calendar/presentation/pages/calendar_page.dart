import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/calendar_notifier.dart';
import '../widgets/calendar_header.dart';
import '../widgets/cell_editor_dialog.dart';
import '../widgets/day_cell.dart';
import '../widgets/tasks_stats_panel.dart';
import '../../../../core/theme/app_colors.dart';

/// Página principal del calendario académico
class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});

  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
  static const double cellWidth = 120.0;
  static const double cellHeight = 50.0;
  static const double firstColumnWidth = 200.0;

  // ScrollController único para sincronizar header y cuerpo en horizontal
  final ScrollController _horizontalScrollController = ScrollController();
  // ScrollControllers para sincronizar scroll vertical entre sidebar y grid
  final ScrollController _verticalLeftController = ScrollController();
  final ScrollController _verticalRightController = ScrollController();

  @override
  void dispose() {
    _verticalLeftController.removeListener(_syncVerticalScroll);
    _verticalRightController.removeListener(_syncVerticalScroll);
    _verticalLeftController.dispose();
    _verticalRightController.dispose();
    _horizontalScrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // sincronizar verticalmente ambos scrollcontrollers
    _verticalLeftController.addListener(_syncVerticalScroll);
    _verticalRightController.addListener(_syncVerticalScroll);
  }

  void _syncVerticalScroll() {
    if (!_verticalLeftController.hasClients ||
        !_verticalRightController.hasClients)
      return;
    // decide cuál disparó el evento y sincroniza el otro
    if (_verticalLeftController.position.isScrollingNotifier.value) {
      if (_verticalRightController.offset != _verticalLeftController.offset) {
        _verticalRightController.jumpTo(_verticalLeftController.offset);
      }
    } else if (_verticalRightController.position.isScrollingNotifier.value) {
      if (_verticalLeftController.offset != _verticalRightController.offset) {
        _verticalLeftController.jumpTo(_verticalRightController.offset);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final calendarState = ref.watch(calendarNotifierProvider);
    // width for calculations moved to usage sites

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Calendario Académico - ${calendarState.currentMonth.getMonthName()} ${calendarState.currentMonth.year}',
        ),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () => _changeMonth(-1),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () => _changeMonth(1),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.read(calendarNotifierProvider.notifier).loadSubjects(),
          ),
        ],
      ),
      body: calendarState.isLoading
          ? const Center(child: CircularProgressIndicator())
            : calendarState.error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${calendarState.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => ref
                        .read(calendarNotifierProvider.notifier)
                        .loadSubjects(),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // Stats panel above the calendar
                TasksStatsPanel(subjects: calendarState.subjects, currentMonth: calendarState.currentMonth),
                // Main layout: fixed left sidebar + horizontally scrollable right grid
                Expanded(
                  child: Row(
                    children: [
                      // Left sidebar (fixed)
                      SizedBox(
                        width: firstColumnWidth,
                        child: SingleChildScrollView(
                          controller: _verticalLeftController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // top-left cell
                              Container(
                                height: 72,
                                padding: const EdgeInsets.all(8),
                                alignment: Alignment.center,
                                color: AppColors.header,
                                child: const Text(
                                  'Mes/Día',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              // subjects and activities labels
                              ...calendarState.subjects.map((subject) {
                                return Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Container(
                                      height: 40,
                                      color: AppColors.primary,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        subject.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    ...subject.activityTypes.map((activity) {
                                        return Container(
                                        height: cellHeight,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        alignment: Alignment.centerLeft,
                                        decoration: BoxDecoration(
                                          color: AppColors.activityLabelBg,
                                          border: Border(
                                            bottom: BorderSide(
                                                    color: AppColors.verticalDivider,
                                                    width: 0.5,
                                                  ),
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
                                      );
                                    }).toList(),
                                  ],
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      ),

                      // Right scrollable area (days header + grid)
                      Expanded(
                        child: SingleChildScrollView(
                          controller: _horizontalScrollController,
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width:
                                calendarState.currentMonth.daysInMonth *
                                cellWidth,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Days header (only days boxes)
                                CalendarHeader(
                                  month: calendarState.currentMonth,
                                  cellWidth: cellWidth,
                                  firstColumnWidth: firstColumnWidth,
                                ),

                                // Grid: subjects and their activity rows
                                Expanded(
                                  child: SingleChildScrollView(
                                    controller: _verticalRightController,
                                    child: Column(
                                      children: calendarState.subjects.map((
                                        subject,
                                      ) {
                                        return Column(
                                          children: [
                                            // subject title spacer (aligns with left sidebar)
                                            Container(
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: AppColors.stripBg,
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color: AppColors.verticalDivider,
                                                    width: 0.5,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // activities rows
                                            ...subject.activityTypes.map((
                                              activity,
                                            ) {
                                              return Row(
                                                children: List.generate(
                                                  calendarState
                                                      .currentMonth
                                                      .daysInMonth,
                                                  (index) {
                                                    final day = index + 1;
                                                    final content =
                                                        activity.getEvent(
                                                          day,
                                                        ) ??
                                                        '';
                                                    return DayCell(
                                                      width: cellWidth,
                                                      height: cellHeight,
                                                      content: content,
                                                      colorForContent: (c) =>
                                                          _getCellColor(c),
                                                      onTap: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) => CellEditorDialog(
                                                            initialContent:
                                                                content
                                                                    .isNotEmpty
                                                                ? content
                                                                : null,
                                                            onSave: (newContent) {
                                                              ref
                                                                  .read(
                                                                    calendarNotifierProvider
                                                                        .notifier,
                                                                  )
                                                                  .updateEvent(
                                                                    subjectId:
                                                                        subject
                                                                            .id,
                                                                    activityType:
                                                                        activity
                                                                            .name,
                                                                    day: day,
                                                                    content:
                                                                        newContent,
                                                                  );
                                                            },
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                                ),
                                              );
                                            }).toList(),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  void _changeMonth(int delta) {
    final currentState = ref.read(calendarNotifierProvider);
    final currentMonth = currentState.currentMonth;
    final newDate = DateTime(currentMonth.year, currentMonth.month + delta, 1);
    ref.read(calendarNotifierProvider.notifier).changeMonth(newDate);
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
