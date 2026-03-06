import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/metronome_screen.dart';

/// Root navigator key for GoRouter 17.x
final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// GoRouter 17.x configuration for Standalone Metronome
/// 
/// Updated for GoRouter 17.x API:
/// - Simplified route definition
/// - Type-safe navigation
/// - Improved redirect logic
final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    // Main metronome screen (no auth required for standalone)
    GoRoute(
      path: '/',
      name: 'metronome',
      builder: (context, state) => const MetronomeScreen(),
    ),
  ],
);

/// Extension on BuildContext for type-safe navigation
/// GoRouter 17.x syntax
extension GoRouterExtension on BuildContext {
  /// Navigate to metronome (main screen)
  void goMetronome() => goNamed('metronome');

  /// Go back
  void goBack() => pop();
}
