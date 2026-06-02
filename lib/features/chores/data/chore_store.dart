import 'package:flutter/foundation.dart';

enum ChoreType { recurring, single }

class Chore {
  final String id;
  final String title;
  final String area;
  final ChoreType type;
  final String? recurrence;
  final String assignedTo;
  final DateTime nextDue;
  final bool isActive;
  final bool isDone;

  const Chore({
    required this.id,
    required this.title,
    required this.area,
    required this.type,
    this.recurrence,
    required this.assignedTo,
    required this.nextDue,
    required this.isActive,
    required this.isDone,
  });

  String get scheduleLabel {
    if (type == ChoreType.recurring) return recurrence ?? 'Recurring';
    return 'Single task';
  }

  Chore copyWith({
    String? id,
    String? title,
    String? area,
    ChoreType? type,
    String? recurrence,
    String? assignedTo,
    DateTime? nextDue,
    bool? isActive,
    bool? isDone,
  }) {
    return Chore(
      id: id ?? this.id,
      title: title ?? this.title,
      area: area ?? this.area,
      type: type ?? this.type,
      recurrence: recurrence ?? this.recurrence,
      assignedTo: assignedTo ?? this.assignedTo,
      nextDue: nextDue ?? this.nextDue,
      isActive: isActive ?? this.isActive,
      isDone: isDone ?? this.isDone,
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
      assignedTo: 'Marc',
      nextDue: DateTime(2026, 6, 3),
      isActive: true,
      isDone: false,
    ),
    Chore(
      id: 'sheets',
      title: 'Change bed sheets',
      area: 'Bedroom',
      type: ChoreType.recurring,
      recurrence: 'Weekly',
      assignedTo: 'Mathilde',
      nextDue: DateTime(2026, 6, 7),
      isActive: true,
      isDone: false,
    ),
    Chore(
      id: 'fridge',
      title: 'Clean fridge',
      area: 'Kitchen',
      type: ChoreType.recurring,
      recurrence: 'Monthly',
      assignedTo: 'Marc',
      nextDue: DateTime(2026, 6, 20),
      isActive: false,
      isDone: false,
    ),
    Chore(
      id: 'bins',
      title: 'Take out recycling',
      area: 'Utility',
      type: ChoreType.recurring,
      recurrence: 'Tuesdays',
      assignedTo: 'Cody',
      nextDue: DateTime(2026, 6, 2),
      isActive: true,
      isDone: false,
    ),
    Chore(
      id: 'filters',
      title: 'Replace hood filters',
      area: 'Kitchen',
      type: ChoreType.single,
      assignedTo: 'Marc',
      nextDue: DateTime(2026, 6, 12),
      isActive: true,
      isDone: false,
    ),
  ];

  List<Chore> get chores => List.unmodifiable(_chores);

  List<Chore> get activeChores =>
      _chores
          .where((chore) => chore.isActive && !chore.isDone)
          .toList(growable: false)
        ..sort((a, b) => a.nextDue.compareTo(b.nextDue));

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

  String nextId() => DateTime.now().microsecondsSinceEpoch.toString();

  void _sortChores() {
    _chores.sort((a, b) => a.nextDue.compareTo(b.nextDue));
  }
}
