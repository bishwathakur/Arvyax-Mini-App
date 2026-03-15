import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/ambience.dart';
import '../../data/models/session_state.dart';
import 'providers.dart';

class SessionPlayerScreen extends ConsumerStatefulWidget {
  final Ambience ambience;

  const SessionPlayerScreen({super.key, required this.ambience});

  @override
  ConsumerState<SessionPlayerScreen> createState() =>
      _SessionPlayerScreenState();
}

class _SessionPlayerScreenState extends ConsumerState<SessionPlayerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    // Start session if it's new (or resume if it's the exact same)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentState = ref.read(sessionProvider);
      if (currentState == null ||
          currentState.ambienceId != widget.ambience.id) {
        ref.read(sessionProvider.notifier).startSession(widget.ambience);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String _formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final sessionState = ref.watch(sessionProvider);

    if (sessionState == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Auto-navigate when session ends (timer completes)
    ref.listen<SessionState?>(sessionProvider, (previous, next) {
      if (previous != null && next == null) {
        context.go('/reflection');
      }
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down, size: 32),
          onPressed: () => context.pop(),
        ),
      ),
      body: Stack(
        children: [
          // Breathing visual
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.lerp(
                        Colors.blueGrey[100],
                        Colors.blueGrey[300],
                        _animationController.value,
                      )!,
                      Theme.of(context).scaffoldBackgroundColor,
                    ],
                  ),
                ),
              );
            },
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32.0,
                vertical: 24.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Spacer(),

                  // Central Breathing Element
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 1.0 + (_animationController.value * 0.1),
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 40,
                                spreadRadius: 10 * _animationController.value,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.3),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const Spacer(),
                  // Info
                  Text(
                    widget.ambience.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.ambience.tag.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 14,
                      letterSpacing: 2,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Progress
                  Slider(
                    value: sessionState.elapsedSeconds.toDouble(),
                    max: sessionState.totalSeconds.toDouble(),
                    onChanged: (val) {
                      ref.read(sessionProvider.notifier).seek(val.toInt());
                    },
                    activeColor: Colors.black,
                    inactiveColor: Colors.black12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_formatDuration(sessionState.elapsedSeconds)),
                      Text(_formatDuration(sessionState.totalSeconds)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          ref.read(sessionProvider.notifier).playPause();
                        },
                        iconSize: 64,
                        icon: Icon(
                          sessionState.isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_filled,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),

                  // End Session
                  TextButton(
                    onPressed: () => _showEndDialog(context, ref),
                    child: const Text(
                      'End Session',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showEndDialog(BuildContext context, WidgetRef ref) async {
    final shouldEnd = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('End Session?'),
        content: const Text(
          'Are you sure you want to end your current session?',
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => context.pop(true),
            child: const Text('End'),
          ),
        ],
      ),
    );

    if (shouldEnd == true && context.mounted) {
      ref.read(sessionProvider.notifier).endSession();
      context.go('/reflection');
    }
  }
}
