// Mock classes for audio engine testing
// Generated mock for AudioEngine

import 'package:flutter/foundation.dart';

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
class MockAudioEngine {
  bool _initialized = false;

  bool get initialized => _initialized;

  Future<void> initialize() async {
    _initialized = true;
    debugPrint('[MockAudioEngine] Initialized');
  }

  Future<void> playClick({
    required bool isAccent,
    required String waveType,
    required double volume,
    double? accentFrequency,
    double? beatFrequency,
  }) async {
    debugPrint(
      '[MockAudioEngine] Play click: accent=$isAccent, wave=$waveType, vol=$volume',
    );
  }

  Future<void> playTest() async {
    debugPrint('[MockAudioEngine] Playing test sound');
  }

  void dispose() {
    _initialized = false;
    debugPrint('[MockAudioEngine] Disposed');
  }
}
