# 🏛️ Documentación de Arquitectura - PlanifApp

## Arquitectura MVVM con Clean Architecture

### Principios Aplicados

#### 1. Separación de Capas (Separation of Concerns)
La aplicación está dividida en 3 capas independientes:

**Domain (Dominio)**
- Contiene la lógica de negocio pura
- Define entidades y contratos (interfaces)
- No depende de ninguna capa externa
- Es la capa más estable

**Data (Datos)**
- Implementa los repositorios definidos en Domain
- Gestiona fuentes de datos (Hive en este caso)
- Convierte entre DTOs (modelos) y entidades
- Depende solo de Domain

**Presentation (Presentación)**
- Maneja la UI y la interacción del usuario
- Usa Riverpod para gestión de estado
- Se comunica con Domain a través de casos de uso
- Depende de Domain

#### 2. Dependency Inversion Principle
- Las capas externas dependen de las internas
- Domain no conoce la implementación de Data
- Presentation no conoce la implementación de Data
- Se usan interfaces (repositorios) para desacoplar

## Flujo de Datos Completo

### Ejemplo: Actualizar un Evento

```
1. Usuario toca una celda
   ↓
2. SubjectRow.dart abre CellEditorDialog
   ↓
3. Usuario ingresa "Parcial" y presiona Guardar
   ↓
4. CalendarPage llama a:
   ref.read(calendarNotifierProvider.notifier).updateEvent(...)
   ↓
5. CalendarNotifier ejecuta:
   final updateEventUseCase = ref.read(updateEventProvider)
   await updateEventUseCase(subjectId: "1", activityType: "pruebas", day: 15, content: "Parcial")
   ↓
6. UpdateEvent (UseCase) llama al repositorio:
   await repository.updateEvent(...)
   ↓
7. CalendarRepositoryImpl procesa:
   - Obtiene la materia de Hive
   - Actualiza el mapa de eventos
   - Convierte entidad → modelo
   - Guarda en Hive
   ↓
8. CalendarNotifier recarga materias:
   await loadSubjects()
   ↓
9. State se actualiza, UI se reconstruye
   ↓
10. Usuario ve "Parcial" en la celda con color rojo
```

## Gestión de Estado con Riverpod

### Providers Utilizados

**Provider (Sin estado)**
- `calendarLocalDataSourceProvider`
- `calendarRepositoryProvider`
- `getAllSubjectsProvider`
- `updateEventProvider`
- `deleteEventProvider`
- `initializeDefaultSubjectsProvider`

**StateNotifierProvider (Con estado)**
- `calendarNotifierProvider`: Gestiona el estado global

### CalendarState

```dart
class CalendarState {
  final List<Subject> subjects;      // Todas las materias
  final CalendarMonth currentMonth;  // Mes actual
  final bool isLoading;              // Estado de carga
  final String? error;               // Mensaje de error
}
```

### Notifier Pattern

CalendarNotifier hereda de StateNotifier<CalendarState>:
- `state`: Estado inmutable actual
- `state = newState`: Actualiza y notifica a listeners
- Métodos públicos para actualizar estado

## Mapeo Entidades ↔ DTOs

### ¿Por qué separar entidades de modelos?

**Entidades (Domain)**
- Representan conceptos de negocio
- No tienen anotaciones de persistencia
- Métodos de lógica de negocio
- Independientes de frameworks

**Modelos (Data)**
- DTOs (Data Transfer Objects)
- Anotaciones de Hive (@HiveType, @HiveField)
- Métodos toEntity() y fromEntity()
- Métodos toJson() y fromJson()

### Ejemplo de Mapeo

```dart
// Entidad (Domain)
class Subject {
  final String id;
  final String name;
  final List<ActivityType> activityTypes;
  
  Subject copyWith(...) {...}
  ActivityType? getActivityType(String name) {...}
}

// Modelo (Data)
@HiveType(typeId: 2)
class SubjectModel {
  @HiveField(0) final String id;
  @HiveField(1) final String name;
  @HiveField(2) final List<ActivityTypeModel> activityTypes;
  
  factory SubjectModel.fromEntity(Subject subject) {...}
  Subject toEntity() {...}
  factory SubjectModel.fromJson(Map<String, dynamic> json) {...}
  Map<String, dynamic> toJson() {...}
}
```

## Almacenamiento con Hive

### Ventajas de Hive
- Base de datos NoSQL rápida
- Tipo clave-valor
- Sin boilerplate SQL
- Generación automática de adaptadores
- Funciona offline

### Adaptadores Generados

```dart
// Generado automáticamente por hive_generator
class SubjectModelAdapter extends TypeAdapter<SubjectModel> {
  @override
  final int typeId = 2;
  
  @override
  SubjectModel read(BinaryReader reader) {...}
  
  @override
  void write(BinaryWriter writer, SubjectModel obj) {...}
}
```

### Inicialización

```dart
// main.dart
await Hive.initFlutter();
Hive.registerAdapter(SubjectModelAdapter());
Hive.registerAdapter(ActivityTypeModelAdapter());
Hive.registerAdapter(EventModelAdapter());
```

### Operaciones CRUD

```dart
// Abrir caja
final box = await Hive.openBox<SubjectModel>('calendar_box');

// Create/Update
await box.put(subject.id, subject);

// Read
final subject = box.get('1');
final allSubjects = box.values.toList();

// Delete
await box.delete('1');
```

## Casos de Uso (Use Cases)

### Single Responsibility Principle
Cada caso de uso tiene UNA responsabilidad:

**GetAllSubjects**
- Solo obtiene materias
- No modifica datos

**UpdateEvent**
- Solo actualiza un evento
- No lee ni elimina

**DeleteEvent**
- Solo elimina un evento
- No crea ni actualiza

**InitializeDefaultSubjects**
- Solo crea datos iniciales
- Se ejecuta una vez

### Beneficios
- Testing sencillo
- Código reutilizable
- Fácil de modificar
- Claro y legible

## UI Component Tree

```
MaterialApp
└── CalendarPage (ConsumerWidget)
    ├── AppBar
    │   ├── Title (mes y año)
    │   └── Actions
    │       ├── IconButton (previous month)
    │       ├── IconButton (next month)
    │       └── IconButton (refresh)
    └── Column
        ├── CalendarHeader (días del mes)
        │   ├── Container (primera columna)
        │   └── SingleChildScrollView (días)
        └── Expanded
            └── SingleChildScrollView (materias)
                └── Column
                    └── SubjectRow (x6 materias)
                        ├── Container (nombre materia)
                        └── Row (x5 actividades)
                            ├── Container (nombre actividad)
                            └── Row (x31 días)
                                └── GestureDetector
                                    └── Container (celda)
```

## Widgets Clave

### CalendarPage
- ConsumerWidget (escucha cambios de estado)
- Gestiona AppBar y layout principal
- Pasa callbacks a widgets hijos

### CalendarHeader (Sticky)
- Muestra días del mes
- Formato: "Lunes 8, Martes 9..."
- Sincronizado con scroll horizontal

### SubjectRow
- Fila de materia + 5 actividades
- Genera grid de celdas dinámicamente
- Maneja colores según contenido
- Abre diálogo de edición

### CellEditorDialog
- StatefulWidget con TextEditingController
- TextField para editar contenido
- Botones: Cancelar, Eliminar, Guardar
- Callback onSave para comunicar cambios

## Manejo de Errores

### Estrategia de Error Handling

1. **Try-Catch en Notifier**
```dart
try {
  await updateEventUseCase(...);
} catch (e) {
  state = state.copyWith(error: 'Error: $e');
}
```

2. **Estado de Error en UI**
```dart
if (calendarState.error != null) {
  return ErrorWidget(message: calendarState.error);
}
```

3. **Loading States**
```dart
state = state.copyWith(isLoading: true);
// ... operación ...
state = state.copyWith(isLoading: false);
```

## Escalabilidad

### Cómo Agregar Nuevas Funcionalidades

**1. Nueva Entidad**
- Crear en `domain/entities/`
- Crear modelo en `data/models/`
- Generar adaptador Hive

**2. Nuevo Caso de Uso**
- Crear en `domain/usecases/`
- Implementar lógica con repositorio
- Crear provider en `presentation/providers/`

**3. Nueva Pantalla**
- Crear en `presentation/pages/`
- Usar CalendarNotifier existente
- O crear nuevo notifier si es independiente

**4. Nuevo Widget**
- Crear en `presentation/widgets/`
- Hacerlo reutilizable y configurable
- Pasar datos por parámetros

## Testing Strategy

### Unit Tests (Domain)
```dart
test('Subject should update activity type', () {
  final subject = Subject(...);
  final updated = subject.updateActivityType('deberes', newActivity);
  expect(updated.activityTypes.contains(newActivity), true);
});
```

### Widget Tests (Presentation)
```dart
testWidgets('Cell should open dialog on tap', (tester) async {
  await tester.pumpWidget(SubjectRow(...));
  await tester.tap(find.byType(GestureDetector).first);
  await tester.pump();
  expect(find.byType(CellEditorDialog), findsOneWidget);
});
```

### Integration Tests
```dart
testWidgets('Full flow: edit event', (tester) async {
  await tester.pumpWidget(ProviderScope(child: MainApp()));
  // Tap cell
  // Enter text
  // Save
  // Verify cell updated
});
```

## Mejores Prácticas Aplicadas

✅ **Clean Architecture**: Separación de capas
✅ **SOLID Principles**: SRP, DIP, ISP
✅ **Immutability**: copyWith en entidades
✅ **Reactive State**: Riverpod StateNotifier
✅ **Type Safety**: Fuertemente tipado
✅ **Code Generation**: build_runner
✅ **Dependency Injection**: Riverpod providers
✅ **Single Source of Truth**: Estado centralizado
✅ **Error Handling**: Try-catch + estado
✅ **Code Organization**: Estructura modular

## Recursos Adicionales

- [Flutter Clean Architecture](https://resocoder.com/flutter-clean-architecture-tdd/)
- [Riverpod Documentation](https://riverpod.dev/)
- [Hive Documentation](https://docs.hivedb.dev/)
- [SOLID Principles](https://www.digitalocean.com/community/conceptual_articles/s-o-l-i-d-the-first-five-principles-of-object-oriented-design)
