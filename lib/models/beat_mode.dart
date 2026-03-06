/// Beat mode for individual beat customization in the metronome.
///
/// Allows fine-grained control over how each beat sounds during playback.
/// Used in conjunction with [MetronomeState.beatModes] to create custom
/// rhythmic patterns.
///
/// Example usage:
/// ```dart
/// // Set first beat to accent, second to silent, third to normal
/// final beatModes = [
///   [BeatMode.accent],
///   [BeatMode.silent],
///   [BeatMode.normal],
/// ];
/// ```
enum BeatMode {
  /// Default beat with normal sound at standard frequency.
  normal,

  /// Accented beat with +300 Hz frequency boost for emphasis.
  accent,

  /// Silent beat - visual only, no audio playback.
  /// Useful for practicing internal timing.
  silent,
}
