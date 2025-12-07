import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/subject.dart';
import '../../domain/entities/calendar_month.dart';
import 'calendar_providers.dart';

/// Estado del calendario
class CalendarState {
  final List<Subject> subjects;
  final CalendarMonth currentMonth;
  final bool isLoading;
  final String? error;

  CalendarState({
    required this.subjects,
    required this.currentMonth,
    this.isLoading = false,
    this.error,
  });

  CalendarState copyWith({
    List<Subject>? subjects,
    CalendarMonth? currentMonth,
    bool? isLoading,
    String? error,
  }) {
    return CalendarState(
      subjects: subjects ?? this.subjects,
      currentMonth: currentMonth ?? this.currentMonth,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Notifier para gestionar el estado del calendario
class CalendarNotifier extends StateNotifier<CalendarState> {
  final Ref ref;

  CalendarNotifier(this.ref)
    : super(
        CalendarState(
          subjects: [],
          currentMonth: CalendarMonth.fromDateTime(DateTime.now()),
          isLoading: true,
        ),
      ) {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      // Inicializar datos por defecto
      final initUseCase = ref.read(initializeDefaultSubjectsProvider);
      await initUseCase();

      // Cargar materias
      await loadSubjects();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error al inicializar: $e',
      );
    }
  }

  /// Carga todas las materias
  Future<void> loadSubjects() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final getAllSubjects = ref.read(getAllSubjectsProvider);
      final subjects = await getAllSubjects();

      state = state.copyWith(subjects: subjects, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error al cargar materias: $e',
      );
    }
  }

  /// Actualiza un evento en una celda
  Future<void> updateEvent({
    required String subjectId,
    required String activityType,
    required int day,
    required String content,
  }) async {
    try {
      final updateEventUseCase = ref.read(updateEventProvider);
      await updateEventUseCase(
        subjectId: subjectId,
        activityType: activityType,
        day: day,
        content: content,
      );

      // Recargar materias
      await loadSubjects();
    } catch (e) {
      state = state.copyWith(error: 'Error al actualizar evento: $e');
    }
  }

  /// Elimina un evento
  Future<void> deleteEvent({
    required String subjectId,
    required String activityType,
    required int day,
  }) async {
    try {
      final deleteEventUseCase = ref.read(deleteEventProvider);
      await deleteEventUseCase(
        subjectId: subjectId,
        activityType: activityType,
        day: day,
      );

      // Recargar materias
      await loadSubjects();
    } catch (e) {
      state = state.copyWith(error: 'Error al eliminar evento: $e');
    }
  }

  /// Cambia el mes actual
  void changeMonth(DateTime newMonth) {
    state = state.copyWith(currentMonth: CalendarMonth.fromDateTime(newMonth));
  }

  /// Obtiene el contenido de una celda específica
  String? getCellContent(String subjectId, String activityType, int day) {
    final subject = state.subjects.firstWhere(
      (s) => s.id == subjectId,
      orElse: () => state.subjects.first,
    );

    final activity = subject.getActivityType(activityType);
    return activity?.getEvent(day);
  }
}

/// Provider del notifier
final calendarNotifierProvider =
    StateNotifierProvider<CalendarNotifier, CalendarState>((ref) {
      return CalendarNotifier(ref);
    });
