// Mobile audio engine using audioplayers package
// For web, use audio_engine_web.dart

import 'dart:math';
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'i_audio_engine.dart';
import 'audio_player_adapter.dart';

/// Abstract interface for audio player - allows mocking in tests
/// Mirrors the AudioPlayer API we use
// coverage:ignore-line - Interface definition, tested through implementations
abstract class IAudioPlayer {
  Future<void> setReleaseMode(ReleaseMode mode);
  Future<void> setVolume(double volume);
  Future<void> play(BytesSource source, {double? volume});
  void dispose();
}

/// Audio engine for metronome sound synthesis
/// Mobile version using audioplayers with pre-loaded PCM audio buffers
///
/// Performance optimizations:
/// - Pre-generated audio buffers at startup (zero runtime synthesis)
/// - Player pool for overlapping clicks (no wait time)
/// - Round-robin playback across 4 players
///
/// Dependency injection support:
/// - Pass custom [playerFactory] for testing
/// - Default: creates AudioPlayerAdapter instances
class AudioEngine implements IAudioEngine {
  // Player pool for overlapping clicks (handles up to 260 BPM with subdivisions)
  final List<IAudioPlayer> _players = [];
  int _currentPlayerIndex = 0;
  bool _initialized = false;

  // Pre-loaded audio buffers: key = '${frequency}_${waveType}'
  final Map<String, Uint8List> _buffers = {};

  // Factory function for creating audio players - injected for testing
  final IAudioPlayer Function() _playerFactory;

  bool get initialized => _initialized;

  /// Audio sample rate for synthesized sounds
  static const int _sampleRate = 44100;

  /// Click duration in seconds (40ms like Reaper)
  static const double _clickDuration = 0.04;

  /// Supported frequencies and wave types for buffer generation
  static const List<double> _frequencies = [800, 880, 1600, 1760, 2000, 2200];
  static const List<String> _waveTypes = ['sine', 'square', 'triangle', 'sawtooth'];

  /// Create audio engine with optional player factory for dependency injection
  ///
  /// [playerFactory] - Function that creates IAudioPlayer instances
  ///                   Default: AudioPlayerAdapter (real implementation)
  AudioEngine({IAudioPlayer Function()? playerFactory})
      // coverage:ignore-line - Default factory requires platform channels
      : _playerFactory = playerFactory ?? (() => AudioPlayerAdapter() as IAudioPlayer);

  /// Initialize audio engine with pre-loaded buffers
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Create player pool (4 players for overlapping clicks)
      for (int i = 0; i < 4; i++) {
        final player = _playerFactory();
        await player.setReleaseMode(ReleaseMode.stop);
        await player.setVolume(1.0);
        _players.add(player);
      }

      // Pre-generate ALL sounds ONCE at startup
      for (final freq in _frequencies) {
        for (final wave in _waveTypes) {
          final key = '${freq}_${wave}';
          _buffers[key] = _generateClickSound(
            frequency: freq,
            waveType: wave,
            volume: 1.0,
          );
        }
      }

      _initialized = true;
      debugPrint('[AudioEngine] Mobile audio engine initialized with ${_buffers.length} pre-loaded buffers');
    } catch (e) {
      debugPrint('[AudioEngine] Failed to initialize: $e');
      rethrow;
    }
  }

  /// Pre-warm audio players to eliminate platform channel initialization latency
  ///
  /// On Android, the first AudioPlayer.play() call triggers native initialization
  /// which can take 100-200ms per player. By pre-warming during app startup,
  /// we eliminate this latency from the critical path (user pressing START).
  Future<void> _preWarmPlayers() async {
    try {
      // Generate a silent buffer for warming (1ms of silence)
      final silentBuffer = _generateClickSound(
        frequency: 1.0,  // Inaudible frequency
        waveType: 'sine',
        volume: 0.0,  // Silent
      );

      // Play silent buffer on each player to trigger native initialization
      for (int i = 0; i < _players.length; i++) {
        final player = _players[i];
        // Set volume to 0 for warm-up (silent)
        await player.setVolume(0.0);
        // Play silent buffer - triggers platform channel init without sound
        await player.play(BytesSource(silentBuffer), volume: 0.0);
        // Small delay to ensure initialization completes
        await Future.delayed(const Duration(milliseconds: 10));
        // Restore volume
        await player.setVolume(1.0);
      }

      debugPrint('[AudioEngine] Pre-warmed ${_players.length} audio players');
    } catch (e) {
      // Non-critical: pre-warming failure doesn't break functionality
      debugPrint('[AudioEngine] Pre-warm failed (non-critical): $e');
    }
  }

  /// Play a click sound using pre-loaded buffers
  /// [isAccent] - true for accented beat (higher pitch)
  /// [waveType] - 'sine', 'square', 'triangle', or 'sawtooth'
  /// [volume] - 0.0 to 1.0
  /// [accentFrequency] - frequency for accented beat in Hz (default: 1600)
  /// [beatFrequency] - frequency for regular beat in Hz (default: 800)
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

      // Lookup pre-generated buffer (ZERO synthesis latency!)
      final key = '${frequency}_$waveType';
      var bytes = _buffers[key];
      
      // Generate and cache if not found (user custom frequency)
      if (bytes == null) {
        bytes = _generateClickSound(
          frequency: frequency,
          waveType: waveType,
          volume: 1.0,
        );
        _buffers[key] = bytes; // Cache for future use
        debugPrint('[AudioEngine] Generated and cached custom frequency: $key');
      }

      // Play with next available player (round-robin)
      final player = _players[_currentPlayerIndex];
      _currentPlayerIndex = (_currentPlayerIndex + 1) % _players.length;
      
      // Apply volume at playback time (buffers are stored at 1.0)
      await player.play(BytesSource(bytes), volume: volume.clamp(0.0, 1.0));

      debugPrint(
        '[AudioEngine] Played click: accent=$isAccent, freq=${frequency}Hz, wave=$waveType, vol=$volume',
      );
    } catch (e) {
      debugPrint('[AudioEngine] Error playing click: $e');
    }
  }

  /// Generate PCM audio data for a click sound as 16-bit WAV format
  Uint8List _generateClickSound({
    required double frequency,
    required String waveType,
    required double volume,
  }) {
    final numSamples = (_sampleRate * _clickDuration).toInt();

    // Generate float samples first
    final samples = _generateSamples(
      frequency: frequency,
      waveType: waveType,
      volume: volume,
      numSamples: numSamples,
    );

    // Convert to 16-bit PCM bytes
    return _floatToPcm16(samples);
  }

  /// Generate float audio samples
  Float32List _generateSamples({
    required double frequency,
    required String waveType,
    required double volume,
    required int numSamples,
  }) {
    final samples = Float32List(numSamples);

    // Wave function generator
    double Function(double phase) waveFunc;
    switch (waveType.toLowerCase()) {
      case 'square':
        waveFunc = (phase) => phase < 0.5 ? 1.0 : -1.0;
        break;
      case 'triangle':
        waveFunc = (phase) => 2.0 * (phase - 0.5).abs() * 2 - 1;
        break;
      case 'sawtooth':
        waveFunc = (phase) => 2.0 * phase - 1;
        break;
      case 'sine':
      default:
        waveFunc = (phase) => sin(2 * pi * phase);
        break;
    }

    // Generate samples with envelope to avoid clicking
    for (int i = 0; i < numSamples; i++) {
      final t = i / _sampleRate;
      final phase = (frequency * t) % 1.0;

      // Apply envelope (attack and decay)
      final envelope = _calculateEnvelope(t, _clickDuration);

      samples[i] = waveFunc(phase) * volume * envelope;
    }

    return samples;
  }

  /// Convert float samples to 16-bit PCM bytes with WAV header
  Uint8List _floatToPcm16(Float32List samples) {
    final numSamples = samples.length;
    final byteData = ByteData(44 + numSamples * 2);

    // Write WAV header
    // RIFF chunk
    byteData.setUint8(0, 0x52);
    byteData.setUint8(1, 0x49);
    byteData.setUint8(2, 0x46);
    byteData.setUint8(3, 0x46);
    byteData.setUint32(4, 36 + numSamples * 2, Endian.little);
    byteData.setUint8(8, 0x57);
    byteData.setUint8(9, 0x41);
    byteData.setUint8(10, 0x56);
    byteData.setUint8(11, 0x45);
    byteData.setUint8(12, 0x66);
    byteData.setUint8(13, 0x6D);
    byteData.setUint8(14, 0x74);
    byteData.setUint8(15, 0x20);
    byteData.setUint32(16, 16, Endian.little);
    byteData.setUint16(20, 1, Endian.little);
    byteData.setUint16(22, 1, Endian.little);
    byteData.setUint32(24, _sampleRate, Endian.little);
    byteData.setUint32(28, _sampleRate * 2, Endian.little);
    byteData.setUint16(32, 2, Endian.little);
    byteData.setUint16(34, 16, Endian.little);
    byteData.setUint8(36, 0x64);
    byteData.setUint8(37, 0x61);
    byteData.setUint8(38, 0x74);
    byteData.setUint8(39, 0x61);
    byteData.setUint32(40, numSamples * 2, Endian.little);

    // Write samples as 16-bit PCM
    for (int i = 0; i < numSamples; i++) {
      final sample = samples[i].clamp(-1.0, 1.0);
      final intSample = (sample * 32767).toInt();
      byteData.setInt16(44 + i * 2, intSample, Endian.little);
    }

    return byteData.buffer.asUint8List();
  }

  /// Calculate amplitude envelope for smooth click sound
  double _calculateEnvelope(double time, double duration) {
    const attackTime = 0.001;
    const decayTime = 0.039;

    if (time < attackTime) {
      return time / attackTime;
    } else if (time < duration) {
      final decayProgress = (time - attackTime) / decayTime;
      return exp(-3.0 * decayProgress);
    }
    return 0.0;
  }

  /// Play test sound to verify audio works
  Future<void> playTest() async {
    debugPrint('[AudioEngine] Playing test sound...');

    // Play accented click
    await playClick(
      isAccent: true,
      waveType: 'sine',
      volume: 0.5,
      accentFrequency: 1600,
      beatFrequency: 800,
    );

    // Wait between clicks
    await Future.delayed(const Duration(milliseconds: 200));

    // Play regular click
    await playClick(
      isAccent: false,
      waveType: 'sine',
      volume: 0.5,
      accentFrequency: 1600,
      beatFrequency: 800,
    );

    debugPrint('[AudioEngine] Test sound complete');
  }

  /// Dispose audio resources
  void dispose() {
    try {
      // Dispose all players in the pool
      for (final player in _players) {
        player.dispose();
      }
    } catch (e) {
      debugPrint('[AudioEngine] Error during dispose: $e');
    } finally {
      // Always clean up state, even if dispose throws
      _players.clear();
      _buffers.clear();
      _initialized = false;
      debugPrint('[AudioEngine] Disposed');
    }
  }
}
