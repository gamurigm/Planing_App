# 📁 Estructura Completa del Proyecto

```
planif/
│
├── 📄 README.md                          # Documentación principal
├── 📄 ARCHITECTURE.md                    # Documentación de arquitectura
├── 📄 USER_GUIDE.md                      # Guía de usuario
├── 📄 pubspec.yaml                       # Dependencias del proyecto
├── 📄 analysis_options.yaml              # Configuración del analizador
│
├── 📁 lib/
│   │
│   ├── 📄 main.dart                      # Punto de entrada de la app
│   │
│   ├── 📁 core/                          # Utilidades compartidas
│   │   └── (vacío por ahora)
│   │
│   └── 📁 features/
│       └── 📁 calendar/                  # Feature: Calendario Académico
│           │
│           ├── 📁 domain/                # ⚙️ CAPA DE DOMINIO (Lógica de Negocio)
│           │   │
│           │   ├── 📁 entities/          # Entidades de negocio
│           │   │   ├── 📄 subject.dart
│           │   │   │   └── class Subject { id, name, activityTypes }
│           │   │   │
│           │   │   ├── 📄 activity_type.dart
│           │   │   │   └── class ActivityType { name, events: Map<day, content> }
│           │   │   │
│           │   │   ├── 📄 event.dart
│           │   │   │   └── class Event { subjectId, activityType, day, content }
│           │   │   │
│           │   │   └── 📄 calendar_month.dart
│           │   │       └── class CalendarMonth { year, month, daysInMonth, firstWeekday }
│           │   │
│           │   ├── 📁 repositories/      # Contratos (Interfaces)
│           │   │   └── 📄 calendar_repository.dart
│           │   │       └── abstract class CalendarRepository {
│           │   │           Future<List<Subject>> getAllSubjects();
│           │   │           Future<void> updateEvent(...);
│           │   │           Future<void> deleteEvent(...);
│           │   │           Future<void> initializeDefaultSubjects();
│           │   │         }
│           │   │
│           │   └── 📁 usecases/          # Casos de uso (Acciones)
│           │       ├── 📄 get_all_subjects.dart
│           │       │   └── class GetAllSubjects { call() → Future<List<Subject>> }
│           │       │
│           │       ├── 📄 update_event.dart
│           │       │   └── class UpdateEvent { call(subjectId, activityType, day, content) }
│           │       │
│           │       ├── 📄 delete_event.dart
│           │       │   └── class DeleteEvent { call(subjectId, activityType, day) }
│           │       │
│           │       └── 📄 initialize_default_subjects.dart
│           │           └── class InitializeDefaultSubjects { call() }
│           │
│           ├── 📁 data/                  # 💾 CAPA DE DATOS (Implementación)
│           │   │
│           │   ├── 📁 models/            # DTOs con anotaciones Hive
│           │   │   ├── 📄 subject_model.dart
│           │   │   │   ├── @HiveType(typeId: 2)
│           │   │   │   ├── class SubjectModel extends HiveObject
│           │   │   │   ├── factory SubjectModel.fromEntity(Subject)
│           │   │   │   ├── Subject toEntity()
│           │   │   │   ├── factory SubjectModel.fromJson(Map)
│           │   │   │   └── Map toJson()
│           │   │   │
│           │   │   ├── 📄 subject_model.g.dart              # ⚙️ Generado automáticamente
│           │   │   │   └── class SubjectModelAdapter
│           │   │   │
│           │   │   ├── 📄 activity_type_model.dart
│           │   │   │   ├── @HiveType(typeId: 1)
│           │   │   │   └── class ActivityTypeModel extends HiveObject
│           │   │   │
│           │   │   ├── 📄 activity_type_model.g.dart        # ⚙️ Generado automáticamente
│           │   │   │   └── class ActivityTypeModelAdapter
│           │   │   │
│           │   │   ├── 📄 event_model.dart
│           │   │   │   ├── @HiveType(typeId: 0)
│           │   │   │   └── class EventModel extends HiveObject
│           │   │   │
│           │   │   └── 📄 event_model.g.dart                # ⚙️ Generado automáticamente
│           │   │       └── class EventModelAdapter
│           │   │
│           │   ├── 📁 datasources/       # Fuentes de datos
│           │   │   └── 📄 calendar_local_datasource.dart
│           │   │       └── class CalendarLocalDataSource {
│           │   │           Box<SubjectModel> _box;
│           │   │           Future<void> init();
│           │   │           Future<List<SubjectModel>> getAllSubjects();
│           │   │           Future<SubjectModel?> getSubjectById(id);
│           │   │           Future<void> saveSubject(SubjectModel);
│           │   │           Future<void> deleteSubject(id);
│           │   │           Future<void> initializeDefaultSubjects();
│           │   │         }
│           │   │
│           │   └── 📁 repositories/      # Implementaciones
│           │       └── 📄 calendar_repository_impl.dart
│           │           └── class CalendarRepositoryImpl implements CalendarRepository {
│           │               final CalendarLocalDataSource localDataSource;
│           │               // Implementa todos los métodos abstractos
│           │             }
│           │
│           └── 📁 presentation/          # 🎨 CAPA DE PRESENTACIÓN (UI)
│               │
│               ├── 📁 providers/         # Gestión de estado con Riverpod
│               │   ├── 📄 calendar_providers.dart
│               │   │   ├── calendarLocalDataSourceProvider
│               │   │   ├── calendarRepositoryProvider
│               │   │   ├── getAllSubjectsProvider
│               │   │   ├── updateEventProvider
│               │   │   ├── deleteEventProvider
│               │   │   └── initializeDefaultSubjectsProvider
│               │   │
│               │   └── 📄 calendar_notifier.dart
│               │       ├── class CalendarState {
│               │       │   subjects, currentMonth, isLoading, error
│               │       │ }
│               │       │
│               │       ├── class CalendarNotifier extends StateNotifier<CalendarState> {
│               │       │   Future<void> loadSubjects();
│               │       │   Future<void> updateEvent(...);
│               │       │   Future<void> deleteEvent(...);
│               │       │   void changeMonth(DateTime);
│               │       │   String? getCellContent(...);
│               │       │ }
│               │       │
│               │       └── calendarNotifierProvider
│               │
│               ├── 📁 pages/             # Pantallas
│               │   └── 📄 calendar_page.dart
│               │       └── class CalendarPage extends ConsumerWidget {
│               │           - AppBar con título y navegación
│               │           - CalendarHeader (sticky)
│               │           - List de SubjectRow (scrollable)
│               │         }
│               │
│               └── 📁 widgets/           # Componentes reutilizables
│                   ├── 📄 calendar_header.dart
│                   │   └── class CalendarHeader extends StatelessWidget {
│                   │       - Muestra "Mes/Día" + días del mes
│                   │       - Formato: "Lunes 8", "Martes 9"...
│                   │       - Scroll horizontal sincronizado
│                   │     }
│                   │
│                   ├── 📄 subject_row.dart
│                   │   └── class SubjectRow extends StatelessWidget {
│                   │       - Fila de título de materia (azul)
│                   │       - 5 filas de actividades
│                   │       - Grid de celdas por día
│                   │       - GestureDetector en cada celda
│                   │       - Color según contenido
│                   │       - Callback onCellUpdated
│                   │     }
│                   │
│                   └── 📄 cell_editor_dialog.dart
│                       └── class CellEditorDialog extends StatefulWidget {
│                           - TextField para editar evento
│                           - Botón Cancelar
│                           - Botón Eliminar (si existe contenido)
│                           - Botón Guardar
│                           - Callback onSave(String)
│                         }
│
├── 📁 android/                           # Configuración Android
├── 📁 ios/                               # Configuración iOS
├── 📁 linux/                             # Configuración Linux
├── 📁 macos/                             # Configuración macOS
├── 📁 windows/                           # Configuración Windows
└── 📁 web/                               # Configuración Web

```

## 🔄 Flujo de Datos Visual

```
┌─────────────────────────────────────────────────────────────────┐
│                          PRESENTATION                            │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  CalendarPage (UI)                                         │  │
│  │    ↓ Usuario toca celda                                    │  │
│  │  SubjectRow → CellEditorDialog                             │  │
│  │    ↓ onSave("Parcial")                                     │  │
│  │  calendarNotifierProvider.notifier.updateEvent(...)        │  │
│  └───────────────────────────────────────────────────────────┘  │
│                              ↓                                   │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  CalendarNotifier (StateNotifier)                          │  │
│  │    - Lee updateEventProvider                               │  │
│  │    - Ejecuta updateEventUseCase(...)                       │  │
│  │    - Actualiza state                                       │  │
│  └───────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│                            DOMAIN                                │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  UpdateEvent (UseCase)                                     │  │
│  │    - Recibe parámetros                                     │  │
│  │    - Llama a repository.updateEvent(...)                   │  │
│  └───────────────────────────────────────────────────────────┘  │
│                              ↓                                   │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  CalendarRepository (Interface)                            │  │
│  │    - Define contrato abstracto                             │  │
│  └───────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│                             DATA                                 │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  CalendarRepositoryImpl (Implementación)                   │  │
│  │    1. Obtiene subject del datasource                       │  │
│  │    2. Convierte SubjectModel → Subject (entity)            │  │
│  │    3. Actualiza evento en la entidad                       │  │
│  │    4. Convierte Subject → SubjectModel (DTO)               │  │
│  │    5. Guarda en datasource                                 │  │
│  └───────────────────────────────────────────────────────────┘  │
│                              ↓                                   │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  CalendarLocalDataSource (Hive)                            │  │
│  │    - box.get(subjectId) → SubjectModel                     │  │
│  │    - box.put(subjectId, updatedSubjectModel)               │  │
│  └───────────────────────────────────────────────────────────┘  │
│                              ↓                                   │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  Hive Database (Local Storage)                             │  │
│  │    - Persiste datos en disco                               │  │
│  └───────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
                              ↑
                    Datos persisten offline
```

## 📊 Diagrama de Dependencias

```
┌─────────────────────────────────────────────┐
│              main.dart                      │
│  - Inicializa Hive                          │
│  - Registra adaptadores                     │
│  - Provee ProviderScope                     │
│  - Lanza CalendarPage                       │
└─────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────┐
│         CalendarPage                        │
│  - Escucha calendarNotifierProvider         │
│  - Renderiza CalendarHeader                 │
│  - Renderiza lista de SubjectRow            │
└─────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────┐
│        calendarNotifierProvider             │
│  - Provee CalendarState                     │
│  - Expone CalendarNotifier                  │
└─────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────┐
│        CalendarNotifier                     │
│  - Depende de: getAllSubjectsProvider       │
│  - Depende de: updateEventProvider          │
│  - Depende de: deleteEventProvider          │
│  - Depende de: initializeDefaultSubjects... │
└─────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────┐
│        UseCases Providers                   │
│  - Dependen de: calendarRepositoryProvider  │
└─────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────┐
│     calendarRepositoryProvider              │
│  - Provee: CalendarRepositoryImpl           │
│  - Depende de: calendarLocalDataSource...   │
└─────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────┐
│   calendarLocalDataSourceProvider           │
│  - Provee: CalendarLocalDataSource          │
│  - Accede a Hive Box                        │
└─────────────────────────────────────────────┘
```

## 🎯 Principios de Clean Architecture Aplicados

```
┌─────────────────────────────────────────────────┐
│                 PRESENTATION                     │  ← UI, Widgets, State Management
│  Depende de: Domain                              │
│  No conoce: Data implementation                  │
├─────────────────────────────────────────────────┤
│                   DOMAIN                         │  ← Business Logic, Entities, Use Cases
│  No depende de nada                              │
│  Define contratos (interfaces)                   │
├─────────────────────────────────────────────────┤
│                    DATA                          │  ← Implementation, DTOs, DataSources
│  Depende de: Domain                              │
│  Implementa: Repository interfaces               │
└─────────────────────────────────────────────────┘

Regla de dependencia: Solo hacia adentro →
```

## 📝 Convenciones de Nombres

- **Entities**: Sustantivos (Subject, Event)
- **Models**: Sustantivo + "Model" (SubjectModel)
- **Repositories**: Sustantivo + "Repository" (CalendarRepository)
- **UseCases**: Verbo + Sustantivo (GetAllSubjects, UpdateEvent)
- **Providers**: Descriptivo + "Provider" (calendarRepositoryProvider)
- **Notifiers**: Sustantivo + "Notifier" (CalendarNotifier)
- **Widgets**: Sustantivo descriptivo (CalendarHeader, SubjectRow)
- **Pages**: Sustantivo + "Page" (CalendarPage)

## 🎨 Paleta de Colores

```dart
// Encabezados
Colors.blue.shade700  // #1976D2 - Header principal
Colors.blue.shade600  // #1E88E5 - Filas de materias
Colors.blue.shade800  // #1565C0 - AppBar

// Eventos
Colors.red.shade600   // #E53935 - Parciales, Exámenes
Colors.red.shade700   // #D32F2F - Conjunta
Colors.yellow.shade700 // #FBC02D - Pruebas
Colors.purple.shade600 // #8E24AA - Proyectos
Colors.blue.shade500   // #2196F3 - Otros eventos

// Backgrounds
Colors.grey.shade50   // #FAFAFA - Columna de actividades
Colors.white          // #FFFFFF - Celdas vacías

// Borders
Colors.grey.shade300  // #E0E0E0 - Bordes de celdas
Colors.grey.shade400  // #BDBDBD - Bordes de columnas
```

Este proyecto está completamente implementado y listo para usar! 🚀
