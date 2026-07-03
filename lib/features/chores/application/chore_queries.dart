import 'package:habi/features/chores/data/chore_store.dart';

enum ChoreView { due, todos, recurring, areas }

class ChoreSummary {
  final int dueCount;
  final int todoCount;
  final int recurringCount;

  const ChoreSummary({
    required this.dueCount,
    required this.todoCount,
    required this.recurringCount,
  });
}

class DashboardChores {
  final List<Chore> today;
  final List<Chore> overdue;

  const DashboardChores({required this.today, required this.overdue});

  int get attentionCount => today.length + overdue.length;
}

List<Chore> choresForView(List<Chore> chores, ChoreView view, {DateTime? now}) {
  final visible = _filterChoresForView(chores, view, now: now);
  return sortChoresForView(visible, view);
}

ChoreSummary summarizeChores(List<Chore> chores, {DateTime? now}) {
  return ChoreSummary(
    dueCount: _dueSoonChores(chores, now: now).length,
    todoCount: chores
        .where((chore) => chore.type == ChoreType.todo && !chore.isDone)
        .length,
    recurringCount: chores
        .where((chore) => chore.type == ChoreType.recurring)
        .length,
  );
}

DashboardChores dashboardChores(List<Chore> chores, {DateTime? now}) {
  final referenceDate = now ?? DateTime.now();
  return DashboardChores(
    today: todayChores(chores, now: referenceDate),
    overdue: overdueChores(chores, now: referenceDate),
  );
}

List<Chore> todayChores(List<Chore> chores, {DateTime? now}) {
  final today = _dateOnly(now ?? DateTime.now());

  return chores
      .where((chore) {
        if (!_isDashboardCandidate(chore)) return false;
        final due = chore.nextDue;
        if (due == null) return false;
        return _dateOnly(due).isAtSameMomentAs(today);
      })
      .toList(growable: false)
    ..sort(compareChoresByNullableDueDate);
}

List<Chore> overdueChores(List<Chore> chores, {DateTime? now}) {
  final referenceDate = now ?? DateTime.now();
  return chores
      .where((chore) {
        if (!_isDashboardCandidate(chore)) return false;
        return chore.isOverdue(referenceDate);
      })
      .toList(growable: false)
    ..sort(compareChoresByNullableDueDate);
}

List<Chore> sortChoresForView(List<Chore> chores, ChoreView view) {
  final sorted = List<Chore>.from(chores);
  sorted.sort((a, b) {
    switch (view) {
      case ChoreView.due:
      case ChoreView.recurring:
        return compareChoresByNullableDueDate(a, b);
      case ChoreView.areas:
        final area = a.area.compareTo(b.area);
        return area == 0 ? compareChoresByNullableDueDate(a, b) : area;
      case ChoreView.todos:
        return b.createdAt.compareTo(a.createdAt);
    }
  });
  return sorted;
}

int compareChoresByNullableDueDate(Chore a, Chore b) {
  final aDue = a.nextDue;
  final bDue = b.nextDue;
  if (aDue == null && bDue == null) return 0;
  if (aDue == null) return 1;
  if (bDue == null) return -1;
  return aDue.compareTo(bDue);
}

List<Chore> _filterChoresForView(
  List<Chore> chores,
  ChoreView view, {
  DateTime? now,
}) {
  switch (view) {
    case ChoreView.due:
      return _dueSoonChores(chores, now: now);
    case ChoreView.todos:
      return chores
          .where((chore) => chore.type == ChoreType.todo && !chore.isDone)
          .toList(growable: false);
    case ChoreView.recurring:
      return chores
          .where((chore) => chore.type == ChoreType.recurring && !chore.isDone)
          .toList(growable: false);
    case ChoreView.areas:
      return chores.where((chore) => !chore.isDone).toList(growable: false);
  }
}

List<Chore> _dueSoonChores(List<Chore> chores, {DateTime? now}) {
  final today = _dateOnly(now ?? DateTime.now());
  final comingSoon = today.add(const Duration(days: 14));

  return chores
      .where((chore) {
        if (chore.isDone) return false;
        final due = chore.nextDue;
        if (due == null) return false;
        final dueDay = _dateOnly(due);
        return dueDay.isBefore(comingSoon) ||
            dueDay.isAtSameMomentAs(comingSoon);
      })
      .toList(growable: false);
}

bool _isDashboardCandidate(Chore chore) {
  return chore.isActive && !chore.isDone && chore.nextDue != null;
}

DateTime _dateOnly(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}
