import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/metronome_screen.dart';

/// Root navigator key for GoRouter.
final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// GoRouter configuration for Standalone Metronome.
/// 
/// Ultra-simple navigation with only 1 screen:
/// - / → MetronomeScreen (main and only)
/// 
/// No authentication required - standalone app.
final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    // Main metronome screen (no auth required)
    GoRoute(
      path: '/',
      name: 'metronome',
      builder: (context, state) => const MetronomeScreen(),
    ),
  ],
);

/// Extension on BuildContext for type-safe navigation.
extension GoRouterExtension on BuildContext {
  /// Navigate to metronome (main screen).
  void goMetronome() => goNamed('metronome');

  /// Go back.
  void goBack() => pop();
}
