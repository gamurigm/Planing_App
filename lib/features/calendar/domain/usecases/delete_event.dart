import '../repositories/calendar_repository.dart';

/// Caso de uso para eliminar un evento
class DeleteEvent {
  final CalendarRepository repository;

  DeleteEvent(this.repository);

  Future<void> call({
    required String subjectId,
    required String activityType,
    required int day,
  }) async {
    await repository.deleteEvent(
      subjectId: subjectId,
      activityType: activityType,
      day: day,
    );
  }
}
