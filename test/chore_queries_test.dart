import 'package:flutter_test/flutter_test.dart';
import 'package:habi/features/chores/application/chore_queries.dart';
import 'package:habi/features/chores/data/chore_store.dart';

void main() {
  group('choresForView', () {
    test('returns incomplete chores due within the next 14 days', () {
      final now = DateTime(2026, 7, 3, 12);
      final chores = [
        _chore(id: 'today', title: 'Today', nextDue: DateTime(2026, 7, 3)),
        _chore(id: 'future', title: 'Future', nextDue: DateTime(2026, 7, 17)),
        _chore(id: 'later', title: 'Later', nextDue: DateTime(2026, 7, 18)),
        _chore(id: 'done', title: 'Done', isDone: true),
      ];

      final result = choresForView(chores, ChoreView.due, now: now);

      expect(result.map((chore) => chore.id), ['today', 'future']);
    });

    test('sorts todos by newest creation first', () {
      final chores = [
        _chore(
          id: 'old',
          title: 'Old',
          type: ChoreType.todo,
          createdAt: DateTime(2026, 1, 1),
        ),
        _chore(
          id: 'new',
          title: 'New',
          type: ChoreType.todo,
          createdAt: DateTime(2026, 1, 2),
        ),
      ];

      final result = choresForView(chores, ChoreView.todos);

      expect(result.map((chore) => chore.id), ['new', 'old']);
    });
  });

  group('dashboardChores', () {
    test('separates today and overdue chores', () {
      final now = DateTime(2026, 7, 3, 12);
      final chores = [
        _chore(id: 'overdue', title: 'Overdue', nextDue: DateTime(2026, 7, 2)),
        _chore(id: 'today', title: 'Today', nextDue: DateTime(2026, 7, 3)),
        _chore(
          id: 'tomorrow',
          title: 'Tomorrow',
          nextDue: DateTime(2026, 7, 4),
        ),
        _chore(
          id: 'inactive',
          title: 'Inactive',
          nextDue: DateTime(2026, 7, 2),
          isActive: false,
        ),
      ];

      final result = dashboardChores(chores, now: now);

      expect(result.overdue.map((chore) => chore.id), ['overdue']);
      expect(result.today.map((chore) => chore.id), ['today']);
      expect(result.attentionCount, 2);
    });
  });

  group('summarizeChores', () {
    test('counts visible due, todo, and recurring chores', () {
      final summary = summarizeChores([
        _chore(id: 'due', title: 'Due', nextDue: DateTime(2026, 7, 3)),
        _chore(id: 'done', title: 'Done', isDone: true),
        _chore(id: 'todo', title: 'Todo', type: ChoreType.todo),
      ], now: DateTime(2026, 7, 3));

      expect(summary.dueCount, 1);
      expect(summary.todoCount, 1);
      expect(summary.recurringCount, 2);
    });
  });
}

Chore _chore({
  required String id,
  required String title,
  ChoreType type = ChoreType.recurring,
  DateTime? nextDue,
  bool isActive = true,
  bool isDone = false,
  DateTime? createdAt,
}) {
  return Chore(
    id: id,
    title: title,
    area: defaultChoreArea,
    type: type,
    recurrenceRule: type == ChoreType.recurring ? defaultRecurrenceRule : null,
    assignedTo: unassignedChoreOwner,
    nextDue: nextDue,
    isActive: isActive,
    isDone: isDone,
    createdAt: createdAt ?? DateTime(2026),
  );
}
