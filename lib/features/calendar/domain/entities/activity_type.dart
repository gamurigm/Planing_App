/// Entidad que representa un tipo de actividad con sus eventos por día
class ActivityType {
  final String name;
  final Map<int, String> events; // día -> contenido

  ActivityType({required this.name, Map<int, String>? events})
    : events = events ?? {};

  ActivityType copyWith({String? name, Map<int, String>? events}) {
    return ActivityType(
      name: name ?? this.name,
      events: events ?? Map.from(this.events),
    );
  }

  ActivityType addEvent(int day, String content) {
    final newEvents = Map<int, String>.from(events);
    newEvents[day] = content;
    return copyWith(events: newEvents);
  }

  ActivityType removeEvent(int day) {
    final newEvents = Map<int, String>.from(events);
    newEvents.remove(day);
    return copyWith(events: newEvents);
  }

  String? getEvent(int day) => events[day];
}
