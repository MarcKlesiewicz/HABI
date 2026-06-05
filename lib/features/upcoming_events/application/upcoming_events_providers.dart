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

  final events = <UpcomingEvent>[
    ...manualEvents,
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
    title: 'Airbnb check-in',
    startsAt: reservation.checkIn,
    description:
        '${reservation.guest}, ${reservation.nights} night${reservation.nights == 1 ? '' : 's'}',
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
    return _repository.updateEvent(event);
  }

  Future<void> deleteEvent(UpcomingEvent event) {
    if (!event.canEdit) return Future.value();
    return _repository.deleteEvent(event.id);
  }
}
