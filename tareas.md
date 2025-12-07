Desarrolla una aplicación en Flutter en MVVM basada en un sistema de organización académica que funciona como un calendario matricial. El objetivo es replicar una tabla donde cada fila corresponde a una materia, debajo de cada materia hay subfilas que representan tipos de actividades (deberes, talleres, labs, pruebas, proyectos) y cada columna corresponde a los días del mes. La intersección entre actividad y día es una celda que puede contener texto como "Parcial", "Prueba P", "Conjunta" o simplemente estar vacía. El encabezado del calendario muestra el mes (por ejemplo, “Diciembre”) y una fila horizontal con los días del mes en formato “Lunes 1, Martes 2, Miércoles 3, …”. La app debe permitir visualizar, editar, agregar y eliminar eventos académicos para cada celda.

Propón y aplica una arquitectura profesional para Flutter. Usa arquitectura limpia (Clean Architecture) con separación en tres capas: Presentation, Domain y Data. Presentation debe usar Provider o Riverpod para la gestión de estado. Domain debe contener entidades, repositorios y casos de uso. Data debe incluir los modelos, adaptadores y la fuente de datos, recomendando Hive o SQLite para almacenamiento local. Toda la estructura debe ser modular, escalable y fácil de mantener.

Define también un modelo de datos adecuado. Cada materia debe tener un nombre y una lista de tipos de actividad. Cada tipo de actividad debe tener un nombre (deberes, talleres, labs, pruebas, proyectos) y un mapa que relacione número de día con contenido textual del evento, por ejemplo: {11: "Parcial"}. Cada entidad debe respetar la arquitectura limpia y tener sus respectivos DTOs para la capa Data.

Describe también la UI. La pantalla principal debe ser una tabla con desplazamiento horizontal y vertical. La primera fila debe ser un “sticky header” con los días del mes. La primera columna debe ser un “sticky sidebar” con las materias y sus subcategorías. Las celdas centrales deben ser editables, presionables o mostrar un diálogo flotante para escribir el contenido del evento. Utiliza una combinación de SingleChildScrollView, Table, DataTable, o un sistema con GridView para optimizar rendimiento. Define estilos limpios: bordes finos, filas separadas por materia, colores suaves y tipografía uniforme.

Incluye la lista completa de materias con sus categorías:

Lectura y Escritura → deberes, talleres, labs, pruebas, proyectos

Sistemas Operativos → deberes, talleres, labs, pruebas, proyectos

Apps Basadas en Conocimiento → deberes, talleres, labs, pruebas, proyectos

Pruebas de Software → deberes, talleres, labs, pruebas, proyectos

Análisis y Diseño → deberes, talleres, labs, pruebas, proyectos

Apps Móviles → deberes, talleres, labs, pruebas, proyectos

La app debe poder generar el calendario de forma dinámica según el mes. El usuario puede seleccionar un mes y el sistema debe calcular automáticamente cuántos días tiene y qué día de la semana inicia. Cada día se mostrará en el encabezado como “Lunes 1, Martes 2…” y debe alinearse correctamente con las celdas.

Finalmente, incluye:

Cómo debe manejarse el estado global.

Cómo debe manejarse la edición de celdas.

Cómo se deben guardar y cargar los datos del calendario.

Cómo debe estar distribuido el proyecto en carpetas.

Cómo se deben diseñar los providers o notifiers.

Cómo se integran los casos de uso.

Cómo se realiza el mapeo entre entidades y DTOs.

Cómo debe ser la experiencia de usuario para navegar y editar la tabla.

![alt text](image.png)