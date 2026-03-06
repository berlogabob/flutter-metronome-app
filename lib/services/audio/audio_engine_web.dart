// Web audio engine with generated sample cache
// Samples are generated once at startup based on user settings
// For mobile, use audio_engine_mobile.dart

import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;
import 'metronome_sample_generator.dart';
import '../../models/metronome_tone_config.dart';

/// Audio engine for metronome with user-configurable tones (Web)
/// 
/// **Architecture:**
/// 1. User defines frequencies in settings (tone matrix)
/// 2. Generator creates AudioBuffers once at startup
/// 3. Buffers cached in memory (zero runtime synthesis)
/// 4. Regenerate only when user changes settings
/// 
/// **2-Step System Support:**
/// - Main beat (regular + accent)
/// - Sub beat (regular + accent)
/// - Divider beat (regular + accent)
class AudioEngine {
  /// Web Audio Context
  web.AudioContext? _audioContext;
  
  /// Sample generator - creates AudioBuffers from settings
  final MetronomeSampleGeneratorWeb _generator = MetronomeSampleGeneratorWeb();
  
  /// Cached AudioBuffers for quick access
  final Map<String, web.AudioBuffer> _buffers = {};
  
  bool _initialized = false;

  /// Check if engine is ready
  bool get initialized => _initialized;
  
  /// Get current tone configuration
  MetronomeToneConfig get toneConfig => _generator.config;

  /// Initialize audio engine and generate samples
  Future<void> initialize([MetronomeToneConfig? config]) async {
    if (_initialized && config == null) return;

    try {
      if (_audioContext == null) {
        _audioContext = web.AudioContext();
      }
      
      // Update config if provided
      if (config != null) {
        await _generator.updateConfig(config, _audioContext!);
      } else if (!_generator.isInitialized) {
        await _generator.generateAllSamples(_audioContext!);
      }
      
      // Cache buffers for fast access
      _buffers.addAll(_generator.getBufferCache());
      
      _initialized = true;
      debugPrint('[AudioEngine] Web initialized with ${_generator.config.waveType} wave');
    } catch (e) {
      debugPrint('[AudioEngine] Failed: $e');
      rethrow;
    }
  }

  /// Update tone configuration and regenerate samples
  Future<void> updateToneConfig(MetronomeToneConfig config) async {
    if (_audioContext == null) return;
    await _generator.updateConfig(config, _audioContext!);
    _buffers.addAll(_generator.getBufferCache());
    debugPrint('[AudioEngine] Tone config updated');
  }

  /// Play click for specific beat type and accent state
  Future<void> playBeat({
    required BeatType beatType,
    required AccentState accent,
  }) async {
    if (!_initialized) await initialize();
    if (_audioContext == null) return;

    try {
      final key = _getBufferKey(beatType, accent);
      final buffer = _buffers[key];
      
      if (buffer == null) {
        debugPrint('[AudioEngine] Buffer not found: $key');
        return;
      }
      
      // Create source node (very fast)
      final source = _audioContext!.createBufferSource();
      source.buffer = buffer;
      
      // Volume control
      final gainNode = _audioContext!.createGain();
      gainNode.gain.value = _generator.config.volume;
      
      // Connect and play
      source.connect(gainNode);
      gainNode.connect(_audioContext!.destination);
      source.start(0);
      
    } catch (e) {
      debugPrint('[AudioEngine] Error: $e');
    }
  }

  /// Schedule a beat to play at specific time (for lookahead scheduler)
  void scheduleBeat({
    required double time,
    required BeatType beatType,
    required AccentState accent,
  }) {
    if (!_initialized || _audioContext == null) return;

    try {
      final key = _getBufferKey(beatType, accent);
      final buffer = _buffers[key];
      
      if (buffer == null) return;
      
      final source = _audioContext!.createBufferSource();
      source.buffer = buffer;
      
      final gainNode = _audioContext!.createGain();
      gainNode.gain.value = _generator.config.volume;
      
      source.connect(gainNode);
      gainNode.connect(_audioContext!.destination);
      
      // Schedule for exact future time (hardware-timed!)
      source.start(time);
      
    } catch (e) {
      debugPrint('[AudioEngine] Schedule error: $e');
    }
  }

  /// Legacy playClick method (backward compatibility)
  Future<void> playClick({
    required bool isAccent,
    required String waveType,
    required double volume,
    double? accentFrequency,
    double? beatFrequency,
  }) async {
    final beatType = isAccent ? BeatType.main : BeatType.sub;
    final accent = isAccent ? AccentState.accent : AccentState.regular;
    await playBeat(beatType: beatType, accent: accent);
  }

  /// Generate buffer key
  String _getBufferKey(BeatType beatType, AccentState accent) {
    return '${beatType.name}_${accent.name}';
  }

  /// Play test sound
  Future<void> playTest() async {
    if (!_initialized) await initialize();
    
    await playBeat(beatType: BeatType.main, accent: AccentState.accent);
    await Future.delayed(const Duration(milliseconds: 300));
    await playBeat(beatType: BeatType.main, accent: AccentState.regular);
    await Future.delayed(const Duration(milliseconds: 300));
    await playBeat(beatType: BeatType.sub, accent: AccentState.accent);
    await Future.delayed(const Duration(milliseconds: 300));
    await playBeat(beatType: BeatType.sub, accent: AccentState.regular);
  }

  /// Dispose resources
  void dispose() {
    _audioContext?.close();
    _buffers.clear();
    _generator.clearCache();
    _initialized = false;
    debugPrint('[AudioEngine] Disposed');
  }
}

/// Web-specific sample generator using AudioBuffer
class MetronomeSampleGeneratorWeb {
  /// Audio context (required for AudioBuffer creation)
  web.AudioContext? _audioContext;
  
  /// Cached AudioBuffers
  final Map<String, web.AudioBuffer> _bufferCache = {};
  
  /// Current tone configuration
  MetronomeToneConfig _config = const MetronomeToneConfig();
  
  bool get isInitialized => _bufferCache.isNotEmpty;
  MetronomeToneConfig get config => _config;

  /// Generate all AudioBuffers
  Future<void> generateAllSamples(web.AudioContext context) async {
    _audioContext = context;
    _bufferCache.clear();
    
    _generateAndCache(BeatType.main, AccentState.regular);
    _generateAndCache(BeatType.main, AccentState.accent);
    _generateAndCache(BeatType.sub, AccentState.regular);
    _generateAndCache(BeatType.sub, AccentState.accent);
    _generateAndCache(BeatType.divider, AccentState.regular);
    _generateAndCache(BeatType.divider, AccentState.accent);
    
    debugPrint('[SampleGenerator] Generated ${_bufferCache.length} buffers');
  }

  /// Update configuration and regenerate
  Future<void> updateConfig(MetronomeToneConfig newConfig, web.AudioContext context) async {
    _config = newConfig;
    await generateAllSamples(context);
  }

  /// Get buffer cache
  Map<String, web.AudioBuffer> getBufferCache() => Map.unmodifiable(_bufferCache);

  /// Generate and cache a single buffer
  void _generateAndCache(BeatType beatType, AccentState accent) {
    final frequency = _config.getFrequency(beatType, accent);
    final key = '${beatType.name}_${accent.name}';
    
    final buffer = _audioContext!.createBuffer(
      1,
      (_audioContext!.sampleRate * _config.clickDuration).toInt(),
      _audioContext!.sampleRate,
    );
    
    final data = buffer.getChannelData(0);
    _generateWaveform(
      data: data,
      frequency: frequency,
      waveType: _config.waveType,
      volume: _config.volume,
    );
    
    _bufferCache[key] = buffer;
  }

  /// Generate waveform directly into AudioBuffer
  void _generateWaveform({
    required web.Float32Array data,
    required double frequency,
    required String waveType,
    required double volume,
  }) {
    final numSamples = data.length;
    
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
    
    for (int i = 0; i < numSamples; i++) {
      final t = i / _audioContext!.sampleRate;
      final phase = (frequency * t) % 1.0;
      final envelope = _calculateEnvelope(t, _config.clickDuration);
      data[i] = waveFunc(phase) * volume * envelope;
    }
  }

  double _calculateEnvelope(double time, double duration) {
    const attackTime = 0.001;
    const decayTime = 0.039;
    
    if (time < attackTime) return time / attackTime;
    if (time < duration) {
      final progress = (time - attackTime) / decayTime;
      return exp(-3.0 * progress);
    }
    return 0.0;
  }

  void clearCache() {
    _bufferCache.clear();
  }
}
