import '../entities/subject.dart';

/// Repositorio abstracto para operaciones con materias y eventos académicos
abstract class CalendarRepository {
  /// Obtiene todas las materias con sus actividades
  Future<List<Subject>> getAllSubjects();

  /// Obtiene una materia específica por ID
  Future<Subject?> getSubjectById(String id);

  /// Guarda o actualiza una materia
  Future<void> saveSubject(Subject subject);

  /// Elimina una materia
  Future<void> deleteSubject(String id);

  /// Actualiza un evento específico en una celda
  Future<void> updateEvent({
    required String subjectId,
    required String activityType,
    required int day,
    required String content,
  });

  /// Elimina un evento específico
  Future<void> deleteEvent({
    required String subjectId,
    required String activityType,
    required int day,
  });

  /// Inicializa las materias por defecto si no existen
  Future<void> initializeDefaultSubjects();
}
