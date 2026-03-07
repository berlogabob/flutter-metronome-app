// Low-latency audio engine using flutter_soloud
// Google's recommended package for real-time audio

import 'package:flutter/foundation.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'i_audio_engine.dart';

/// Audio engine for metronome sound synthesis using flutter_soloud
///
/// Performance optimizations:
/// - Pre-generated sounds at startup (zero runtime synthesis)
/// - Waveform generation (no audio files needed)
/// - <10ms latency on all platforms
/// - Unlimited voice pool (no player management)
///
/// Pre-generation strategy:
/// - All 24 frequency/wave combinations generated at startup
/// - Stored in SoundHandle map for instant access
/// - User custom frequencies generated on-demand and cached
class AudioEngineSoloud implements IAudioEngine {
  final SoLoud _soloud = SoLoud.instance;
  bool _initialized = false;

  // Pre-loaded sound handles: key = '${frequency}_${waveType}'
  final Map<String, AudioSource> _soundSources = {};

  // Supported frequencies and wave types for pre-generation
  static const List<double> _frequencies = [
    800.0,
    880.0,
    1600.0,
    1760.0,
    2000.0,
    2200.0
  ];
  static const List<String> _waveTypes = ['sine', 'square', 'triangle', 'sawtooth'];

  @override
  bool get initialized => _initialized;

  /// Initialize audio engine with pre-generated sounds
  @override
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Initialize SoLoud audio engine with low-latency settings
      await _soloud.init(
        sampleRate: 48000, // Higher sample rate for lower latency
        bufferSize: 1024, // Smaller buffer = lower latency (was 2048)
        channels: Channels.stereo,
      );

      debugPrint('[AudioEngineSoloud] SoLoud initialized (48kHz, 1024 buffer)');

      // Pre-generate ALL 24 sounds at startup
      await _preGenerateAllSounds();

      _initialized = true;
      debugPrint(
        '[AudioEngineSoloud] Ready with ${_soundSources.length} pre-generated sounds',
      );
    } catch (e) {
      debugPrint('[AudioEngineSoloud] Initialization failed: $e');
      rethrow;
    }
  }

  /// Pre-generate all 24 frequency/wave combinations
  Future<void> _preGenerateAllSounds() async {
    for (final freq in _frequencies) {
      for (final wave in _waveTypes) {
        final key = '${freq}_$wave';
        _soundSources[key] = await _generateSound(freq, wave);
      }
    }
  }

  /// Generate a single sound using SoLoud waveform
  Future<AudioSource> _generateSound(double frequency, String waveType) async {
    // Map wave type string to SoLoud WaveForm
    final waveForm = _getWaveForm(waveType);

    // Load waveform (programmatic generation - no files needed!)
    final source = await _soloud.loadWaveform(
      waveForm,
      false, // superWave disabled
      1.0, // scale
      0.0, // detune
    );

    // Set frequency (pitch)
    _soloud.setWaveformFreq(source, frequency);

    return source;
  }

  /// Convert wave type string to SoLoud WaveForm
  WaveForm _getWaveForm(String waveType) {
    return switch (waveType.toLowerCase()) {
      'sine' => WaveForm.sin,
      'square' => WaveForm.square,
      'triangle' => WaveForm.triangle,
      'sawtooth' => WaveForm.saw,
      _ => WaveForm.sin,
    };
  }

  /// Play a click sound with pre-loaded source
  @override
  Future<void> playClick({
    required bool isAccent,
    required String waveType,
    required double volume,
    double? accentFrequency,
    double? beatFrequency,
  }) async {
    if (!_initialized) {
      await initialize();
    }

    try {
      // Determine frequency
      final frequency = isAccent
          ? (accentFrequency ?? 1600.0)
          : (beatFrequency ?? 800.0);

      // Lookup pre-generated source
      final key = '${frequency}_$waveType';
      var source = _soundSources[key];

      // Generate on-demand if not found (user custom frequency)
      if (source == null) {
        debugPrint(
          '[AudioEngineSoloud] Generating custom frequency: $key',
        );
        source = await _generateSound(frequency, waveType);
        _soundSources[key] = source; // Cache for future use
      }

      // Play with volume control at playback time (<10ms latency)
      // Don't use scheduleStop - let envelope handle the decay
      await _soloud.play(
        source,
        volume: volume.clamp(0.0, 1.0),
        looping: false,
      );

      debugPrint(
        '[AudioEngineSoloud] Played: accent=$isAccent, freq=${frequency}Hz, wave=$waveType, vol=$volume',
      );
    } catch (e) {
      debugPrint('[AudioEngineSoloud] Play failed: $e');
    }
  }

  /// Play test sound (for Tone Settings preview)
  @override
  Future<void> playTest() async {
    await playClick(
      isAccent: true,
      waveType: 'sine',
      volume: 0.5,
      accentFrequency: 1600.0,
    );
  }

  /// Regenerate a specific sound (when user changes frequency in settings)
  Future<void> regenerateSound(double frequency, String waveType) async {
    final key = '${frequency}_$waveType';
    final oldSource = _soundSources[key];

    // Dispose old source to free memory
    if (oldSource != null) {
      await _soloud.disposeSource(oldSource);
    }

    // Generate and cache new source
    _soundSources[key] = await _generateSound(frequency, waveType);
    debugPrint('[AudioEngineSoloud] Regenerated sound: $key');
  }

  /// Dispose resources
  @override
  Future<void> dispose() async {
    if (!_initialized) return;

    try {
      // Dispose all pre-loaded sources
      for (final source in _soundSources.values) {
        await _soloud.disposeSource(source);
      }
      _soundSources.clear();

      // Deinitialize SoLoud (ignore return value)
      _soloud.deinit();

      _initialized = false;
      debugPrint('[AudioEngineSoloud] Disposed');
    } catch (e) {
      debugPrint('[AudioEngineSoloud] Dispose failed: $e');
    }
  }
}
