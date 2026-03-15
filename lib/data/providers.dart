import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'repositories/ambience_repository.dart';
import 'repositories/journal_repository.dart';
import 'repositories/session_repository.dart';

final ambienceRepositoryProvider = Provider<AmbienceRepository>((ref) {
  return AmbienceRepository();
});

final journalRepositoryProvider = Provider<JournalRepository>((ref) {
  return JournalRepository();
});

final sessionRepositoryProvider = Provider<SessionRepository>((ref) {
  return SessionRepository();
});
