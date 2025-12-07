import '../repositories/calendar_repository.dart';

/// Caso de uso para actualizar un evento en una celda específica
class UpdateEvent {
  final CalendarRepository repository;

  UpdateEvent(this.repository);

  Future<void> call({
    required String subjectId,
    required String activityType,
    required int day,
    required String content,
  }) async {
    await repository.updateEvent(
      subjectId: subjectId,
      activityType: activityType,
      day: day,
      content: content,
    );
  }
}
