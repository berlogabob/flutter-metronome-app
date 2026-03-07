/// Abstract interface for audio engine - allows mocking in tests
/// 
/// This interface defines the contract for audio engine implementations,
/// enabling dependency injection for testing purposes.
abstract class IAudioEngine {
  /// Whether the audio engine has been initialized
  bool get initialized;
  
  /// Initialize the audio engine
  Future<void> initialize();
  
  /// Play a click sound
  /// 
  /// [isAccent] - true for accented beat (higher pitch)
  /// [waveType] - 'sine', 'square', 'triangle', or 'sawtooth'
  /// [volume] - 0.0 to 1.0
  /// [accentFrequency] - frequency for accented beat in Hz
  /// [beatFrequency] - frequency for regular beat in Hz
  Future<void> playClick({
    required bool isAccent,
    required String waveType,
    required double volume,
    double? accentFrequency,
    double? beatFrequency,
  });
  
  /// Play a test sound to verify audio works
  Future<void> playTest();
  
  /// Dispose audio resources
  void dispose();
}
