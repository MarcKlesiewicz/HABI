import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habi/core/firebase/firebase_bootstrap.dart';
import 'package:habi/features/chores/data/chore_store.dart';

abstract class ChoreRepository {
  Stream<List<Chore>> watchChores();
  Future<void> createChore(Chore chore);
  Future<void> updateChore(Chore chore);
  Future<void> deleteChore(String id);
}

class FirestoreChoreRepository implements ChoreRepository {
  FirestoreChoreRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('chores');

  @override
  Stream<List<Chore>> watchChores() async* {
    await ensureFirebaseSignedIn();
    yield* _collection.snapshots().map((snapshot) {
      final chores = snapshot.docs
          .map((document) => _choreFromDocument(document))
          .toList(growable: false);
      return List<Chore>.from(chores)..sort(compareChoresByDueDate);
    });
  }

  @override
  Future<void> createChore(Chore chore) async {
    await ensureFirebaseSignedIn();
    return _collection.doc(chore.id).set(_choreToDocument(chore));
  }

  @override
  Future<void> updateChore(Chore chore) async {
    await ensureFirebaseSignedIn();
    return _collection.doc(chore.id).set(_choreToDocument(chore));
  }

  @override
  Future<void> deleteChore(String id) async {
    await ensureFirebaseSignedIn();
    return _collection.doc(id).delete();
  }
}

class LocalChoreRepository implements ChoreRepository {
  LocalChoreRepository()
    : _chores = List<Chore>.from(initialChores)..sort(compareChoresByDueDate) {
    _controller.add(List.unmodifiable(_chores));
  }

  final List<Chore> _chores;
  final _controller = StreamController<List<Chore>>.broadcast();

  @override
  Stream<List<Chore>> watchChores() async* {
    yield List.unmodifiable(_chores);
    yield* _controller.stream;
  }

  @override
  Future<void> createChore(Chore chore) async {
    _chores.add(chore);
    _emit();
  }

  @override
  Future<void> updateChore(Chore chore) async {
    final index = _chores.indexWhere((item) => item.id == chore.id);
    if (index == -1) return;
    _chores[index] = chore;
    _emit();
  }

  @override
  Future<void> deleteChore(String id) async {
    _chores.removeWhere((chore) => chore.id == id);
    _emit();
  }

  void _emit() {
    _chores.sort(compareChoresByDueDate);
    _controller.add(List.unmodifiable(_chores));
  }
}

ChoreRepository createChoreRepository() {
  if (isFirebaseAvailable) return FirestoreChoreRepository();
  return LocalChoreRepository();
}

Chore _choreFromDocument(QueryDocumentSnapshot<Map<String, dynamic>> document) {
  final data = document.data();
  return Chore(
    id: document.id,
    title: data['title'] as String? ?? '',
    area: _knownValue(data['area'], choreAreas, defaultChoreArea),
    type: _choreTypeFromName(data['type']),
    recurrence: data['recurrence'] as String?,
    recurrenceRule: _recurrenceRuleFromDocument(data['recurrenceRule']),
    recurrenceBehavior: _enumFromName(
      RecurrenceBehavior.values,
      data['recurrenceBehavior'],
      RecurrenceBehavior.fixed,
    ),
    assignedTo: _knownValue(
      data['assignedTo'],
      choreOwners,
      unassignedChoreOwner,
    ),
    nextDue: _dateTimeFromTimestamp(data['nextDue']),
    isActive: data['isActive'] as bool? ?? true,
    isDone: data['isDone'] as bool? ?? false,
    lastCompletedAt: _dateTimeFromTimestamp(data['lastCompletedAt']),
    createdAt: _dateTimeFromTimestamp(data['createdAt']) ?? DateTime.now(),
  );
}

Map<String, dynamic> _choreToDocument(Chore chore) {
  return {
    'title': chore.title,
    'area': chore.area,
    'type': chore.type.name,
    'recurrence': chore.recurrenceRule?.label ?? chore.recurrence,
    'recurrenceRule': _recurrenceRuleToDocument(chore.recurrenceRule),
    'recurrenceBehavior': chore.recurrenceBehavior.name,
    'assignedTo': chore.assignedTo,
    'nextDue': _timestampFromDateTime(chore.nextDue),
    'isActive': chore.isActive,
    'isDone': chore.isDone,
    'lastCompletedAt': _timestampFromDateTime(chore.lastCompletedAt),
    'createdAt': _timestampFromDateTime(chore.createdAt),
  };
}

T _enumFromName<T extends Enum>(List<T> values, Object? name, T fallback) {
  if (name is! String) return fallback;
  for (final value in values) {
    if (value.name == name) return value;
  }
  return fallback;
}

ChoreType _choreTypeFromName(Object? name) {
  if (name == ChoreType.recurring.name) return ChoreType.recurring;
  return ChoreType.todo;
}

String _knownValue(Object? value, List<String> allowedValues, String fallback) {
  if (value is! String) return fallback;
  final trimmed = value.trim();
  for (final allowedValue in allowedValues) {
    if (allowedValue.toLowerCase() == trimmed.toLowerCase()) {
      return allowedValue;
    }
  }
  return fallback;
}

RecurrenceRule? _recurrenceRuleFromDocument(Object? value) {
  if (value is! Map) return null;
  final frequency = _enumFromName(
    RecurrenceFrequency.values,
    value['frequency'],
    RecurrenceFrequency.weekly,
  );
  final monthlyKind = _enumFromName(
    MonthlyRecurrenceKind.values,
    value['monthlyKind'],
    MonthlyRecurrenceKind.dayOfMonth,
  );
  return RecurrenceRule(
    frequency: frequency,
    interval: _intFromValue(value['interval'], 1),
    weekday: _nullableIntFromValue(value['weekday']),
    monthlyKind: value['monthlyKind'] == null ? null : monthlyKind,
    dayOfMonth: _nullableIntFromValue(value['dayOfMonth']),
    weekOfMonth: _nullableIntFromValue(value['weekOfMonth']),
  ).normalized();
}

Map<String, dynamic>? _recurrenceRuleToDocument(RecurrenceRule? rule) {
  if (rule == null) return null;
  final normalized = rule.normalized();
  return {
    'frequency': normalized.frequency.name,
    'interval': normalized.interval,
    'weekday': normalized.weekday,
    'monthlyKind': normalized.monthlyKind?.name,
    'dayOfMonth': normalized.dayOfMonth,
    'weekOfMonth': normalized.weekOfMonth,
  };
}

int _intFromValue(Object? value, int fallback) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return fallback;
}

int? _nullableIntFromValue(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return null;
}

DateTime? _dateTimeFromTimestamp(Object? value) {
  if (value is Timestamp) return value.toDate();
  return null;
}

Timestamp? _timestampFromDateTime(DateTime? value) {
  if (value == null) return null;
  return Timestamp.fromDate(value);
}
