import 'package:hive/hive.dart';
import '../../domain/entities/activity_type.dart';

part 'activity_type_model.g.dart';

@HiveType(typeId: 1)
class ActivityTypeModel extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final Map<dynamic, dynamic> events;

  ActivityTypeModel({required this.name, Map<int, String>? events})
    : events =
          events?.map((k, v) => MapEntry(k as dynamic, v as dynamic)) ?? {};

  // Conversión desde entidad
  factory ActivityTypeModel.fromEntity(ActivityType activityType) {
    return ActivityTypeModel(
      name: activityType.name,
      events: activityType.events,
    );
  }

  // Conversión a entidad
  ActivityType toEntity() {
    final Map<int, String> typedEvents = {};
    events.forEach((key, value) {
      if (key is int && value is String) {
        typedEvents[key] = value;
      }
    });

    return ActivityType(name: name, events: typedEvents);
  }

  // Conversión desde JSON
  factory ActivityTypeModel.fromJson(Map<String, dynamic> json) {
    final eventsMap =
        (json['events'] as Map<String, dynamic>?)?.map(
          (key, value) => MapEntry(int.parse(key), value as String),
        ) ??
        <int, String>{};

    return ActivityTypeModel(name: json['name'] as String, events: eventsMap);
  }

  // Conversión a JSON
  Map<String, dynamic> toJson() {
    final eventsMap = <String, String>{};
    events.forEach((key, value) {
      eventsMap[key.toString()] = value.toString();
    });

    return {'name': name, 'events': eventsMap};
  }
}
