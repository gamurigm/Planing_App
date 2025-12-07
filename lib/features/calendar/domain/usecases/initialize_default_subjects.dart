import '../repositories/calendar_repository.dart';

/// Caso de uso para inicializar las materias por defecto
class InitializeDefaultSubjects {
  final CalendarRepository repository;

  InitializeDefaultSubjects(this.repository);

  Future<void> call() async {
    await repository.initializeDefaultSubjects();
  }
}
