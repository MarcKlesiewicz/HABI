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
  final DateTime createdAt;

  const UpcomingEvent({
    required this.id,
    required this.title,
    required this.startsAt,
    this.endsAt,
    this.description,
    this.source = UpcomingEventSource.manual,
    this.category = UpcomingEventCategory.other,
    this.sourceId,
    required this.createdAt,
  });

  bool get isTimed => endsAt != null;
  bool get canEdit => source == UpcomingEventSource.manual;

  UpcomingEvent copyWith({
    String? id,
    String? title,
    DateTime? startsAt,
    DateTime? endsAt,
    bool clearEndsAt = false,
    String? description,
    bool clearDescription = false,
    UpcomingEventSource? source,
    UpcomingEventCategory? category,
    String? sourceId,
    bool clearSourceId = false,
    DateTime? createdAt,
  }) {
    return UpcomingEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      startsAt: startsAt ?? this.startsAt,
      endsAt: clearEndsAt ? null : endsAt ?? this.endsAt,
      description: clearDescription ? null : description ?? this.description,
      source: source ?? this.source,
      category: category ?? this.category,
      sourceId: clearSourceId ? null : sourceId ?? this.sourceId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

String nextUpcomingEventId() {
  return 'event-${DateTime.now().microsecondsSinceEpoch}';
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
