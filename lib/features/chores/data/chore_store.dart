import 'package:flutter/foundation.dart';

enum ChoreType { recurring, scheduled, unscheduled }

enum RecurrenceBehavior { fixed, flexible }

enum ChoreEffort { low, medium, high }

class Chore {
  final String id;
  final String title;
  final String area;
  final ChoreType type;
  final String? recurrence;
  final RecurrenceBehavior recurrenceBehavior;
  final String assignedTo;
  final DateTime? nextDue;
  final bool isActive;
  final bool isDone;
  final DateTime? lastCompletedAt;
  final ChoreEffort effort;
  final DateTime createdAt;

  const Chore({
    required this.id,
    required this.title,
    required this.area,
    required this.type,
    this.recurrence,
    this.recurrenceBehavior = RecurrenceBehavior.fixed,
    required this.assignedTo,
    this.nextDue,
    required this.isActive,
    required this.isDone,
    this.lastCompletedAt,
    this.effort = ChoreEffort.medium,
    required this.createdAt,
  });

  String get scheduleLabel {
    if (type == ChoreType.recurring) return recurrence ?? 'Recurring';
    if (type == ChoreType.scheduled) return 'Scheduled one-off';
    return 'Backlog';
  }

  String get typeLabel {
    switch (type) {
      case ChoreType.recurring:
        return 'Recurring';
      case ChoreType.scheduled:
        return 'Scheduled';
      case ChoreType.unscheduled:
        return 'Backlog';
    }
  }

  bool get hasDueDate => nextDue != null;

  bool get canComplete => type != ChoreType.recurring || nextDue != null;

  bool isOverdue(DateTime now) {
    if (nextDue == null || isDone) return false;
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(nextDue!.year, nextDue!.month, nextDue!.day);
    return due.isBefore(today);
  }

  Chore copyWith({
    String? id,
    String? title,
    String? area,
    ChoreType? type,
    String? recurrence,
    RecurrenceBehavior? recurrenceBehavior,
    String? assignedTo,
    DateTime? nextDue,
    bool clearNextDue = false,
    bool? isActive,
    bool? isDone,
    DateTime? lastCompletedAt,
    bool clearLastCompletedAt = false,
    ChoreEffort? effort,
    DateTime? createdAt,
  }) {
    return Chore(
      id: id ?? this.id,
      title: title ?? this.title,
      area: area ?? this.area,
      type: type ?? this.type,
      recurrence: recurrence ?? this.recurrence,
      recurrenceBehavior: recurrenceBehavior ?? this.recurrenceBehavior,
      assignedTo: assignedTo ?? this.assignedTo,
      nextDue: clearNextDue ? null : nextDue ?? this.nextDue,
      isActive: isActive ?? this.isActive,
      isDone: isDone ?? this.isDone,
      lastCompletedAt: clearLastCompletedAt
          ? null
          : lastCompletedAt ?? this.lastCompletedAt,
      effort: effort ?? this.effort,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class ChoreStore extends ChangeNotifier {
  ChoreStore._();

  static final ChoreStore instance = ChoreStore._();

  final List<Chore> _chores = [
    Chore(
      id: 'plants',
      title: 'Water plants',
      area: 'Living room',
      type: ChoreType.recurring,
      recurrence: 'Every 3 days',
      recurrenceBehavior: RecurrenceBehavior.flexible,
      assignedTo: 'Marc',
      nextDue: DateTime(2026, 6, 3),
      isActive: true,
      isDone: false,
      effort: ChoreEffort.low,
      createdAt: DateTime(2026, 2, 26),
    ),
    Chore(
      id: 'sheets',
      title: 'Change bed sheets',
      area: 'Bedroom',
      type: ChoreType.recurring,
      recurrence: 'Weekly',
      recurrenceBehavior: RecurrenceBehavior.fixed,
      assignedTo: 'Mathilde',
      nextDue: DateTime(2026, 6, 7),
      isActive: true,
      isDone: false,
      effort: ChoreEffort.medium,
      createdAt: DateTime(2026, 2, 26),
    ),
    Chore(
      id: 'fridge',
      title: 'Clean fridge',
      area: 'Kitchen',
      type: ChoreType.recurring,
      recurrence: 'Monthly',
      recurrenceBehavior: RecurrenceBehavior.fixed,
      assignedTo: 'Marc',
      nextDue: DateTime(2026, 6, 20),
      isActive: false,
      isDone: false,
      effort: ChoreEffort.high,
      createdAt: DateTime(2026, 2, 27),
    ),
    Chore(
      id: 'bins',
      title: 'Take out recycling',
      area: 'Utility',
      type: ChoreType.recurring,
      recurrence: 'Tuesdays',
      recurrenceBehavior: RecurrenceBehavior.fixed,
      assignedTo: 'Cody',
      nextDue: DateTime(2026, 6, 2),
      isActive: true,
      isDone: false,
      effort: ChoreEffort.low,
      createdAt: DateTime(2026, 2, 27),
    ),
    Chore(
      id: 'filters',
      title: 'Replace hood filters',
      area: 'Kitchen',
      type: ChoreType.scheduled,
      assignedTo: 'Marc',
      nextDue: DateTime(2026, 6, 12),
      isActive: true,
      isDone: false,
      effort: ChoreEffort.medium,
      createdAt: DateTime(2026, 3, 1),
    ),
    Chore(
      id: 'garage',
      title: 'Sort garage shelf',
      area: 'Garage',
      type: ChoreType.unscheduled,
      assignedTo: 'Marc',
      isActive: true,
      isDone: false,
      effort: ChoreEffort.high,
      createdAt: DateTime(2026, 3, 2),
    ),
  ];

  List<Chore> get chores => List.unmodifiable(_chores);

  List<Chore> get activeChores =>
      _chores
          .where(
            (chore) =>
                chore.isActive &&
                !chore.isDone &&
                chore.type != ChoreType.unscheduled,
          )
          .toList(growable: false)
        ..sort(_compareByDueDate);

  void createChore(Chore chore) {
    _chores.add(chore);
    _sortChores();
    notifyListeners();
  }

  void updateChore(Chore chore) {
    final index = _chores.indexWhere((item) => item.id == chore.id);
    if (index == -1) return;

    _chores[index] = chore;
    _sortChores();
    notifyListeners();
  }

  void deleteChore(String id) {
    _chores.removeWhere((chore) => chore.id == id);
    notifyListeners();
  }

  void toggleActive(String id) {
    final index = _chores.indexWhere((chore) => chore.id == id);
    if (index == -1) return;

    final chore = _chores[index];
    _chores[index] = chore.copyWith(isActive: !chore.isActive);
    notifyListeners();
  }

  void toggleDone(String id) {
    final index = _chores.indexWhere((chore) => chore.id == id);
    if (index == -1) return;

    final chore = _chores[index];
    _chores[index] = chore.copyWith(isDone: !chore.isDone);
    notifyListeners();
  }

  void completeChore(String id, {DateTime? completedAt}) {
    final index = _chores.indexWhere((chore) => chore.id == id);
    if (index == -1) return;

    final chore = _chores[index];
    final completionDate = completedAt ?? DateTime.now();

    if (chore.type == ChoreType.recurring) {
      final nextDue = _calculateNextDue(chore, completionDate);
      _chores[index] = chore.copyWith(
        nextDue: nextDue,
        lastCompletedAt: completionDate,
        isDone: false,
        isActive: true,
      );
    } else {
      _chores[index] = chore.copyWith(
        isDone: true,
        isActive: false,
        lastCompletedAt: completionDate,
      );
    }

    _sortChores();
    notifyListeners();
  }

  String nextId() => DateTime.now().microsecondsSinceEpoch.toString();

  void _sortChores() {
    _chores.sort(_compareByDueDate);
  }

  int _compareByDueDate(Chore a, Chore b) {
    final aDue = a.nextDue;
    final bDue = b.nextDue;
    if (aDue == null && bDue == null) return a.title.compareTo(b.title);
    if (aDue == null) return 1;
    if (bDue == null) return -1;
    return aDue.compareTo(bDue);
  }

  DateTime _calculateNextDue(Chore chore, DateTime completedAt) {
    final anchor = chore.recurrenceBehavior == RecurrenceBehavior.fixed
        ? chore.nextDue ?? completedAt
        : completedAt;
    var nextDue = _addRecurrence(anchor, chore.recurrence);

    if (chore.recurrenceBehavior == RecurrenceBehavior.fixed) {
      while (!nextDue.isAfter(completedAt)) {
        nextDue = _addRecurrence(nextDue, chore.recurrence);
      }
    }

    return DateTime(nextDue.year, nextDue.month, nextDue.day);
  }

  DateTime _addRecurrence(DateTime from, String? recurrence) {
    final rule = recurrence?.toLowerCase().trim() ?? '';
    if (rule.contains('month')) {
      return DateTime(from.year, from.month + 1, from.day);
    }
    if (rule.contains('second')) return from.add(const Duration(days: 14));
    if (rule.contains('week') || rule.endsWith('days')) {
      final dayMatch = RegExp(r'every (\d+) days?').firstMatch(rule);
      final days = dayMatch == null ? 7 : int.parse(dayMatch.group(1)!);
      return from.add(Duration(days: days));
    }
    if (rule.contains('day') || rule.contains('daily')) {
      return from.add(const Duration(days: 1));
    }
    if (rule.contains('tuesday') ||
        rule.contains('monday') ||
        rule.contains('wednesday') ||
        rule.contains('thursday') ||
        rule.contains('friday') ||
        rule.contains('saturday') ||
        rule.contains('sunday')) {
      return from.add(const Duration(days: 7));
    }
    return from.add(const Duration(days: 7));
  }
}
