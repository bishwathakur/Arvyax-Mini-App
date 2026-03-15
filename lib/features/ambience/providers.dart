import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../../data/models/ambience.dart';
import '../../data/providers.dart';

final ambiencesFutureProvider = FutureProvider<List<Ambience>>((ref) {
  final repo = ref.watch(ambienceRepositoryProvider);
  return repo.getAmbiences();
});

final selectedTagProvider = StateProvider<String?>((ref) => null);
final searchQueryProvider = StateProvider<String>((ref) => '');

final filteredAmbiencesProvider = Provider<List<Ambience>>((ref) {
  final ambiencesAsync = ref.watch(ambiencesFutureProvider);
  final tag = ref.watch(selectedTagProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase();

  return ambiencesAsync.maybeWhen(
    data: (ambiences) {
      return ambiences.where((ambience) {
        final matchesTag = tag == null || ambience.tag == tag;
        final matchesQuery =
            query.isEmpty || ambience.title.toLowerCase().contains(query);
        return matchesTag && matchesQuery;
      }).toList();
    },
    orElse: () => [],
  );
});

/// Reads the real duration of each audio asset once at startup.
/// Falls back to [Ambience.durationSeconds] from JSON if audio fails to load.
final audioDurationsProvider = FutureProvider<Map<String, int>>((ref) async {
  final ambiences = await ref.watch(ambiencesFutureProvider.future);
  final player = AudioPlayer();
  final durations = <String, int>{};
  try {
    for (final ambience in ambiences) {
      try {
        await player.setAsset(ambience.audioAsset);
        final duration = player.duration;
        durations[ambience.id] =
            (duration != null && duration.inSeconds > 0)
                ? duration.inSeconds
                : ambience.durationSeconds;
      } catch (_) {
        durations[ambience.id] = ambience.durationSeconds;
      }
    }
  } finally {
    await player.dispose();
  }
  return durations;
});
