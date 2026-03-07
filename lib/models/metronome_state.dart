import 'package:json_annotation/json_annotation.dart';
import 'time_signature.dart';
import 'beat_mode.dart';
import 'song.dart';
import '../models/setlist.dart';

part 'metronome_state.g.dart';

/// Immutable state class for [MetronomeNotifier].
///
/// Represents the complete state of the metronome including playback status,
/// tempo, time signature, audio settings, and loaded content (songs/setlists).
/// This class is used with Riverpod's NotifierProvider for state management.
///
/// Example usage:
/// ```dart
/// final state = MetronomeState.initial();
/// final updated = state.copyWith(bpm: 140, isPlaying: true);
/// ```
@JsonSerializable()
class MetronomeState {
  /// Whether the metronome is currently playing.
  @JsonKey(defaultValue: false)
  final bool isPlaying;

  /// Beats per minute (tempo). Range: 10-260 BPM.
  @JsonKey(defaultValue: 120)
  final int bpm;

  /// Current beat index in the playback cycle.
  @JsonKey(defaultValue: 0)
  final int currentBeat;

  /// The time signature defining beats per measure.
  final TimeSignature timeSignature;

  /// Audio wave type: 'sine', 'square', 'triangle', or 'sawtooth'.
  @JsonKey(defaultValue: 'sine')
  final String waveType;

  /// Audio volume level from 0.0 to 1.0.
  @JsonKey(defaultValue: 0.5)
  final double volume;

  /// Whether accent beats are enabled.
  @JsonKey(defaultValue: true)
  final bool accentEnabled;

  /// Frequency in Hz for accented beats.
  @JsonKey(defaultValue: 1600)
  final double accentFrequency;

  /// Frequency in Hz for regular beats.
  @JsonKey(defaultValue: 800)
  final double beatFrequency;

  /// Pattern defining which beats are accented.
  ///
  /// Each boolean represents whether the corresponding beat should be accented.
  @JsonKey(defaultValue: [])
  final List<bool> accentPattern;

  /// Number of beats per measure (top number of time signature).
  ///
  /// For example, in 4/4 time this would be 4.
  @JsonKey(defaultValue: 4)
  final int accentBeats;

  /// Number of subdivisions per beat (bottom number of time signature).
  ///
  /// For example, in 4/4 time this would be 1 (quarter notes),
  /// or 4 for sixteenth note subdivisions.
  @JsonKey(defaultValue: 1)
  final int regularBeats;

  /// Whether vibration on beats is enabled.
  @JsonKey(defaultValue: false)
  final bool vibrationEnabled;

  /// 2D grid of beat modes for individual beat customization.
  ///
  /// First index is beat number, second index is subdivision number.
  /// Empty list means all beats use normal mode.
  @JsonKey(defaultValue: [])
  final List<List<BeatMode>> beatModes;

  /// Currently loaded song, if any.
  @JsonKey(defaultValue: null)
  final Song? loadedSong;

  /// Currently loaded setlist, if any.
  @JsonKey(defaultValue: null)
  final Setlist? loadedSetlist;

  /// Current index in the loaded setlist's song queue.
  @JsonKey(defaultValue: 0)
  final int currentSetlistIndex;

  /// Creates a new [MetronomeState] with the specified values.
  const MetronomeState({
    required this.isPlaying,
    required this.bpm,
    required this.currentBeat,
    required this.timeSignature,
    required this.waveType,
    required this.volume,
    required this.accentEnabled,
    required this.accentFrequency,
    required this.beatFrequency,
    required this.accentPattern,
    this.accentBeats = 4,
    this.regularBeats = 1,
    this.vibrationEnabled = false,
    this.beatModes = const [], // Empty = all normal (2D: beats × subdivisions)
    this.loadedSong,
    this.loadedSetlist,
    this.currentSetlistIndex = 0,
  });

  /// Creates initial metronome state with default values.
  ///
  /// Returns a stopped metronome at 120 BPM with 4/4 time signature,
  /// sine wave, and standard accent pattern.
  factory MetronomeState.initial() {
    return const MetronomeState(
      isPlaying: false,
      bpm: 120,
      currentBeat: 0,
      timeSignature: TimeSignature.commonTime,
      waveType: 'sine',
      volume: 0.5,
      accentEnabled: true,
      accentFrequency: 1600,
      beatFrequency: 800,
      accentPattern: [true, false, false, false],
      accentBeats: 4,
      regularBeats: 1,
      beatModes: [], // Empty = all normal
    );
  }

  /// Creates a copy of this state with the given fields replaced.
  ///
  /// All parameters are nullable. Only non-null values will be updated.
  /// This is useful for immutable state updates in Riverpod notifiers.
  ///
  /// Example:
  /// ```dart
  /// final newState = state.copyWith(bpm: 140, isPlaying: true);
  /// ```
  MetronomeState copyWith({
    bool? isPlaying,
    int? bpm,
    int? currentBeat,
    TimeSignature? timeSignature,
    String? waveType,
    double? volume,
    bool? accentEnabled,
    double? accentFrequency,
    double? beatFrequency,
    List<bool>? accentPattern,
    int? accentBeats,
    int? regularBeats,
    bool? vibrationEnabled,
    List<List<BeatMode>>? beatModes,
    Song? loadedSong,
    Setlist? loadedSetlist,
    int? currentSetlistIndex,
  }) {
    return MetronomeState(
      isPlaying: isPlaying ?? this.isPlaying,
      bpm: bpm ?? this.bpm,
      currentBeat: currentBeat ?? this.currentBeat,
      timeSignature: timeSignature ?? this.timeSignature,
      waveType: waveType ?? this.waveType,
      volume: volume ?? this.volume,
      accentEnabled: accentEnabled ?? this.accentEnabled,
      accentFrequency: accentFrequency ?? this.accentFrequency,
      beatFrequency: beatFrequency ?? this.beatFrequency,
      accentPattern: accentPattern ?? this.accentPattern,
      accentBeats: accentBeats ?? this.accentBeats,
      regularBeats: regularBeats ?? this.regularBeats,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      beatModes: beatModes ?? this.beatModes,
      loadedSong: loadedSong ?? this.loadedSong,
      loadedSetlist: loadedSetlist ?? this.loadedSetlist,
      currentSetlistIndex: currentSetlistIndex ?? this.currentSetlistIndex,
    );
  }

  /// Creates a [MetronomeState] from JSON data.
  ///
  /// Used for deserializing Firestore documents and SharedPreferences data.
  factory MetronomeState.fromJson(Map<String, dynamic> json) =>
      _$MetronomeStateFromJson(json);

  /// Converts this state to JSON format.
  ///
  /// Used for serializing to Firestore and SharedPreferences.
  Map<String, dynamic> toJson() => _$MetronomeStateToJson(this);

  // Backward compatibility getters
  /// Returns beats per measure (alias for accentBeats).
  @Deprecated('Use accentBeats instead')
  int get beatsPerMeasure => accentBeats;

  /// Check if a beat index should be accented based on accentPattern.
  ///
  /// Returns false if the index is out of bounds.
  bool isAccentBeat(int beatIndex) {
    if (beatIndex < 0 || beatIndex >= accentPattern.length) return false;
    return accentPattern[beatIndex];
  }
}
