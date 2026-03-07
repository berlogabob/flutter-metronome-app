import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'router/app_router.dart';
import 'services/audio/audio_engine_soloud.dart';
import 'providers/metronome_provider.dart';

/// Shared audio engine instance - pre-initialized at startup
/// This instance is reused by metronomeProvider to avoid lazy initialization delay
AudioEngineSoloud? _sharedAudioEngine;

/// Application entry point.
///
/// Performance optimization: Audio engine is pre-initialized at startup
/// using flutter_soloud for ultra-low-latency (<10ms) playback.
///
/// CRITICAL FIX: Previous implementation using audioplayers had 350-700ms
/// delay on first beat due to MediaPlayer initialization. Now using
/// flutter_soloud with pre-generated waveforms for instant playback.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Pre-initialize flutter_soloud audio engine
  _sharedAudioEngine = AudioEngineSoloud();
  debugPrint('[Main] Starting flutter_soloud initialization...');
  await _sharedAudioEngine!.initialize();
  debugPrint('[Main] Audio engine READY (pre-generated sounds, <10ms latency)');

  // Share the pre-initialized instance with metronomeProvider
  MetronomeNotifier.setAudioEngineFactory(() => _sharedAudioEngine!);

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
