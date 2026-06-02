import 'package:flutter/foundation.dart';

class Chore {
  final String id;
  final String title;
  final String area;
  final String cadence;
  final String assignedTo;
  final DateTime nextDue;
  final bool isActive;

  const Chore({
    required this.id,
    required this.title,
    required this.area,
    required this.cadence,
    required this.assignedTo,
    required this.nextDue,
    required this.isActive,
  });

  Chore copyWith({
    String? id,
    String? title,
    String? area,
    String? cadence,
    String? assignedTo,
    DateTime? nextDue,
    bool? isActive,
  }) {
    return Chore(
      id: id ?? this.id,
      title: title ?? this.title,
      area: area ?? this.area,
      cadence: cadence ?? this.cadence,
      assignedTo: assignedTo ?? this.assignedTo,
      nextDue: nextDue ?? this.nextDue,
      isActive: isActive ?? this.isActive,
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
      cadence: 'Every 3 days',
      assignedTo: 'Marc',
      nextDue: DateTime(2026, 6, 3),
      isActive: true,
    ),
    Chore(
      id: 'sheets',
      title: 'Change bed sheets',
      area: 'Bedroom',
      cadence: 'Weekly',
      assignedTo: 'Mathilde',
      nextDue: DateTime(2026, 6, 7),
      isActive: true,
    ),
    Chore(
      id: 'fridge',
      title: 'Clean fridge',
      area: 'Kitchen',
      cadence: 'Monthly',
      assignedTo: 'Marc',
      nextDue: DateTime(2026, 6, 20),
      isActive: false,
    ),
    Chore(
      id: 'bins',
      title: 'Take out recycling',
      area: 'Utility',
      cadence: 'Tuesdays',
      assignedTo: 'Cody',
      nextDue: DateTime(2026, 6, 2),
      isActive: true,
    ),
  ];

  List<Chore> get chores => List.unmodifiable(_chores);

  List<Chore> get activeChores =>
      _chores.where((chore) => chore.isActive).toList(growable: false)
        ..sort((a, b) => a.nextDue.compareTo(b.nextDue));

  void toggleActive(String id) {
    final index = _chores.indexWhere((chore) => chore.id == id);
    if (index == -1) return;

    final chore = _chores[index];
    _chores[index] = chore.copyWith(isActive: !chore.isActive);
    notifyListeners();
  }
}
