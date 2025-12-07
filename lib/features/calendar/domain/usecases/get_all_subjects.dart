import '../entities/subject.dart';
import '../repositories/calendar_repository.dart';

/// Caso de uso para obtener todas las materias
class GetAllSubjects {
  final CalendarRepository repository;

  GetAllSubjects(this.repository);

  Future<List<Subject>> call() async {
    return await repository.getAllSubjects();
  }
}
