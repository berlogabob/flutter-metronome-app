import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'router/app_router.dart';
import 'services/audio/audio_engine_export.dart';
import 'services/audio/i_audio_engine.dart';
import 'providers/metronome_provider.dart';

/// Shared audio engine instance - pre-initialized at startup
/// This instance is reused by metronomeProvider to avoid lazy initialization delay
IAudioEngine? _sharedAudioEngine;

/// Application entry point.
///
/// Performance optimization: Audio engine is pre-initialized at startup
/// and SHARED with metronomeProvider to ensure zero-latency playback on first beat.
///
/// CRITICAL FIX: Previous implementation created a separate AudioEngine instance
/// that was discarded after initialization. The metronomeProvider would then
/// create its own instance and lazily initialize it on first start(), causing
/// huge delay (350-700ms on Huawei P30). Now we share the same instance.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Pre-initialize audio engine BEFORE app starts
  // This ensures all samples are pre-generated and cached
  // so the first beat plays instantly (zero synthesis latency)
  _sharedAudioEngine = AudioEngine();
  debugPrint('[Main] Starting audio engine initialization...');
  await _sharedAudioEngine!.initialize();
  debugPrint('[Main] Audio engine READY (pre-warmed, buffers loaded)');

  // Share the pre-initialized instance with metronomeProvider
  // This eliminates lazy initialization delay on first start()
  MetronomeNotifier.setAudioEngineFactory(() {
    debugPrint('[Main] Providing SHARED audio engine instance');
    return _sharedAudioEngine!;
  });

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
