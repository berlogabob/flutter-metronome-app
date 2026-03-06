// Sample generator for metronome tones
// Generates PCM audio samples based on tone configuration

import 'dart:math';
import 'dart:typed_data';
import '../../models/metronome_tone_config.dart';

/// Generates and caches audio samples for metronome
/// 
/// **Usage:**
/// 1. Configure tone settings
/// 2. Generate all samples (run once)
/// 3. Cache and reuse (zero runtime synthesis)
/// 4. Regenerate only when settings change
class MetronomeSampleGenerator {
  /// Audio sample rate (44.1 kHz standard)
  static const int sampleRate = 44100;
  
  /// Cache of generated samples: [cacheKey] -> PCM bytes
  final Map<String, Uint8List> _sampleCache = {};
  
  /// Current tone configuration
  MetronomeToneConfig _config = const MetronomeToneConfig();
  
  /// Check if samples are generated and cached
  bool get isInitialized => _sampleCache.isNotEmpty;
  
  /// Get current configuration
  MetronomeToneConfig get config => _config;

  /// Generate all samples based on current configuration
  /// 
  /// Call this when:
  /// - App starts (initial generation)
  /// - User changes tone settings (regeneration)
  /// - User changes wave type (regeneration)
  Future<void> generateAllSamples() async {
    _sampleCache.clear();
    
    // Generate samples for all 6 beat type + accent combinations
    _generateAndCache(BeatType.main, AccentState.regular);
    _generateAndCache(BeatType.main, AccentState.accent);
    _generateAndCache(BeatType.sub, AccentState.regular);
    _generateAndCache(BeatType.sub, AccentState.accent);
    _generateAndCache(BeatType.divider, AccentState.regular);
    _generateAndCache(BeatType.divider, AccentState.accent);
    
    print('[SampleGenerator] Generated ${_sampleCache.length} samples');
  }

  /// Update configuration and regenerate all samples
  Future<void> updateConfig(MetronomeToneConfig newConfig) async {
    _config = newConfig;
    await generateAllSamples();
  }

  /// Get cached sample for beat type and accent state
  Uint8List? getSample(BeatType beatType, AccentState accent) {
    final key = _getCacheKey(beatType, accent);
    return _sampleCache[key];
  }

  /// Get sample or generate on-demand (fallback)
  Uint8List getSampleOrGenerate(BeatType beatType, AccentState accent) {
    final cached = getSample(beatType, accent);
    if (cached != null) return cached;
    
    // Fallback: generate on-demand (shouldn't happen if initialized)
    print('[SampleGenerator] Cache miss, generating on-demand: $beatType/$accent');
    final frequency = _config.getFrequency(beatType, accent);
    return _generateSample(frequency, _config.waveType, _config.volume);
  }

  /// Generate and cache a single sample
  void _generateAndCache(BeatType beatType, AccentState accent) {
    final frequency = _config.getFrequency(beatType, accent);
    final key = _getCacheKey(beatType, accent);
    
    _sampleCache[key] = _generateSample(
      frequency,
      _config.waveType,
      _config.volume,
    );
  }

  /// Generate PCM sample for a specific frequency
  Uint8List _generateSample(double frequency, String waveType, double volume) {
    final numSamples = (sampleRate * _config.clickDuration).toInt();
    
    // Generate float samples
    final samples = _generateWaveform(
      frequency: frequency,
      waveType: waveType,
      volume: volume,
      numSamples: numSamples,
    );
    
    // Convert to 16-bit PCM
    return _floatToPcm16(samples);
  }

  /// Generate waveform samples
  Float32List _generateWaveform({
    required double frequency,
    required String waveType,
    required double volume,
    required int numSamples,
  }) {
    final samples = Float32List(numSamples);
    
    // Wave function selector
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
    
    // Generate samples with envelope
    for (int i = 0; i < numSamples; i++) {
      final t = i / sampleRate;
      final phase = (frequency * t) % 1.0;
      final envelope = _calculateEnvelope(t, _config.clickDuration);
      samples[i] = waveFunc(phase) * volume * envelope;
    }
    
    return samples;
  }

  /// Convert float samples to 16-bit PCM with WAV header
  Uint8List _floatToPcm16(Float32List samples) {
    final numSamples = samples.length;
    final byteData = ByteData(44 + numSamples * 2);
    
    // WAV header
    _writeWavHeader(byteData, numSamples);
    
    // PCM data
    for (int i = 0; i < numSamples; i++) {
      final sample = samples[i].clamp(-1.0, 1.0);
      final intSample = (sample * 32767).toInt();
      byteData.setInt16(44 + i * 2, intSample, Endian.little);
    }
    
    return byteData.buffer.asUint8List();
  }

  /// Write WAV header
  void _writeWavHeader(ByteData byteData, int numSamples) {
    // RIFF chunk
    byteData.setUint8(0, 0x52); // 'R'
    byteData.setUint8(1, 0x49); // 'I'
    byteData.setUint8(2, 0x46); // 'F'
    byteData.setUint8(3, 0x46); // 'F'
    byteData.setUint32(4, 36 + numSamples * 2, Endian.little);
    
    // WAVE format
    byteData.setUint8(8, 0x57); // 'W'
    byteData.setUint8(9, 0x41); // 'A'
    byteData.setUint8(10, 0x56); // 'V'
    byteData.setUint8(11, 0x45); // 'E'
    
    // fmt subchunk
    byteData.setUint8(12, 0x66); // 'f'
    byteData.setUint8(13, 0x6D); // 'm'
    byteData.setUint8(14, 0x74); // 't'
    byteData.setUint8(15, 0x20); // ' '
    byteData.setUint32(16, 16, Endian.little); // Subchunk1Size
    byteData.setUint16(20, 1, Endian.little); // AudioFormat (PCM)
    byteData.setUint16(22, 1, Endian.little); // NumChannels (mono)
    byteData.setUint32(24, sampleRate, Endian.little); // SampleRate
    byteData.setUint32(28, sampleRate * 2, Endian.little); // ByteRate
    byteData.setUint16(32, 2, Endian.little); // BlockAlign
    byteData.setUint16(34, 16, Endian.little); // BitsPerSample
    
    // data subchunk
    byteData.setUint8(36, 0x64); // 'd'
    byteData.setUint8(37, 0x61); // 'a'
    byteData.setUint8(38, 0x74); // 't'
    byteData.setUint8(39, 0x61); // 'a'
    byteData.setUint32(40, numSamples * 2, Endian.little);
  }

  /// Calculate amplitude envelope (ADSR-like)
  double _calculateEnvelope(double time, double duration) {
    const attackTime = 0.001; // 1ms
    const decayTime = 0.039; // 39ms
    
    if (time < attackTime) {
      // Attack: linear ramp up
      return time / attackTime;
    } else if (time < duration) {
      // Decay: exponential
      final decayProgress = (time - attackTime) / decayTime;
      return exp(-3.0 * decayProgress);
    }
    return 0.0;
  }

  /// Generate cache key for beat type and accent
  String _getCacheKey(BeatType beatType, AccentState accent) {
    return '${beatType.name}_${accent.name}';
  }

  /// Clear cache (free memory)
  void clearCache() {
    _sampleCache.clear();
  }

  /// Get cache info for debugging
  Map<String, dynamic> getCacheInfo() {
    return {
      'sampleCount': _sampleCache.length,
      'config': _config.toJson(),
      'keys': _sampleCache.keys.toList(),
    };
  }
}
