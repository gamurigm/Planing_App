import 'package:hive/hive.dart';
import '../../domain/entities/event.dart';

part 'event_model.g.dart';

@HiveType(typeId: 0)
class EventModel extends HiveObject {
  @HiveField(0)
  final String subjectId;

  @HiveField(1)
  final String activityType;

  @HiveField(2)
  final int day;

  @HiveField(3)
  final String content;

  EventModel({
    required this.subjectId,
    required this.activityType,
    required this.day,
    required this.content,
  });

  // Conversión desde entidad
  factory EventModel.fromEntity(Event event) {
    return EventModel(
      subjectId: event.subjectId,
      activityType: event.activityType,
      day: event.day,
      content: event.content,
    );
  }

  // Conversión a entidad
  Event toEntity() {
    return Event(
      subjectId: subjectId,
      activityType: activityType,
      day: day,
      content: content,
    );
  }

  // Conversión desde JSON
  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      subjectId: json['subjectId'] as String,
      activityType: json['activityType'] as String,
      day: json['day'] as int,
      content: json['content'] as String,
    );
  }

  // Conversión a JSON
  Map<String, dynamic> toJson() {
    return {
      'subjectId': subjectId,
      'activityType': activityType,
      'day': day,
      'content': content,
    };
  }
}
