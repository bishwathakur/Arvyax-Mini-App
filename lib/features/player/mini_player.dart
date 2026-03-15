import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'providers.dart';
import '../ambience/providers.dart';

class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionState = ref.watch(sessionProvider);

    if (sessionState == null) return const SizedBox.shrink();

    final progress = sessionState.elapsedSeconds / sessionState.totalSeconds;

    return GestureDetector(
      onTap: () async {
        final ambiencesAsync = ref.read(ambiencesFutureProvider);
        ambiencesAsync.whenData((ambiences) {
          final ambience = ambiences.firstWhere(
            (a) => a.id == sessionState.ambienceId,
          );
          context.push('/player', extra: ambience);
        });
      },
      child: Container(
        height: 72,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      sessionState.thumbnailAsset,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      sessionState.ambienceTitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      sessionState.isPlaying ? Icons.pause : Icons.play_arrow,
                    ),
                    onPressed: () {
                      ref.read(sessionProvider.notifier).playPause();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      ref.read(sessionProvider.notifier).endSession();
                    },
                  ),
                ],
              ),
            ),
            LinearProgressIndicator(
              value: progress.isNaN ? 0.0 : progress,
              minHeight: 3,
              backgroundColor: Colors.transparent,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
