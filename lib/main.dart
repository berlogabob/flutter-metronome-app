import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'router/app_router.dart';
import 'services/audio/audio_engine_export.dart';

/// Application entry point.
///
/// Performance optimization: Audio engine is pre-initialized at startup
/// to ensure zero-latency playback on first beat.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Pre-initialize audio engine BEFORE app starts
  // This ensures all samples are pre-generated and cached
  // so the first beat plays instantly (zero synthesis latency)
  final audioEngine = AudioEngine();
  await audioEngine.initialize();

  runApp(const ProviderScope(child: MetronomeApp()));
}

class MetronomeApp extends StatelessWidget {
  const MetronomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'RepSync Metronome',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
    );
  }
}
