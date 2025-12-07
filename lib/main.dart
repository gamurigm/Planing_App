import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'features/calendar/presentation/pages/calendar_page.dart';
import 'features/calendar/data/models/subject_model.dart';
import 'features/calendar/data/models/activity_type_model.dart';
import 'features/calendar/data/models/event_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Hive
  await Hive.initFlutter();

  // Registrar adaptadores
  Hive.registerAdapter(SubjectModelAdapter());
  Hive.registerAdapter(ActivityTypeModelAdapter());
  Hive.registerAdapter(EventModelAdapter());

  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendario Académico',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const CalendarPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
