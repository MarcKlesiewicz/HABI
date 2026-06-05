enum UpcomingEventSource { manual, googleCalendar, airbnb }

enum UpcomingEventCategory { personal, birthday, appointment, airbnb, other }

class UpcomingEvent {
  final String id;
  final String title;
  final DateTime startsAt;
  final DateTime? endsAt;
  final String? description;
  final UpcomingEventSource source;
  final UpcomingEventCategory category;
  final String? sourceId;

  const UpcomingEvent({
    required this.id,
    required this.title,
    required this.startsAt,
    this.endsAt,
    this.description,
    this.source = UpcomingEventSource.manual,
    this.category = UpcomingEventCategory.other,
    this.sourceId,
  });

  bool get isTimed => endsAt != null;
}

Map<DateTime, List<UpcomingEvent>> groupUpcomingEventsByDate(
  List<UpcomingEvent> events,
) {
  final sorted = List<UpcomingEvent>.from(events)
    ..sort((a, b) => a.startsAt.compareTo(b.startsAt));

  final groups = <DateTime, List<UpcomingEvent>>{};
  for (final event in sorted) {
    final key = DateTime(
      event.startsAt.year,
      event.startsAt.month,
      event.startsAt.day,
    );
    groups.putIfAbsent(key, () => []).add(event);
  }

  return groups;
}
