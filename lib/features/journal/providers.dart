import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/reflection.dart';
import '../../data/providers.dart';

class JournalNotifier extends StateNotifier<List<Reflection>> {
  final Ref _ref;

  JournalNotifier(this._ref) : super([]) {
    loadReflections();
  }

  void loadReflections() {
    final repo = _ref.read(journalRepositoryProvider);
    state = repo.getReflections();
  }

  Future<void> saveReflection(Reflection reflection) async {
    final repo = _ref.read(journalRepositoryProvider);
    await repo.saveReflection(reflection);
    loadReflections(); // Reload immediately
  }
}

final journalProvider = StateNotifierProvider<JournalNotifier, List<Reflection>>((ref) {
  return JournalNotifier(ref);
});
