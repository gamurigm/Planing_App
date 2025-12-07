import 'package:hive/hive.dart';
import '../../domain/entities/subject.dart';
import '../../domain/entities/activity_type.dart';
import 'activity_type_model.dart';

part 'subject_model.g.dart';

@HiveType(typeId: 2)
class SubjectModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final List<ActivityTypeModel> activityTypes;

  SubjectModel({
    required this.id,
    required this.name,
    required this.activityTypes,
  });

  // Conversión desde entidad
  factory SubjectModel.fromEntity(Subject subject) {
    return SubjectModel(
      id: subject.id,
      name: subject.name,
      activityTypes: subject.activityTypes
          .map((at) => ActivityTypeModel.fromEntity(at))
          .toList(),
    );
  }

  // Conversión a entidad
  Subject toEntity() {
    return Subject(
      id: id,
      name: name,
      activityTypes: activityTypes.map((at) => at.toEntity()).toList(),
    );
  }

  // Conversión desde JSON
  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['id'] as String,
      name: json['name'] as String,
      activityTypes: (json['activityTypes'] as List<dynamic>)
          .map((at) => ActivityTypeModel.fromJson(at as Map<String, dynamic>))
          .toList(),
    );
  }

  // Conversión a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'activityTypes': activityTypes.map((at) => at.toJson()).toList(),
    };
  }
}
