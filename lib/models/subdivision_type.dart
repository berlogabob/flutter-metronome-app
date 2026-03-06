import 'package:json_annotation/json_annotation.dart';

/// Subdivision types for metronome rhythmic patterns.
///
/// Defines how many subdivisions occur within each beat,
/// allowing for complex rhythmic practice patterns.
@JsonEnum()
enum SubdivisionType {
  /// Quarter notes - one subdivision per beat (1/1).
  /// Basic pulse without subdivisions.
  quarter,

  /// Eighth notes - two subdivisions per beat (1/2).
  /// Common for rock, pop, and folk music.
  eighth,

  /// Triplets - three subdivisions per beat (1/3).
  /// Used in jazz, blues, and shuffle rhythms.
  triplet,

  /// Sixteenth notes - four subdivisions per beat (1/4).
  /// Common in funk, R&B, and fast passages.
  sixteenth,
}

/// Extension to get subdivision multiplier and display information.
///
/// Provides utility methods for converting subdivision types
/// to their numeric multipliers and display labels.
extension SubdivisionMultiplier on SubdivisionType {
  /// Number of subdivisions per beat.
  ///
  /// Returns:
  /// - 1 for quarter notes
  /// - 2 for eighth notes
  /// - 3 for triplets
  /// - 4 for sixteenth notes
  int get multiplier {
    switch (this) {
      case SubdivisionType.quarter:
        return 1;
      case SubdivisionType.eighth:
        return 2;
      case SubdivisionType.triplet:
        return 3;
      case SubdivisionType.sixteenth:
        return 4;
    }
  }

  /// Display label for UI presentation.
  ///
  /// Returns musical notation:
  /// - '1/4' for quarter notes
  /// - '1/8' for eighth notes
  /// - '1/8T' for triplets
  /// - '1/16' for sixteenth notes
  String get label {
    switch (this) {
      case SubdivisionType.quarter:
        return '1/4';
      case SubdivisionType.eighth:
        return '1/8';
      case SubdivisionType.triplet:
        return '1/8T';
      case SubdivisionType.sixteenth:
        return '1/16';
    }
  }
}
