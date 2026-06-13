import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habi/features/airbnb/airbnb_reservation_store.dart';
import 'package:habi/features/upcoming_events/data/upcoming_event.dart';
import 'package:habi/features/upcoming_events/data/upcoming_event_repository.dart';

final upcomingEventRepositoryProvider = Provider<UpcomingEventRepository>((
  ref,
) {
  return createUpcomingEventRepository();
});

final manualUpcomingEventsProvider = StreamProvider<List<UpcomingEvent>>((ref) {
  return ref.watch(upcomingEventRepositoryProvider).watchManualEvents();
});

final calendarEventsProvider = StreamProvider<List<UpcomingEvent>>((ref) {
  final manualEvents =
      ref.watch(manualUpcomingEventsProvider).value ?? const [];
  final now = DateTime.now();

  final events = <UpcomingEvent>[
    ..._expandManualEvents(
      manualEvents,
      startYear: now.year - 5,
      endYear: now.year + 10,
    ),
    ...AirbnbReservationStore.upcoming.expand(_eventsFromReservation),
  ];

  return Stream.value(
    List<UpcomingEvent>.from(events)
      ..sort((a, b) => a.startsAt.compareTo(b.startsAt)),
  );
});

final upcomingEventsProvider = StreamProvider<List<UpcomingEvent>>((ref) {
  final events = ref.watch(calendarEventsProvider).value ?? const [];
  final now = DateTime.now();
  final startOfToday = DateTime(now.year, now.month, now.day);

  return Stream.value(
    events
        .where((event) => !event.startsAt.isBefore(startOfToday))
        .toList(growable: false),
  );
});

Iterable<UpcomingEvent> _expandManualEvents(
  List<UpcomingEvent> events, {
  required int startYear,
  required int endYear,
}) sync* {
  for (final event in events) {
    if (event.recurrence != UpcomingEventRecurrence.yearly) {
      yield event;
      continue;
    }

    for (var year = startYear; year <= endYear; year++) {
      final startsAt = _sameDateInYear(event.startsAt, year);
      if (startsAt == null) continue;

      final endsAt = event.endsAt == null
          ? null
          : startsAt.add(event.endsAt!.difference(event.startsAt));

      yield event.copyWith(
        id: '${event.id}-$year',
        startsAt: startsAt,
        endsAt: endsAt,
        clearEndsAt: endsAt == null,
        sourceId: event.id,
      );
    }
  }
}

DateTime? _sameDateInYear(DateTime date, int year) {
  if (date.month == DateTime.february && date.day == 29 && !_isLeapYear(year)) {
    return null;
  }

  return DateTime(
    year,
    date.month,
    date.day,
    date.hour,
    date.minute,
    date.second,
    date.millisecond,
    date.microsecond,
  );
}

bool _isLeapYear(int year) {
  return (year % 4 == 0 && year % 100 != 0) || year % 400 == 0;
}

final upcomingEventControllerProvider = Provider<UpcomingEventController>((
  ref,
) {
  return UpcomingEventController(ref);
});

Iterable<UpcomingEvent> _eventsFromReservation(
  AirbnbReservation reservation,
) sync* {
  yield UpcomingEvent(
    id: 'airbnb-${reservation.confirmationCode}-check-in',
    title: reservation.guest,
    startsAt: DateTime(
      reservation.checkIn.year,
      reservation.checkIn.month,
      reservation.checkIn.day,
      15,
    ),
    description:
        '${reservation.nights} ${reservation.nights == 1 ? 'night' : 'nights'} - ${reservation.guestCount} ${reservation.guestCount == 1 ? 'person' : 'people'}',
    source: UpcomingEventSource.airbnb,
    category: UpcomingEventCategory.airbnb,
    sourceId: reservation.confirmationCode,
    createdAt: reservation.bookingDate,
  );
}

class UpcomingEventController {
  UpcomingEventController(this._ref);

  final Ref _ref;

  UpcomingEventRepository get _repository =>
      _ref.read(upcomingEventRepositoryProvider);

  Future<void> createEvent(UpcomingEvent event) {
    return _repository.createEvent(
      event.copyWith(source: UpcomingEventSource.manual, clearSourceId: true),
    );
  }

  Future<void> updateEvent(UpcomingEvent event) {
    if (!event.canEdit) return Future.value();
    return _repository.updateEvent(
      event.copyWith(id: event.editableId, clearSourceId: true),
    );
  }

  Future<void> deleteEvent(UpcomingEvent event) {
    if (!event.canEdit) return Future.value();
    return _repository.deleteEvent(event.editableId);
  }
}
