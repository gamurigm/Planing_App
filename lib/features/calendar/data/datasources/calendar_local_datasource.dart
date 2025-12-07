import 'package:hive/hive.dart';
import '../models/subject_model.dart';
import '../models/activity_type_model.dart';

/// Fuente de datos local usando Hive
class CalendarLocalDataSource {
  static const String _boxName = 'calendar_box';
  Box<SubjectModel>? _box;

  /// Inicializa la base de datos Hive
  Future<void> init() async {
    if (_box == null || !_box!.isOpen) {
      _box = await Hive.openBox<SubjectModel>(_boxName);
    }
  }

  /// Obtiene todas las materias
  Future<List<SubjectModel>> getAllSubjects() async {
    await init();
    return _box!.values.toList();
  }

  /// Obtiene una materia por ID
  Future<SubjectModel?> getSubjectById(String id) async {
    await init();
    return _box!.get(id);
  }

  /// Guarda o actualiza una materia
  Future<void> saveSubject(SubjectModel subject) async {
    await init();
    await _box!.put(subject.id, subject);
  }

  /// Elimina una materia
  Future<void> deleteSubject(String id) async {
    await init();
    await _box!.delete(id);
  }

  /// Verifica si existen materias
  Future<bool> hasSubjects() async {
    await init();
    return _box!.isNotEmpty;
  }

  /// Limpia toda la base de datos
  Future<void> clear() async {
    await init();
    await _box!.clear();
  }

  /// Inicializa las materias por defecto
  Future<void> initializeDefaultSubjects() async {
    await init();

    final defaultSubjects = [
      SubjectModel(
        id: '1',
        name: 'Lectura y Escritura',
        activityTypes: _createDefaultActivityTypes(),
      ),
      SubjectModel(
        id: '2',
        name: 'Sistemas Operativos',
        activityTypes: _createDefaultActivityTypes(),
      ),
      SubjectModel(
        id: '3',
        name: 'Apps Basadas en Conocimiento',
        activityTypes: _createDefaultActivityTypes(),
      ),
      SubjectModel(
        id: '4',
        name: 'Pruebas de Software',
        activityTypes: _createDefaultActivityTypes(),
      ),
      SubjectModel(
        id: '5',
        name: 'Análisis y Diseño',
        activityTypes: _createDefaultActivityTypes(),
      ),
      SubjectModel(
        id: '6',
        name: 'Apps Móviles',
        activityTypes: _createDefaultActivityTypes(),
      ),
    ];

    for (var subject in defaultSubjects) {
      await saveSubject(subject);
    }
  }

  List<ActivityTypeModel> _createDefaultActivityTypes() {
    return [
      ActivityTypeModel(name: 'deberes', events: {}),
      ActivityTypeModel(name: 'talleres', events: {}),
      ActivityTypeModel(name: 'labs', events: {}),
      ActivityTypeModel(name: 'pruebas', events: {}),
      ActivityTypeModel(name: 'proyectos', events: {}),
    ];
  }
}
