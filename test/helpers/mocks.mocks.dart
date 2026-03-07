// Mock classes for audio engine testing
// Generated mock for AudioEngine

import 'package:flutter/foundation.dart';
import 'package:metronome_app/services/audio/i_audio_engine.dart';

/// Mock AudioPlayer for testing
class MockAudioPlayer {
  double _volume = 1.0;
  bool _isInitialized = false;

  double get volume => _volume;
  bool get isInitialized => _isInitialized;

  Future<void> setReleaseMode(dynamic mode) async {
    _isInitialized = true;
  }

  Future<void> setVolume(double volume) async {
    _volume = volume;
  }

  Future<void> play(dynamic source, {double? volume}) async {
    debugPrint('[MockAudioPlayer] Playing sound with volume: ${volume ?? _volume}');
  }

  Future<void> stop() async {}

  Future<void> dispose() async {
    _isInitialized = false;
  }
}

/// Mock AudioEngine for testing
/// Implements the same interface as AudioEngine but without platform channels
class MockAudioEngine implements IAudioEngine {
  bool _initialized = false;
  
  // Track calls for verification
  int playClickCallCount = 0;
  List<Map<String, dynamic>> playClickHistory = [];

  @override
  bool get initialized => _initialized;

  @override
  Future<void> initialize() async {
    _initialized = true;
    debugPrint('[MockAudioEngine] Initialized');
  }

  @override
  Future<void> playClick({
    required bool isAccent,
    required String waveType,
    required double volume,
    double? accentFrequency,
    double? beatFrequency,
  }) async {
    playClickCallCount++;
    playClickHistory.add({
      'isAccent': isAccent,
      'waveType': waveType,
      'volume': volume,
      'accentFrequency': accentFrequency,
      'beatFrequency': beatFrequency,
    });
    debugPrint(
      '[MockAudioEngine] Play click: accent=$isAccent, wave=$waveType, vol=$volume',
    );
  }

  @override
  Future<void> playTest() async {
    debugPrint('[MockAudioEngine] Playing test sound');
  }

  @override
  void dispose() {
    _initialized = false;
    playClickCallCount = 0;
    playClickHistory.clear();
    debugPrint('[MockAudioEngine] Disposed');
  }

  /// Reset mock state for reuse
  void reset() {
    _initialized = false;
    playClickCallCount = 0;
    playClickHistory.clear();
  }
}
