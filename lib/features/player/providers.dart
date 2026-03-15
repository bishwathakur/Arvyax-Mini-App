import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../../data/models/session_state.dart';
import '../../data/models/ambience.dart';
import '../../data/providers.dart';
import '../../data/repositories/session_repository.dart';

final audioPlayerProvider = Provider<AudioPlayer>((ref) {
  final player = AudioPlayer();
  ref.onDispose(() => player.dispose());
  return player;
});

class SessionNotifier extends StateNotifier<SessionState?> {
  final AudioPlayer _player;
  final SessionRepository _sessionRepo;
  Timer? _timer;

  SessionNotifier(this._player, this._sessionRepo) : super(null) {
    _loadPersistedSession();
  }

  Future<void> _loadPersistedSession() async {
    final lastState = _sessionRepo.getLastSession();
    if (lastState != null) {
      state = lastState;
    }
  }

  Future<void> startSession(Ambience ambience) async {
    int totalSeconds = ambience.durationSeconds; // fallback

    try {
      await _player.setAsset(ambience.audioAsset);
      _player.setLoopMode(LoopMode.all);
      final actualDuration = _player.duration;
      if (actualDuration != null && actualDuration.inSeconds > 0) {
        totalSeconds = actualDuration.inSeconds;
      }
      _player.play();
    } catch (_) {
      // Audio failed to load, use JSON duration as fallback.
    }

    state = SessionState(
      ambienceId: ambience.id,
      ambienceTitle: ambience.title,
      thumbnailAsset: ambience.thumbnailAsset,
      elapsedSeconds: 0,
      totalSeconds: totalSeconds,
      isPlaying: true,
    );
    await _sessionRepo.saveSession(state!);

    _startTimer();
  }

  void playPause() {
    if (state == null) return;
    final isPlaying = !state!.isPlaying;
    state = state!.copyWith(isPlaying: isPlaying);

    if (isPlaying) {
      _player.play();
      _startTimer();
    } else {
      _player.pause();
      _timer?.cancel();
    }
    _sessionRepo.saveSession(state!);
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state == null || !state!.isPlaying) {
        timer.cancel();
        return;
      }

      final newElapsed = state!.elapsedSeconds + 1;
      if (newElapsed >= state!.totalSeconds) {
        endSession();
        return;
      }

      state = state!.copyWith(elapsedSeconds: newElapsed);
      _sessionRepo.saveSession(state!);
    });
  }

  void seek(int seconds) {
    if (state == null) return;
    state = state!.copyWith(elapsedSeconds: seconds);
    _player.seek(Duration(seconds: seconds));
    _sessionRepo.saveSession(state!);
  }

  void endSession() {
    _timer?.cancel();
    _player.stop();
    state = null;
    _sessionRepo.clearSession();
  }
}

final sessionProvider = StateNotifierProvider<SessionNotifier, SessionState?>((
  ref,
) {
  final player = ref.watch(audioPlayerProvider);
  final repo = ref.watch(sessionRepositoryProvider);
  return SessionNotifier(player, repo);
});
