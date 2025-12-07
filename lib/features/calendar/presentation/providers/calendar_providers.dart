import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/calendar_local_datasource.dart';
import '../../data/repositories/calendar_repository_impl.dart';
import '../../domain/repositories/calendar_repository.dart';
import '../../domain/usecases/get_all_subjects.dart';
import '../../domain/usecases/update_event.dart';
import '../../domain/usecases/delete_event.dart';
import '../../domain/usecases/initialize_default_subjects.dart';

/// Provider para el data source
final calendarLocalDataSourceProvider = Provider<CalendarLocalDataSource>((
  ref,
) {
  return CalendarLocalDataSource();
});

/// Provider para el repositorio
final calendarRepositoryProvider = Provider<CalendarRepository>((ref) {
  final dataSource = ref.watch(calendarLocalDataSourceProvider);
  return CalendarRepositoryImpl(localDataSource: dataSource);
});

/// Providers para los casos de uso
final getAllSubjectsProvider = Provider<GetAllSubjects>((ref) {
  final repository = ref.watch(calendarRepositoryProvider);
  return GetAllSubjects(repository);
});

final updateEventProvider = Provider<UpdateEvent>((ref) {
  final repository = ref.watch(calendarRepositoryProvider);
  return UpdateEvent(repository);
});

final deleteEventProvider = Provider<DeleteEvent>((ref) {
  final repository = ref.watch(calendarRepositoryProvider);
  return DeleteEvent(repository);
});

final initializeDefaultSubjectsProvider = Provider<InitializeDefaultSubjects>((
  ref,
) {
  final repository = ref.watch(calendarRepositoryProvider);
  return InitializeDefaultSubjects(repository);
});
