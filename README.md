# 📅 PlanifApp - Calendario Académico

Aplicación Flutter de organización académica basada en un calendario matricial con arquitectura MVVM y Clean Architecture.

## 🏗️ Arquitectura

El proyecto implementa **Clean Architecture** con tres capas claramente separadas:

### 📂 Estructura de Carpetas

```
lib/
├── main.dart
├── core/                           # Utilidades compartidas
└── features/
    └── calendar/
        ├── domain/                 # Capa de Dominio (Lógica de negocio)
        │   ├── entities/          # Entidades de negocio
        │   │   ├── subject.dart
        │   │   ├── activity_type.dart
        │   │   ├── event.dart
        │   │   └── calendar_month.dart
        │   ├── repositories/      # Interfaces de repositorios
        │   │   └── calendar_repository.dart
        │   └── usecases/          # Casos de uso
        │       ├── get_all_subjects.dart
        │       ├── update_event.dart
        │       ├── delete_event.dart
        │       └── initialize_default_subjects.dart
        ├── data/                   # Capa de Datos (Implementación)
        │   ├── models/            # DTOs y adaptadores Hive
        │   │   ├── subject_model.dart
        │   │   ├── activity_type_model.dart
        │   │   └── event_model.dart
        │   ├── datasources/       # Fuentes de datos
        │   │   └── calendar_local_datasource.dart
        │   └── repositories/      # Implementaciones de repositorios
        │       └── calendar_repository_impl.dart
        └── presentation/           # Capa de Presentación (UI)
            ├── providers/         # Gestión de estado con Riverpod
            │   ├── calendar_providers.dart
            │   └── calendar_notifier.dart
            ├── pages/             # Pantallas
            │   └── calendar_page.dart
            └── widgets/           # Componentes reutilizables
                ├── calendar_header.dart
                ├── subject_row.dart
                └── cell_editor_dialog.dart
```

## 📊 Modelo de Datos

### Entidades del Dominio

**Subject (Materia)**
- `id`: Identificador único
- `name`: Nombre de la materia
- `activityTypes`: Lista de tipos de actividad

**ActivityType (Tipo de Actividad)**
- `name`: deberes, talleres, labs, pruebas, proyectos
- `events`: Mapa de día → contenido del evento

**Event (Evento)**
- `subjectId`: Referencia a la materia
- `activityType`: Tipo de actividad
- `day`: Día del mes
- `content`: Contenido del evento (ej: "Parcial", "Prueba P")

**CalendarMonth (Mes del Calendario)**
- `year`, `month`: Fecha
- `daysInMonth`: Cantidad de días
- `firstWeekday`: Día de inicio del mes

## 🔄 Gestión de Estado

**Patrón MVVM con Riverpod:**

### CalendarNotifier (ViewModel)
Gestiona el estado global del calendario:
- Carga inicial de materias
- Actualización de eventos
- Cambio de mes
- Manejo de errores

### Providers
- `calendarLocalDataSourceProvider`: Data source
- `calendarRepositoryProvider`: Repositorio
- `getAllSubjectsProvider`, `updateEventProvider`, etc.: Casos de uso
- `calendarNotifierProvider`: Estado global

## 💾 Persistencia de Datos

**Hive** como base de datos local:
- Almacenamiento tipo clave-valor
- Adaptadores generados automáticamente
- Inicialización de 6 materias predeterminadas:
  1. Lectura y Escritura
  2. Sistemas Operativos
  3. Apps Basadas en Conocimiento
  4. Pruebas de Software
  5. Análisis y Diseño
  6. Apps Móviles

Cada materia tiene 5 tipos de actividades: deberes, talleres, labs, pruebas, proyectos.

## 🎨 Interfaz de Usuario

### CalendarPage (Pantalla Principal)
- **Sticky Header**: Fila superior con días del mes
- **Sticky Sidebar**: Primera columna con materias y actividades
- **Grid Editable**: Celdas que permiten agregar/editar eventos
- **Navegación**: Botones para cambiar de mes

### Características UI
- Tabla con scroll horizontal y vertical
- Celdas de colores según tipo de evento:
  - 🔴 Rojo: Parciales, Exámenes, Conjunta
  - 🟡 Amarillo: Pruebas
  - 🟣 Morado: Proyectos
  - 🔵 Azul: Otros eventos
- Diálogo flotante para editar celdas
- Encabezados con formato "Lunes 8, Martes 9..."

## 🚀 Instalación y Ejecución

1. **Clonar el repositorio**
```bash
git clone <repository-url>
cd planif
```

2. **Instalar dependencias**
```bash
flutter pub get
```

3. **Generar adaptadores de Hive**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. **Ejecutar la aplicación**
```bash
flutter run
```

## 📦 Dependencias Principales

- `flutter_riverpod`: ^2.6.1 - Gestión de estado
- `hive`: ^2.2.3 - Base de datos local
- `hive_flutter`: ^1.1.0 - Integración de Hive con Flutter
- `hive_generator`: ^2.0.1 - Generador de adaptadores
- `build_runner`: ^2.4.13 - Generación de código

## 🔄 Flujo de Datos

```
UI (CalendarPage)
  ↓ Interacción del usuario
CalendarNotifier (StateNotifier)
  ↓ Llama a casos de uso
UseCases (UpdateEvent, GetAllSubjects, etc.)
  ↓ Utiliza el repositorio
CalendarRepository (Interface)
  ↓ Implementación
CalendarRepositoryImpl
  ↓ Accede a datos
CalendarLocalDataSource (Hive)
  ↓ Persistencia
Base de Datos Local
```

## 🎯 Casos de Uso Implementados

1. **GetAllSubjects**: Obtiene todas las materias con sus actividades
2. **UpdateEvent**: Actualiza o crea un evento en una celda específica
3. **DeleteEvent**: Elimina un evento de una celda
4. **InitializeDefaultSubjects**: Crea las materias por defecto si no existen

## ✨ Experiencia de Usuario

### Editar una Celda
1. Tocar cualquier celda de la tabla
2. Se abre un diálogo con el contenido actual (si existe)
3. Escribir el nuevo contenido (ej: "Parcial")
4. Guardar o eliminar el evento

### Navegar entre Meses
- Usar los botones ← y → en el AppBar
- El calendario se regenera automáticamente
- Los eventos se mantienen persistentes

### Actualizar Datos
- Botón de refresh en el AppBar
- Los datos se recargan desde Hive

## 🧪 Testing

La arquitectura facilita el testing en todos los niveles:
- **Unit tests**: Casos de uso y lógica de negocio
- **Widget tests**: Componentes UI
- **Integration tests**: Flujo completo de la app

## 📝 Notas Técnicas

- Arquitectura escalable y modular
- Separación clara de responsabilidades
- Código limpio y mantenible
- Inyección de dependencias con Riverpod
- Mapeo bidireccional entre entidades y DTOs
- Gestión de estado reactivo
- Persistencia local sin internet

## 🎓 Caso de Uso Académico

Esta aplicación permite a estudiantes organizar sus actividades académicas en un calendario visual tipo matriz, donde pueden:
- Ver todas sus materias en un solo lugar
- Registrar fechas de entregas, pruebas y proyectos
- Identificar rápidamente días con múltiples actividades
- Planificar su tiempo de estudio efectivamente
