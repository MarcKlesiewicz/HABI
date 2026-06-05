import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habi/features/chores/data/chore_repository.dart';
import 'package:habi/features/chores/data/chore_store.dart';

final choreRepositoryProvider = Provider<ChoreRepository>((ref) {
  return createChoreRepository();
});

final choresProvider = StreamProvider<List<Chore>>((ref) {
  return ref.watch(choreRepositoryProvider).watchChores();
});

final choreControllerProvider = Provider<ChoreController>((ref) {
  return ChoreController(ref);
});

class ChoreController {
  ChoreController(this._ref);

  final Ref _ref;
  final _scheduler = const ChoreScheduler();

  ChoreRepository get _repository => _ref.read(choreRepositoryProvider);

  Future<void> createChore(Chore chore) {
    return _repository.createChore(chore);
  }

  Future<void> updateChore(Chore chore) {
    return _repository.updateChore(chore);
  }

  Future<void> deleteChore(String id) {
    return _repository.deleteChore(id);
  }

  Future<void> completeChore(Chore chore, {DateTime? completedAt}) {
    return _repository.updateChore(
      _scheduler.complete(chore, completedAt: completedAt),
    );
  }

  Future<void> reopenChore(Chore chore) {
    return _repository.updateChore(
      chore.copyWith(isDone: false, isActive: true, clearLastCompletedAt: true),
    );
  }
}
