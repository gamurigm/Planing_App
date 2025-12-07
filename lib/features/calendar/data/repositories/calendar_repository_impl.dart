import '../../domain/entities/subject.dart';
import '../../domain/repositories/calendar_repository.dart';
import '../datasources/calendar_local_datasource.dart';
import '../models/subject_model.dart';

/// Implementación del repositorio usando Hive como fuente de datos
class CalendarRepositoryImpl implements CalendarRepository {
  final CalendarLocalDataSource localDataSource;

  CalendarRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Subject>> getAllSubjects() async {
    final subjectModels = await localDataSource.getAllSubjects();
    return subjectModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Subject?> getSubjectById(String id) async {
    final model = await localDataSource.getSubjectById(id);
    return model?.toEntity();
  }

  @override
  Future<void> saveSubject(Subject subject) async {
    final model = SubjectModel.fromEntity(subject);
    await localDataSource.saveSubject(model);
  }

  @override
  Future<void> deleteSubject(String id) async {
    await localDataSource.deleteSubject(id);
  }

  @override
  Future<void> updateEvent({
    required String subjectId,
    required String activityType,
    required int day,
    required String content,
  }) async {
    final subject = await getSubjectById(subjectId);
    if (subject == null) return;

    final activity = subject.getActivityType(activityType);
    if (activity == null) return;

    final updatedActivity = content.isEmpty
        ? activity.removeEvent(day)
        : activity.addEvent(day, content);

    final updatedSubject = subject.updateActivityType(
      activityType,
      updatedActivity,
    );
    await saveSubject(updatedSubject);
  }

  @override
  Future<void> deleteEvent({
    required String subjectId,
    required String activityType,
    required int day,
  }) async {
    await updateEvent(
      subjectId: subjectId,
      activityType: activityType,
      day: day,
      content: '',
    );
  }

  @override
  Future<void> initializeDefaultSubjects() async {
    final hasSubjects = await localDataSource.hasSubjects();
    if (!hasSubjects) {
      await localDataSource.initializeDefaultSubjects();
    }
  }
}
