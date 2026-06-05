import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habi/features/airbnb/airbnb_reservation_store.dart';
import 'package:habi/features/upcoming_events/data/upcoming_event.dart';

final upcomingEventsProvider = Provider<List<UpcomingEvent>>((ref) {
  final now = DateTime.now();
  final startOfToday = DateTime(now.year, now.month, now.day);

  final events = <UpcomingEvent>[
    UpcomingEvent(
      id: 'birthday-mom-2026',
      title: 'Moms birthday',
      startsAt: DateTime(2026, 6, 15, 10),
      endsAt: DateTime(2026, 6, 15, 11),
      category: UpcomingEventCategory.birthday,
    ),
    UpcomingEvent(
      id: 'dentist-2026-06-17',
      title: 'Dentist appointment',
      startsAt: DateTime(2026, 6, 17, 9),
      endsAt: DateTime(2026, 6, 17, 9, 30),
      category: UpcomingEventCategory.appointment,
    ),
    ...AirbnbReservationStore.upcoming.expand(_eventsFromReservation),
  ];

  return events
      .where((event) => !event.startsAt.isBefore(startOfToday))
      .toList()
    ..sort((a, b) => a.startsAt.compareTo(b.startsAt));
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
  );
}
