enum ChoreType { recurring, todo }

enum RecurrenceBehavior { fixed, flexible }

enum RecurrenceFrequency { daily, weekly, monthly }

enum MonthlyRecurrenceKind { dayOfMonth, nthWeekday, lastWeekday }

const unassignedChoreOwner = 'Unassigned';
const defaultChoreArea = 'Lykkeh\u00f8j';

const choreOwners = <String>[unassignedChoreOwner, 'Marc', 'Mathilde', 'Cody'];

const choreAreas = <String>[
  defaultChoreArea,
  'Kitchen',
  'Garden',
  'Living Room',
  'Stable',
  'Garage',
];

class RecurrenceRule {
  final RecurrenceFrequency frequency;
  final int interval;
  final int? weekday;
  final MonthlyRecurrenceKind? monthlyKind;
  final int? dayOfMonth;
  final int? weekOfMonth;

  const RecurrenceRule({
    required this.frequency,
    this.interval = 1,
    this.weekday,
    this.monthlyKind,
    this.dayOfMonth,
    this.weekOfMonth,
  });

  const RecurrenceRule.daily({this.interval = 1})
    : frequency = RecurrenceFrequency.daily,
      weekday = null,
      monthlyKind = null,
      dayOfMonth = null,
      weekOfMonth = null;

  const RecurrenceRule.weekly({
    this.interval = 1,
    this.weekday = DateTime.monday,
  }) : frequency = RecurrenceFrequency.weekly,
       monthlyKind = null,
       dayOfMonth = null,
       weekOfMonth = null;

  const RecurrenceRule.monthlyDay({this.interval = 1, this.dayOfMonth = 1})
    : frequency = RecurrenceFrequency.monthly,
      weekday = null,
      monthlyKind = MonthlyRecurrenceKind.dayOfMonth,
      weekOfMonth = null;

  const RecurrenceRule.monthlyNthWeekday({
    this.interval = 1,
    this.weekOfMonth = 1,
    this.weekday = DateTime.monday,
  }) : frequency = RecurrenceFrequency.monthly,
       monthlyKind = MonthlyRecurrenceKind.nthWeekday,
       dayOfMonth = null;

  const RecurrenceRule.monthlyLastWeekday({
    this.interval = 1,
    this.weekday = DateTime.monday,
  }) : frequency = RecurrenceFrequency.monthly,
       monthlyKind = MonthlyRecurrenceKind.lastWeekday,
       dayOfMonth = null,
       weekOfMonth = null;

  String get label {
    final cadence = interval == 1 ? 'Every' : 'Every $interval';
    switch (frequency) {
      case RecurrenceFrequency.daily:
        return interval == 1 ? 'Every day' : 'Every $interval days';
      case RecurrenceFrequency.weekly:
        final unit = interval == 1 ? 'week' : 'weeks';
        return '$cadence $unit on ${weekdayLabel(weekday ?? DateTime.monday)}';
      case RecurrenceFrequency.monthly:
        final unit = interval == 1 ? 'month' : 'months';
        switch (monthlyKind ?? MonthlyRecurrenceKind.dayOfMonth) {
          case MonthlyRecurrenceKind.dayOfMonth:
            return '$cadence $unit on day ${dayOfMonth ?? 1}';
          case MonthlyRecurrenceKind.nthWeekday:
            return '$cadence $unit on the ${ordinalLabel(weekOfMonth ?? 1)} ${weekdayLabel(weekday ?? DateTime.monday)}';
          case MonthlyRecurrenceKind.lastWeekday:
            return '$cadence $unit on the last ${weekdayLabel(weekday ?? DateTime.monday)}';
        }
    }
  }

  RecurrenceRule copyWith({
    RecurrenceFrequency? frequency,
    int? interval,
    int? weekday,
    MonthlyRecurrenceKind? monthlyKind,
    int? dayOfMonth,
    int? weekOfMonth,
  }) {
    return RecurrenceRule(
      frequency: frequency ?? this.frequency,
      interval: interval ?? this.interval,
      weekday: weekday ?? this.weekday,
      monthlyKind: monthlyKind ?? this.monthlyKind,
      dayOfMonth: dayOfMonth ?? this.dayOfMonth,
      weekOfMonth: weekOfMonth ?? this.weekOfMonth,
    ).normalized();
  }

  RecurrenceRule normalized() {
    final safeInterval = interval < 1 ? 1 : interval;
    switch (frequency) {
      case RecurrenceFrequency.daily:
        return RecurrenceRule.daily(interval: safeInterval);
      case RecurrenceFrequency.weekly:
        return RecurrenceRule.weekly(
          interval: safeInterval,
          weekday: _clampInt(weekday ?? DateTime.monday, 1, 7),
        );
      case RecurrenceFrequency.monthly:
        final kind = monthlyKind ?? MonthlyRecurrenceKind.dayOfMonth;
        switch (kind) {
          case MonthlyRecurrenceKind.dayOfMonth:
            return RecurrenceRule.monthlyDay(
              interval: safeInterval,
              dayOfMonth: _clampInt(dayOfMonth ?? 1, 1, 31),
            );
          case MonthlyRecurrenceKind.nthWeekday:
            return RecurrenceRule.monthlyNthWeekday(
              interval: safeInterval,
              weekOfMonth: _clampInt(weekOfMonth ?? 1, 1, 4),
              weekday: _clampInt(weekday ?? DateTime.monday, 1, 7),
            );
          case MonthlyRecurrenceKind.lastWeekday:
            return RecurrenceRule.monthlyLastWeekday(
              interval: safeInterval,
              weekday: _clampInt(weekday ?? DateTime.monday, 1, 7),
            );
        }
    }
  }
}

const defaultRecurrenceRule = RecurrenceRule.weekly();

class Chore {
  final String id;
  final String title;
  final String area;
  final ChoreType type;
  final String? recurrence;
  final RecurrenceRule? recurrenceRule;
  final RecurrenceBehavior recurrenceBehavior;
  final String assignedTo;
  final DateTime? nextDue;
  final bool isActive;
  final bool isDone;
  final DateTime? lastCompletedAt;
  final DateTime createdAt;

  const Chore({
    required this.id,
    required this.title,
    required this.area,
    required this.type,
    this.recurrence,
    this.recurrenceRule,
    this.recurrenceBehavior = RecurrenceBehavior.fixed,
    required this.assignedTo,
    this.nextDue,
    required this.isActive,
    required this.isDone,
    this.lastCompletedAt,
    required this.createdAt,
  });

  String get scheduleLabel {
    if (type == ChoreType.recurring) {
      return recurrenceRule?.label ?? recurrence ?? 'Recurring';
    }
    return nextDue == null ? 'Backlog' : 'Scheduled todo';
  }

  String get typeLabel {
    switch (type) {
      case ChoreType.recurring:
        return 'Recurring';
      case ChoreType.todo:
        return nextDue == null ? 'Backlog' : 'Scheduled';
    }
  }

  bool get hasDueDate => nextDue != null;

  bool get canComplete => type == ChoreType.todo || nextDue != null;

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
    RecurrenceRule? recurrenceRule,
    RecurrenceBehavior? recurrenceBehavior,
    String? assignedTo,
    DateTime? nextDue,
    bool clearNextDue = false,
    bool? isActive,
    bool? isDone,
    DateTime? lastCompletedAt,
    bool clearLastCompletedAt = false,
    DateTime? createdAt,
  }) {
    return Chore(
      id: id ?? this.id,
      title: title ?? this.title,
      area: area ?? this.area,
      type: type ?? this.type,
      recurrence: recurrence ?? this.recurrence,
      recurrenceRule: recurrenceRule ?? this.recurrenceRule,
      recurrenceBehavior: recurrenceBehavior ?? this.recurrenceBehavior,
      assignedTo: assignedTo ?? this.assignedTo,
      nextDue: clearNextDue ? null : nextDue ?? this.nextDue,
      isActive: isActive ?? this.isActive,
      isDone: isDone ?? this.isDone,
      lastCompletedAt: clearLastCompletedAt
          ? null
          : lastCompletedAt ?? this.lastCompletedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

final initialChores = <Chore>[
  Chore(
    id: 'plants',
    title: 'Water plants',
    area: 'Living Room',
    type: ChoreType.recurring,
    recurrence: 'Every 3 days',
    recurrenceRule: const RecurrenceRule.daily(interval: 3),
    recurrenceBehavior: RecurrenceBehavior.flexible,
    assignedTo: 'Marc',
    nextDue: DateTime(2026, 6, 3),
    isActive: true,
    isDone: false,
    createdAt: DateTime(2026, 2, 26),
  ),
  Chore(
    id: 'sheets',
    title: 'Change bed sheets',
    area: defaultChoreArea,
    type: ChoreType.recurring,
    recurrence: 'Weekly',
    recurrenceRule: const RecurrenceRule.weekly(weekday: DateTime.sunday),
    recurrenceBehavior: RecurrenceBehavior.fixed,
    assignedTo: 'Mathilde',
    nextDue: DateTime(2026, 6, 7),
    isActive: true,
    isDone: false,
    createdAt: DateTime(2026, 2, 26),
  ),
  Chore(
    id: 'fridge',
    title: 'Clean fridge',
    area: 'Kitchen',
    type: ChoreType.recurring,
    recurrence: 'Monthly',
    recurrenceRule: const RecurrenceRule.monthlyDay(dayOfMonth: 20),
    recurrenceBehavior: RecurrenceBehavior.fixed,
    assignedTo: 'Marc',
    nextDue: DateTime(2026, 6, 20),
    isActive: false,
    isDone: false,
    createdAt: DateTime(2026, 2, 27),
  ),
  Chore(
    id: 'bins',
    title: 'Take out recycling',
    area: defaultChoreArea,
    type: ChoreType.recurring,
    recurrence: 'Tuesdays',
    recurrenceRule: const RecurrenceRule.weekly(weekday: DateTime.tuesday),
    recurrenceBehavior: RecurrenceBehavior.fixed,
    assignedTo: 'Cody',
    nextDue: DateTime(2026, 6, 2),
    isActive: true,
    isDone: false,
    createdAt: DateTime(2026, 2, 27),
  ),
  Chore(
    id: 'filters',
    title: 'Replace hood filters',
    area: 'Kitchen',
    type: ChoreType.todo,
    assignedTo: 'Marc',
    nextDue: DateTime(2026, 6, 12),
    isActive: true,
    isDone: false,
    createdAt: DateTime(2026, 3, 1),
  ),
  Chore(
    id: 'garage',
    title: 'Sort garage shelf',
    area: 'Garage',
    type: ChoreType.todo,
    assignedTo: 'Marc',
    isActive: true,
    isDone: false,
    createdAt: DateTime(2026, 3, 2),
  ),
];

String nextChoreId() => DateTime.now().microsecondsSinceEpoch.toString();

int compareChoresByDueDate(Chore a, Chore b) {
  final aDue = a.nextDue;
  final bDue = b.nextDue;
  if (aDue == null && bDue == null) return a.title.compareTo(b.title);
  if (aDue == null) return 1;
  if (bDue == null) return -1;
  return aDue.compareTo(bDue);
}

class ChoreScheduler {
  const ChoreScheduler();

  Chore complete(Chore chore, {DateTime? completedAt}) {
    final completionDate = completedAt ?? DateTime.now();

    if (chore.type == ChoreType.recurring) {
      return chore.copyWith(
        nextDue: _calculateNextDue(chore, completionDate),
        lastCompletedAt: completionDate,
        isDone: false,
        isActive: true,
      );
    }

    return chore.copyWith(
      isDone: true,
      isActive: false,
      lastCompletedAt: completionDate,
    );
  }

  DateTime _calculateNextDue(Chore chore, DateTime completedAt) {
    final anchor = chore.recurrenceBehavior == RecurrenceBehavior.fixed
        ? chore.nextDue ?? completedAt
        : completedAt;
    var nextDue = _nextFromRule(anchor, chore.recurrenceRule);

    if (chore.recurrenceBehavior == RecurrenceBehavior.fixed) {
      while (!nextDue.isAfter(completedAt)) {
        nextDue = _nextFromRule(nextDue, chore.recurrenceRule);
      }
    }

    return DateTime(nextDue.year, nextDue.month, nextDue.day);
  }

  DateTime _nextFromRule(DateTime from, RecurrenceRule? rule) {
    final normalized = (rule ?? defaultRecurrenceRule).normalized();
    final date = DateTime(from.year, from.month, from.day);

    switch (normalized.frequency) {
      case RecurrenceFrequency.daily:
        return date.add(Duration(days: normalized.interval));
      case RecurrenceFrequency.weekly:
        final nextWeek = date.add(Duration(days: normalized.interval * 7));
        return _moveToWeekday(nextWeek, normalized.weekday ?? DateTime.monday);
      case RecurrenceFrequency.monthly:
        return _nextMonthlyDate(date, normalized);
    }
  }
}

DateTime _nextMonthlyDate(DateTime from, RecurrenceRule rule) {
  final targetMonth = DateTime(from.year, from.month + rule.interval, 1);
  switch (rule.monthlyKind ?? MonthlyRecurrenceKind.dayOfMonth) {
    case MonthlyRecurrenceKind.dayOfMonth:
      final day = _clampInt(
        rule.dayOfMonth ?? 1,
        1,
        _daysInMonth(targetMonth.year, targetMonth.month),
      );
      return DateTime(targetMonth.year, targetMonth.month, day);
    case MonthlyRecurrenceKind.nthWeekday:
      return _nthWeekdayOfMonth(
        targetMonth.year,
        targetMonth.month,
        rule.weekday ?? DateTime.monday,
        rule.weekOfMonth ?? 1,
      );
    case MonthlyRecurrenceKind.lastWeekday:
      return _lastWeekdayOfMonth(
        targetMonth.year,
        targetMonth.month,
        rule.weekday ?? DateTime.monday,
      );
  }
}

DateTime _moveToWeekday(DateTime date, int weekday) {
  final offset = (weekday - date.weekday) % 7;
  return date.add(Duration(days: offset));
}

DateTime _nthWeekdayOfMonth(int year, int month, int weekday, int weekOfMonth) {
  final firstDay = DateTime(year, month, 1);
  final firstWeekday = _moveToWeekday(firstDay, weekday);
  final candidate = firstWeekday.add(Duration(days: (weekOfMonth - 1) * 7));
  if (candidate.month == month) return candidate;
  return _lastWeekdayOfMonth(year, month, weekday);
}

DateTime _lastWeekdayOfMonth(int year, int month, int weekday) {
  var day = DateTime(year, month + 1, 0);
  while (day.weekday != weekday) {
    day = day.subtract(const Duration(days: 1));
  }
  return day;
}

int _daysInMonth(int year, int month) => DateTime(year, month + 1, 0).day;

int _clampInt(int value, int min, int max) {
  if (value < min) return min;
  if (value > max) return max;
  return value;
}

String weekdayLabel(int weekday) {
  switch (weekday) {
    case DateTime.monday:
      return 'Monday';
    case DateTime.tuesday:
      return 'Tuesday';
    case DateTime.wednesday:
      return 'Wednesday';
    case DateTime.thursday:
      return 'Thursday';
    case DateTime.friday:
      return 'Friday';
    case DateTime.saturday:
      return 'Saturday';
    case DateTime.sunday:
      return 'Sunday';
    default:
      return 'Monday';
  }
}

String ordinalLabel(int value) {
  switch (value) {
    case 1:
      return 'first';
    case 2:
      return 'second';
    case 3:
      return 'third';
    case 4:
      return 'fourth';
    default:
      return '${value}th';
  }
}
