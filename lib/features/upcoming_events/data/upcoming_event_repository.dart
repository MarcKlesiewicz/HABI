import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habi/core/firebase/firebase_bootstrap.dart';
import 'package:habi/features/upcoming_events/data/upcoming_event.dart';

abstract class UpcomingEventRepository {
  Stream<List<UpcomingEvent>> watchManualEvents();
  Future<void> createEvent(UpcomingEvent event);
  Future<void> updateEvent(UpcomingEvent event);
  Future<void> deleteEvent(String id);
}

class FirestoreUpcomingEventRepository implements UpcomingEventRepository {
  FirestoreUpcomingEventRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('events');

  @override
  Stream<List<UpcomingEvent>> watchManualEvents() async* {
    await ensureFirebaseSignedIn();
    yield* _collection.snapshots().map((snapshot) {
      final events = snapshot.docs
          .map((document) => _eventFromDocument(document))
          .toList(growable: false);
      return List<UpcomingEvent>.from(events)..sort(_compareEvents);
    });
  }

  @override
  Future<void> createEvent(UpcomingEvent event) async {
    await ensureFirebaseSignedIn();
    return _collection.doc(event.id).set(_eventToDocument(event));
  }

  @override
  Future<void> updateEvent(UpcomingEvent event) async {
    await ensureFirebaseSignedIn();
    return _collection.doc(event.id).set(_eventToDocument(event));
  }

  @override
  Future<void> deleteEvent(String id) async {
    await ensureFirebaseSignedIn();
    return _collection.doc(id).delete();
  }
}

class LocalUpcomingEventRepository implements UpcomingEventRepository {
  LocalUpcomingEventRepository()
    : _events = List<UpcomingEvent>.from(_initialEvents)..sort(_compareEvents) {
    _controller.add(List.unmodifiable(_events));
  }

  final List<UpcomingEvent> _events;
  final _controller = StreamController<List<UpcomingEvent>>.broadcast();

  @override
  Stream<List<UpcomingEvent>> watchManualEvents() async* {
    yield List.unmodifiable(_events);
    yield* _controller.stream;
  }

  @override
  Future<void> createEvent(UpcomingEvent event) async {
    _events.add(event);
    _emit();
  }

  @override
  Future<void> updateEvent(UpcomingEvent event) async {
    final index = _events.indexWhere((item) => item.id == event.id);
    if (index == -1) return;
    _events[index] = event;
    _emit();
  }

  @override
  Future<void> deleteEvent(String id) async {
    _events.removeWhere((event) => event.id == id);
    _emit();
  }

  void _emit() {
    _events.sort(_compareEvents);
    _controller.add(List.unmodifiable(_events));
  }
}

UpcomingEventRepository createUpcomingEventRepository() {
  if (isFirebaseAvailable) return FirestoreUpcomingEventRepository();
  return LocalUpcomingEventRepository();
}

UpcomingEvent _eventFromDocument(
  QueryDocumentSnapshot<Map<String, dynamic>> document,
) {
  final data = document.data();
  return UpcomingEvent(
    id: document.id,
    title: data['title'] as String? ?? '',
    startsAt: _dateTimeFromTimestamp(data['startsAt']) ?? DateTime.now(),
    endsAt: _dateTimeFromTimestamp(data['endsAt']),
    description: _nullableTrimmed(data['description']),
    source: UpcomingEventSource.manual,
    category: _enumFromName(
      UpcomingEventCategory.values,
      data['category'],
      UpcomingEventCategory.other,
    ),
    createdAt: _dateTimeFromTimestamp(data['createdAt']) ?? DateTime.now(),
  );
}

Map<String, dynamic> _eventToDocument(UpcomingEvent event) {
  return {
    'title': event.title,
    'startsAt': Timestamp.fromDate(event.startsAt),
    'endsAt': event.endsAt == null ? null : Timestamp.fromDate(event.endsAt!),
    'description': event.description,
    'source': UpcomingEventSource.manual.name,
    'category': event.category.name,
    'createdAt': Timestamp.fromDate(event.createdAt),
  };
}

T _enumFromName<T extends Enum>(List<T> values, Object? name, T fallback) {
  if (name is! String) return fallback;
  for (final value in values) {
    if (value.name == name) return value;
  }
  return fallback;
}

DateTime? _dateTimeFromTimestamp(Object? value) {
  if (value is Timestamp) return value.toDate();
  return null;
}

String? _nullableTrimmed(Object? value) {
  if (value is! String) return null;
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}

int _compareEvents(UpcomingEvent a, UpcomingEvent b) {
  return a.startsAt.compareTo(b.startsAt);
}

final _initialEvents = <UpcomingEvent>[
  UpcomingEvent(
    id: 'birthday-mom-2026',
    title: 'Moms birthday',
    startsAt: DateTime(2026, 6, 15, 10),
    endsAt: DateTime(2026, 6, 15, 11),
    category: UpcomingEventCategory.birthday,
    createdAt: DateTime(2026, 6, 5),
  ),
  UpcomingEvent(
    id: 'dentist-2026-06-17',
    title: 'Dentist appointment',
    startsAt: DateTime(2026, 6, 17, 9),
    endsAt: DateTime(2026, 6, 17, 9, 30),
    category: UpcomingEventCategory.appointment,
    createdAt: DateTime(2026, 6, 5),
  ),
];
