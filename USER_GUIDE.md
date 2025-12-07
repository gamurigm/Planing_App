# 📖 Guía de Uso - PlanifApp

## Inicio Rápido

### Requisitos Previos
- Flutter SDK 3.9.2 o superior
- Dart 3.9 o superior
- Editor (VS Code, Android Studio, IntelliJ)

### Instalación

1. **Clonar el proyecto**
```bash
cd planif
```

2. **Instalar dependencias**
```bash
flutter pub get
```

3. **Generar código de Hive**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. **Ejecutar en tu dispositivo**
```bash
flutter run
```

## Uso de la Aplicación

### Primera Apertura

Al abrir la aplicación por primera vez, se inicializan automáticamente 6 materias:
1. Lectura y Escritura
2. Sistemas Operativos
3. Apps Basadas en Conocimiento
4. Pruebas de Software
5. Análisis y Diseño
6. Apps Móviles

Cada materia tiene 5 tipos de actividades:
- deberes
- talleres
- labs
- pruebas
- proyectos

### Navegación por el Calendario

**Encabezado Superior**
- Muestra el mes actual (ej: "Diciembre 2025")
- Botones ← y → para cambiar de mes
- Botón 🔄 para recargar datos

**Primera Columna (Sidebar)**
- Nombres de las materias en azul oscuro
- Tipos de actividades bajo cada materia en gris

**Grid de Días**
- Cada columna representa un día del mes
- Formato: "Lunes 8", "Martes 9", etc.
- Scroll horizontal para ver todos los días

### Agregar un Evento

1. **Tocar una celda vacía**
   - Ubicar la intersección entre actividad y día
   - Hacer tap sobre la celda

2. **Escribir el evento**
   - Se abre un diálogo con un campo de texto
   - Escribir el nombre del evento:
     - "Parcial" → aparece en rojo
     - "Prueba P" → aparece en amarillo
     - "Conjunta" → aparece en rojo
     - "Proyecto" → aparece en morado
     - Otro texto → aparece en azul

3. **Guardar**
   - Presionar el botón "Guardar"
   - La celda se actualiza con el texto y color

### Editar un Evento Existente

1. **Tocar la celda con contenido**
   - Se abre el diálogo con el texto actual

2. **Modificar el texto**
   - Editar el contenido en el campo

3. **Opciones:**
   - **Guardar**: Actualiza el evento
   - **Eliminar**: Borra el evento
   - **Cancelar**: No hace cambios

### Eliminar un Evento

**Opción 1: Desde el diálogo**
- Abrir celda
- Presionar botón "Eliminar" (rojo)

**Opción 2: Borrar el texto**
- Abrir celda
- Borrar todo el texto
- Presionar "Guardar"

### Cambiar de Mes

**Mes Anterior**
- Presionar botón ← en el AppBar
- El calendario se regenera automáticamente

**Mes Siguiente**
- Presionar botón → en el AppBar
- Los eventos del mes se cargan automáticamente

**Nota:** Los eventos se guardan por mes, cada día del 1 al 31 puede tener eventos independientes.

## Ejemplos de Uso Académico

### Caso 1: Planificar Pruebas Parciales

```
Materia: Apps Basadas en Conocimiento
Actividad: pruebas
Día: 15
Contenido: "Parcial"
```

La celda aparecerá en **rojo** con el texto "Parcial".

### Caso 2: Registrar Entrega de Taller

```
Materia: Análisis y Diseño
Actividad: talleres
Día: 10
Contenido: "Prueba P"
```

La celda aparecerá en **amarillo** con el texto "Prueba P".

### Caso 3: Examen Conjunta

```
Materia: Pruebas de Software
Actividad: pruebas
Día: 18
Contenido: "Conjunta"
```

La celda aparecerá en **rojo oscuro** con el texto "Conjunta".

### Caso 4: Proyecto Final

```
Materia: Apps Móviles
Actividad: proyectos
Día: 20
Contenido: "Entrega Final"
```

La celda aparecerá en **morado** con el texto "Entrega Final".

## Códigos de Color

| Color | Tipo de Evento |
|-------|----------------|
| 🔴 Rojo | Parciales, Exámenes, Conjunta |
| 🟡 Amarillo | Pruebas |
| 🟣 Morado | Proyectos |
| 🔵 Azul | Otros eventos |

## Persistencia de Datos

- Todos los datos se guardan automáticamente en Hive
- Los eventos persisten entre sesiones
- No se requiere conexión a internet
- Los datos se almacenan localmente en el dispositivo

### Ubicación de Datos

**Windows**: `%USERPROFILE%\AppData\Local\planif\hive\`
**macOS**: `~/Library/Application Support/planif/hive/`
**Linux**: `~/.local/share/planif/hive/`
**Android**: `/data/data/com.example.planif/app_flutter/hive/`
**iOS**: `Library/Application Support/hive/`

## Consejos de Uso

### 1. Organización por Colores
Usa palabras clave para aprovechar el código de colores:
- "Parcial 1", "Parcial 2" → Rojo
- "Prueba P1", "Prueba Recuperación" → Amarillo
- "Proyecto Final", "Proyecto Integrador" → Morado

### 2. Visión General del Mes
- Desplázate horizontalmente para ver todos los días
- Las celdas rojas indican fechas importantes (exámenes)
- Identifica rápidamente días con múltiples actividades

### 3. Planificación Anticipada
- Navega a meses futuros
- Registra fechas importantes con anticipación
- Planifica tu tiempo de estudio

### 4. Actualización Regular
- Revisa y actualiza el calendario semanalmente
- Elimina eventos completados si lo deseas
- Ajusta fechas si hay cambios

## Atajos de Teclado (Próximamente)

- `←` : Mes anterior
- `→` : Mes siguiente
- `R` : Recargar datos
- `Esc` : Cerrar diálogo

## Solución de Problemas

### La app no inicia
```bash
# Limpiar caché
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Los cambios no se guardan
- Verifica que presionaste "Guardar"
- Revisa que hay espacio en disco
- Reinicia la aplicación

### Error al generar código
```bash
# Regenerar adaptadores
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Errores de compilación
```bash
# Verificar errores
flutter analyze

# Formatear código
flutter format lib/
```

## Personalización

### Cambiar Materias
Editar `calendar_local_datasource.dart`:
```dart
final defaultSubjects = [
  SubjectModel(id: '1', name: 'Tu Materia', ...),
  // Agregar más materias
];
```

### Cambiar Tipos de Actividades
Modificar el método `_createDefaultActivityTypes()`:
```dart
return [
  ActivityTypeModel(name: 'tipo1', events: {}),
  ActivityTypeModel(name: 'tipo2', events: {}),
  // Agregar más tipos
];
```

### Cambiar Colores
Editar `subject_row.dart`, método `_getCellColor()`:
```dart
if (lower.contains('tu_palabra')) {
  return Colors.green.shade600;
}
```

### Cambiar Tamaño de Celdas
Editar `calendar_page.dart`:
```dart
static const double cellWidth = 150.0;  // Ancho
static const double cellHeight = 60.0;  // Alto
```

## Preguntas Frecuentes

**¿Puedo usar la app sin internet?**
Sí, la aplicación funciona 100% offline.

**¿Los datos se sincronizan entre dispositivos?**
No, actualmente los datos son locales. Próximamente se agregará sincronización.

**¿Puedo exportar mi calendario?**
Actualmente no, pero es una funcionalidad planificada.

**¿Cuántas materias puedo agregar?**
Ilimitadas, pero recomendamos máximo 10 para mejor visualización.

**¿Puedo cambiar el idioma?**
Actualmente solo español. Se agregará i18n en futuras versiones.

## Próximas Funcionalidades

- ✨ Notificaciones de eventos próximos
- 📤 Exportar a PDF o imagen
- 🔄 Sincronización en la nube
- 🎨 Temas personalizables
- 🔍 Búsqueda de eventos
- 📊 Estadísticas de actividades
- 🗓️ Vista semanal
- ⚙️ Configuración de materias personalizada

## Soporte

Para reportar bugs o sugerir mejoras:
- Crear un issue en GitHub
- Contactar al desarrollador

## Licencia

Este proyecto es de código abierto bajo licencia MIT.
