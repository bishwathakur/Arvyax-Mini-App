import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'features/ambience/home_screen.dart';
import 'features/ambience/details_screen.dart';
import 'features/player/player_screen.dart';
import 'features/journal/reflection_screen.dart';
import 'features/journal/history_screen.dart';
import 'shared/widgets/app_scaffold.dart';
import 'data/models/ambience.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppScaffold(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const HomeScreen(),
              routes: [
                GoRoute(
                  path: 'details/:id',
                  builder: (context, state) {
                    final ambience = state.extra as Ambience;
                    return AmbienceDetailsScreen(ambience: ambience);
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/history',
              builder: (context, state) => const HistoryScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/player',
      pageBuilder: (context, state) {
        final ambience = state.extra as Ambience;
        return CustomTransitionPage(
          child: SessionPlayerScreen(ambience: ambience),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    ),
    GoRoute(
      path: '/reflection',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          child: const ReflectionScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: animation.drive(Tween(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).chain(CurveTween(curve: Curves.easeOut))),
              child: child,
            );
          },
        );
      },
    ),
  ],
);
