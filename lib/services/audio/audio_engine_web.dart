// Web-only audio engine using Web Audio API
// ignore_for_file: web_unsafe_total

import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;
import 'i_audio_engine.dart';

/// Audio engine for metronome sound synthesis
/// Uses Web Audio API for Flutter Web
///
/// Performance optimizations:
/// - Pre-loaded AudioBuffers at startup (zero runtime synthesis)
/// - Supports lookahead scheduling for sample-accurate timing
/// - Cached common sounds for instant access
class AudioEngine implements IAudioEngine {
  web.AudioContext? _audioContext;
  bool _initialized = false;

  // Pre-loaded AudioBuffers: key = '${frequency}_${waveType}'
  final Map<String, web.AudioBuffer> _buffers = {};

  // Cached common sounds for fast access
  web.AudioBuffer? _accentSine;   // 1600 Hz sine
  web.AudioBuffer? _beatSine;     // 800 Hz sine
  web.AudioBuffer? _accentSquare; // 1600 Hz square
  web.AudioBuffer? _beatSquare;   // 800 Hz square

  @override
  bool get initialized => _initialized;

  /// Initialize audio context and pre-load buffers
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      _audioContext = web.AudioContext();
      
      // Pre-generate ALL sounds ONCE at startup
      const frequencies = [800.0, 880.0, 1600.0, 1760.0, 2000.0, 2200.0];
      const waveTypes = ['sine', 'square', 'triangle', 'sawtooth'];

      for (final freq in frequencies) {
        for (final wave in waveTypes) {
          _buffers['${freq}_$wave'] = await _createBuffer(
            frequency: freq,
            waveType: wave,
            volume: 1.0,
          );
        }
      }

      // Cache common sounds for even faster access
      _accentSine = _buffers['1600_sine'];
      _beatSine = _buffers['800_sine'];
      _accentSquare = _buffers['1600_square'];
      _beatSquare = _buffers['800_square'];

      _initialized = true;
      debugPrint('[AudioEngine] Web audio engine initialized with ${_buffers.length} pre-loaded buffers');
    } catch (e) {
      debugPrint('[AudioEngine] Failed to initialize: $e');
      rethrow;
    }
  }

  /// Play a click sound using pre-loaded AudioBuffers
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
    if (!_initialized || _audioContext == null) {
      await initialize();
      if (!_initialized) return;
    }

    try {
      final now = _audioContext!.currentTime;
      final frequency = isAccent
          ? (accentFrequency ?? 1600.0)
          : (beatFrequency ?? 800.0);

      // Try to use cached common sounds first (fastest path)
      web.AudioBuffer? buffer;
      if (isAccent && frequency == 1600 && waveType == 'sine') {
        buffer = _accentSine;
      } else if (!isAccent && frequency == 800 && waveType == 'sine') {
        buffer = _beatSine;
      } else if (isAccent && frequency == 1600 && waveType == 'square') {
        buffer = _accentSquare;
      } else if (!isAccent && frequency == 800 && waveType == 'square') {
        buffer = _beatSquare;
      } else {
        // Fallback to buffer lookup
        buffer = _buffers['${frequency}_$waveType'];
      }

      // Generate and cache if not found (user custom frequency)
      if (buffer == null) {
        buffer = await _createBuffer(
          frequency: frequency,
          waveType: waveType,
          volume: 1.0,
        );
        _buffers['${frequency}_$waveType'] = buffer; // Cache for future use
        debugPrint('[AudioEngine] Generated and cached custom frequency: ${frequency}_$waveType');
      }

      // Create buffer source and play (ZERO synthesis latency!)
      final source = _audioContext!.createBufferSource();
      source.buffer = buffer;

      // Apply volume envelope to avoid clicking
      final gainNode = _audioContext!.createGain();
      gainNode.gain.setValueAtTime(0, now);
      gainNode.gain.linearRampToValueAtTime(volume, now + 0.001);
      gainNode.gain.exponentialRampToValueAtTime(0.001, now + 0.04);

      // Connect nodes
      source.connect(gainNode);
      gainNode.connect(_audioContext!.destination);

      // Play short click (40ms like Reaper)
      source.start(now);

      debugPrint(
        '[AudioEngine] Played click: accent=$isAccent, freq=${frequency}Hz, wave=$waveType, vol=$volume',
      );
    } catch (e) {
      debugPrint('[AudioEngine] Error playing click: $e');
    }
  }

  /// Schedule a click to play at a specific time (for lookahead scheduling)
  /// [time] - Absolute time in seconds (audioContext.currentTime)
  /// [isAccent] - true for accented beat (higher pitch)
  /// [waveType] - 'sine', 'square', 'triangle', or 'sawtooth'
  /// [volume] - 0.0 to 1.0
  /// [accentFrequency] - frequency for accented beat in Hz (default: 1600)
  /// [beatFrequency] - frequency for regular beat in Hz (default: 800)
  void scheduleClick(
    double time, {
    required bool isAccent,
    required String waveType,
    required double volume,
    double? accentFrequency,
    double? beatFrequency,
  }) {
    if (!_initialized || _audioContext == null) return;

    try {
      final frequency = isAccent
          ? (accentFrequency ?? 1600.0)
          : (beatFrequency ?? 800.0);

      // Try to use cached common sounds first
      web.AudioBuffer? buffer;
      if (isAccent && frequency == 1600 && waveType == 'sine') {
        buffer = _accentSine;
      } else if (!isAccent && frequency == 800 && waveType == 'sine') {
        buffer = _beatSine;
      } else if (isAccent && frequency == 1600 && waveType == 'square') {
        buffer = _accentSquare;
      } else if (!isAccent && frequency == 800 && waveType == 'square') {
        buffer = _beatSquare;
      } else {
        buffer = _buffers['${frequency}_$waveType'];
      }

      if (buffer == null) return;

      // Create buffer source and schedule for exact playback time
      final source = _audioContext!.createBufferSource();
      source.buffer = buffer;

      // Apply volume envelope
      final gainNode = _audioContext!.createGain();
      gainNode.gain.setValueAtTime(0, time);
      gainNode.gain.linearRampToValueAtTime(volume, time + 0.001);
      gainNode.gain.exponentialRampToValueAtTime(0.001, time + 0.04);

      // Connect nodes
      source.connect(gainNode);
      gainNode.connect(_audioContext!.destination);

      // Schedule exact playback time (sample-accurate!)
      source.start(time);
    } catch (e) {
      debugPrint('[AudioEngine] Error scheduling click: $e');
    }
  }

  /// Play test sound to verify audio works
  Future<void> playTest() async {
    await playClick(
      isAccent: true,
      waveType: 'sine',
      volume: 0.5,
      accentFrequency: 1600,
      beatFrequency: 800,
    );
    await Future.delayed(const Duration(milliseconds: 200));
    await playClick(
      isAccent: false,
      waveType: 'sine',
      volume: 0.5,
      accentFrequency: 1600,
      beatFrequency: 800,
    );
  }

  /// Create an AudioBuffer with synthesized audio data
  /// This is called once during initialization for each frequency/wave combination
  Future<web.AudioBuffer> _createBuffer({
    required double frequency,
    required String waveType,
    required double volume,
  }) async {
    if (_audioContext == null) {
      throw StateError('AudioContext not initialized');
    }

    final sampleRate = _audioContext!.sampleRate;
    final duration = 0.04; // 40ms click
    final frameCount = (sampleRate * duration).toInt();

    // Create audio buffer
    final buffer = _audioContext!.createBuffer(1, frameCount, sampleRate);
    final data = buffer.getChannelData(0);

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
        waveFunc = (phase) => _sin(2 * 3.14159265359 * phase);
        break;
    }

    // Generate samples with envelope
    const attackTime = 0.001;
    const decayTime = 0.039;

    for (int i = 0; i < frameCount; i++) {
      final t = i / sampleRate;
      final phase = (frequency * t) % 1.0;

      // Apply envelope
      double envelope;
      if (t < attackTime) {
        envelope = t / attackTime;
      } else if (t < duration) {
        final decayProgress = (t - attackTime) / decayTime;
        envelope = _exp(-3.0 * decayProgress);
      } else {
        envelope = 0.0;
      }

      data[i] = waveFunc(phase) * volume * envelope;
    }

    return buffer;
  }

  // Math helpers for web compatibility
  double _sin(double x) => x.isNaN ? 0 : _sinImpl(x);
  double _sinImpl(double x) {
    // Taylor series approximation for sin
    final x2 = x * x;
    return x * (1 - x2 / 6 * (1 - x2 / 20 * (1 - x2 / 42)));
  }

  double _exp(double x) => x.isNaN ? 0 : _expImpl(x);
  double _expImpl(double x) {
    // Taylor series approximation for exp
    if (x < -20) return 0;
    if (x > 20) return double.infinity;
    double result = 1;
    double term = 1;
    for (int i = 1; i < 20; i++) {
      term *= x / i;
      result += term;
    }
    return result;
  }

  /// Dispose audio resources
  void dispose() {
    _audioContext?.close();
    _buffers.clear();
    _accentSine = null;
    _beatSine = null;
    _accentSquare = null;
    _beatSquare = null;
    _initialized = false;
    debugPrint('[AudioEngine] Disposed');
  }
}
