/// Entidad que representa un evento académico en una celda específica
class Event {
  final String subjectId;
  final String activityType;
  final int day;
  final String content;

  Event({
    required this.subjectId,
    required this.activityType,
    required this.day,
    required this.content,
  });

  Event copyWith({
    String? subjectId,
    String? activityType,
    int? day,
    String? content,
  }) {
    return Event(
      subjectId: subjectId ?? this.subjectId,
      activityType: activityType ?? this.activityType,
      day: day ?? this.day,
      content: content ?? this.content,
    );
  }
}
