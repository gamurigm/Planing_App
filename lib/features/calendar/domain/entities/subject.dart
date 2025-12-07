import 'activity_type.dart';

/// Entidad que representa una materia con sus tipos de actividades
class Subject {
  final String id;
  final String name;
  final List<ActivityType> activityTypes;

  Subject({required this.id, required this.name, required this.activityTypes});

  Subject copyWith({
    String? id,
    String? name,
    List<ActivityType>? activityTypes,
  }) {
    return Subject(
      id: id ?? this.id,
      name: name ?? this.name,
      activityTypes: activityTypes ?? List.from(this.activityTypes),
    );
  }

  ActivityType? getActivityType(String activityTypeName) {
    try {
      return activityTypes.firstWhere((at) => at.name == activityTypeName);
    } catch (e) {
      return null;
    }
  }

  Subject updateActivityType(
    String activityTypeName,
    ActivityType updatedActivityType,
  ) {
    final newActivityTypes = activityTypes.map((at) {
      if (at.name == activityTypeName) {
        return updatedActivityType;
      }
      return at;
    }).toList();
    return copyWith(activityTypes: newActivityTypes);
  }
}
