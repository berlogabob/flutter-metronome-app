import 'package:json_annotation/json_annotation.dart';
import '../models/time_signature.dart';

part 'metronome_preset.g.dart';

/// Preset configuration for metronome settings.
///
/// Provides quick access to commonly used metronome configurations
/// including tempo, time signature, and audio settings.
///
/// Example usage:
/// ```dart
/// // Load a preset
/// final preset = MetronomePreset.defaults.first;
/// state = state.copyWith(
///   bpm: preset.bpm,
///   timeSignature: preset.timeSignature,
///   waveType: preset.waveType,
/// );
/// ```
@JsonSerializable()
class MetronomePreset {
  /// Unique identifier for this preset.
  @JsonKey(defaultValue: '')
  final String id;

  /// Human-readable name for the preset.
  @JsonKey(defaultValue: '')
  final String name;

  /// Tempo in beats per minute.
  final int bpm;

  /// Time signature for the preset.
  final TimeSignature timeSignature;

  /// Audio wave type: 'sine', 'square', 'triangle', or 'sawtooth'.
  @JsonKey(defaultValue: 'sine')
  final String waveType;

  /// Whether accent beats are enabled.
  @JsonKey(defaultValue: true)
  final bool accentEnabled;

  /// Creation timestamp for the preset.
  @JsonKey(fromJson: _parseDateTime, toJson: _dateTimeToJson)
  final DateTime createdAt;

  /// Creates a new [MetronomePreset] with the specified values.
  const MetronomePreset({
    required this.id,
    required this.name,
    required this.bpm,
    required this.timeSignature,
    required this.waveType,
    required this.accentEnabled,
    required this.createdAt,
  });

  /// Creates a [MetronomePreset] from JSON data.
  ///
  /// Used for deserializing Firestore documents.
  factory MetronomePreset.fromJson(Map<String, dynamic> json) =>
      _$MetronomePresetFromJson(json);

  /// Converts this preset to JSON format.
  ///
  /// Used for serializing to Firestore.
  Map<String, dynamic> toJson() => _$MetronomePresetToJson(this);

  /// Creates a copy of this preset with the given fields replaced.
  ///
  /// All parameters are nullable. Only non-null values will be updated.
  MetronomePreset copyWith({
    String? id,
    String? name,
    int? bpm,
    TimeSignature? timeSignature,
    String? waveType,
    bool? accentEnabled,
    DateTime? createdAt,
  }) {
    return MetronomePreset(
      id: id ?? this.id,
      name: name ?? this.name,
      bpm: bpm ?? this.bpm,
      timeSignature: timeSignature ?? this.timeSignature,
      waveType: waveType ?? this.waveType,
      accentEnabled: accentEnabled ?? this.accentEnabled,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Display name with BPM and time signature for UI presentation.
  ///
  /// Format: "Name (BPM TimeSignature)"
  /// Example: "Slow Practice (60 BPM 4 / 4)"
  String get displayName => '$name ($bpm BPM ${timeSignature.displayName})';

  /// Common metronome preset configurations.
  ///
  /// Includes:
  /// - Slow Practice: 60 BPM, 4/4 time, sine wave
  /// - Medium Rock: 120 BPM, 4/4 time, square wave
  /// - Waltz: 90 BPM, 3/4 time, sine wave
  static final List<MetronomePreset> defaults = [
    MetronomePreset(
      id: 'default_1',
      name: 'Slow Practice',
      bpm: 60,
      timeSignature: const TimeSignature(numerator: 4, denominator: 4),
      waveType: 'sine',
      accentEnabled: true,
      createdAt: DateTime(2026),
    ),
    MetronomePreset(
      id: 'default_2',
      name: 'Medium Rock',
      bpm: 120,
      timeSignature: const TimeSignature(numerator: 4, denominator: 4),
      waveType: 'square',
      accentEnabled: true,
      createdAt: DateTime(2026),
    ),
    MetronomePreset(
      id: 'default_3',
      name: 'Waltz',
      bpm: 90,
      timeSignature: const TimeSignature(numerator: 3, denominator: 4),
      waveType: 'sine',
      accentEnabled: true,
      createdAt: DateTime(2026),
    ),
  ];
}

DateTime _parseDateTime(dynamic value) {
  if (value == null) return DateTime.now();
  if (value is DateTime) return value;
  return DateTime.parse(value as String);
}

String? _dateTimeToJson(DateTime? value) => value?.toIso8601String();
