import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/metronome_state.dart';
import '../../models/time_signature.dart';
import '../../models/song.dart';
import '../../models/setlist.dart';
import '../../models/beat_mode.dart';
import '../../services/audio/audio_engine_export.dart';
import '../../services/audio/i_audio_engine.dart';

/// Metronome state management notifier using Riverpod 3.x.
///
/// Controls all aspects of metronome playback including:
/// - Start/stop functionality
/// - BPM adjustment (10-260 range)
/// - Time signature configuration
/// - Beat mode customization
/// - Song and setlist loading
/// - Audio playback via [AudioEngine]
///
/// Example usage:
/// ```dart
/// // Access the provider
/// final notifier = ref.read(metronomeProvider.notifier);
///
/// // Start metronome at 120 BPM, 4 beats per measure
/// notifier.start(120, 4);
///
/// // Adjust tempo
/// notifier.setBpm(140);
///
/// // Stop metronome
/// notifier.stop();
/// ```
class MetronomeNotifier extends Notifier<MetronomeState> {
  Timer? _timer;
  int _startTime = 0; // Timestamp when START was pressed (for timing measurements)

  /// Audio engine instance - can be overridden for testing
  /// Uses late initialization to allow injection before first use
  late IAudioEngine _audioEngine;

  /// Static factory for creating audio engine - can be overridden in tests
  static IAudioEngine Function() _audioEngineFactory = () => AudioEngineSoloud();

  /// Initialize audio engine - called in build() from shared pre-initialized instance
  /// No lazy initialization needed - audio is already ready in main()

  /// Override the audio engine factory - used for testing
  /// Call this before creating the provider to use a mock
  static void setAudioEngineFactory(IAudioEngine Function() factory) {
    _audioEngineFactory = factory;
  }

  /// Reset the audio engine factory to default - used for test cleanup
  static void resetAudioEngineFactory() {
    _audioEngineFactory = () => AudioEngineSoloud();
  }

  /// Initializes the metronome state.
  ///
  /// Called by Riverpod when the provider is first created.
  /// Returns the initial stopped state with default settings.
  /// Also initializes the audio engine.
  @override
  MetronomeState build() {
    _audioEngine = _audioEngineFactory();
    debugPrint('[MetronomeProvider] Audio engine assigned (initialized=${_audioEngine.initialized})');
    return MetronomeState.initial();
  }

  /// Starts the metronome playback.
  ///
  /// Initializes audio engine on first call and begins the timer
  /// for beat playback. Auto-generates accent pattern based on
  /// the time signature.
  ///
  /// [bpm] - Tempo in beats per minute (clamped to 10-260)
  /// [beatsPerMeasure] - Number of beats per measure (numerator)
  ///
  /// Does nothing if already playing.
  void start(int bpm, int beatsPerMeasure) {
    if (state.isPlaying) return;

    _startTime = DateTime.now().millisecondsSinceEpoch;
    debugPrint('[Metronome] START pressed at ${_startTime}ms (audio initialized=${_audioEngine.initialized})');

    // Restricted BPM range: 10-260 (more realistic, reduces edge cases)
    final clampedBpm = bpm.clamp(10, 260);
    final timeSignature = TimeSignature(
      numerator: beatsPerMeasure,
      denominator: state.timeSignature.denominator,
    );

    // Auto-generate accent pattern for new time signature
    List<bool> accentPattern;
    if (beatsPerMeasure == 6 && timeSignature.denominator == 8) {
      accentPattern = [true, true]; // 2 main beats for 6/8
    } else {
      accentPattern = List.generate(
        beatsPerMeasure,
        (index) => index == 0, // First beat is accent
      );
    }

    // Audio engine is already pre-initialized in main() - no lazy init needed!
    // This eliminates the 350-700ms delay on first start (Huawei P30)

    state = state.copyWith(
      isPlaying: true,
      bpm: clampedBpm,
      timeSignature: timeSignature,
      currentBeat: -1, // Will be 0 on first tick
      accentPattern: accentPattern,
    );

    _startTimer();
  }

  /// Stops the metronome playback.
  ///
  /// Cancels the timer and resets the current beat to 0.
  /// Does nothing if not currently playing.
  void stop() {
    if (!state.isPlaying) return;

    _timer?.cancel();
    _timer = null;

    state = state.copyWith(isPlaying: false, currentBeat: 0);
  }

  /// Updates the tempo (BPM) while playing.
  ///
  /// [bpm] - New tempo in beats per minute (clamped to 10-260)
  ///
  /// Restarts the timer if currently playing to apply the new tempo.
  void setBpm(int bpm) {
    // Restricted BPM range: 10-260
    final clampedBpm = bpm.clamp(10, 260);
    state = state.copyWith(bpm: clampedBpm);

    if (state.isPlaying) {
      _timer?.cancel();
      _startTimer();
    }
  }

  /// Sets the number of beats per measure (top number of time signature).
  ///
  /// [count] - Number of beats (clamped to 1-12)
  void setAccentBeats(int count) {
    final clampedCount = count.clamp(1, 12);
    state = state.copyWith(accentBeats: clampedCount);
  }

  /// Sets the number of subdivisions per beat (bottom number of time signature).
  ///
  /// [count] - Number of subdivisions (clamped to 1-12)
  void setRegularBeats(int count) {
    final clampedCount = count.clamp(1, 12);
    state = state.copyWith(regularBeats: clampedCount);
  }

  /// Sets the beat mode for an individual beat and subdivision.
  ///
  /// [beatIndex] - Index of the beat (0-based)
  /// [subdivisionIndex] - Index of the subdivision within the beat (0-based)
  /// [mode] - The beat mode (normal, accent, or silent)
  ///
  /// Expands the beatModes grid if necessary to accommodate the indices.
  void setBeatMode(int beatIndex, int subdivisionIndex, BeatMode mode) {
    final newBeatModes = List<List<BeatMode>>.from(
      state.beatModes.map((beat) => List<BeatMode>.from(beat)),
    );

    while (newBeatModes.length <= beatIndex) {
      newBeatModes.add([]);
    }

    while (newBeatModes[beatIndex].length <= subdivisionIndex) {
      newBeatModes[beatIndex].add(BeatMode.normal);
    }

    newBeatModes[beatIndex][subdivisionIndex] = mode;

    state = state.copyWith(beatModes: List.unmodifiable(newBeatModes));
  }

  /// Rotates the tempo using rotary dial gesture input.
  ///
  /// [degrees] - Rotation angle in degrees
  ///
  /// Converts degrees to BPM change (288 degrees = 1 BPM).
  /// Stops at the BPM limits (10 and 260).
  void rotateTempo(double degrees) {
    final bpmChange = (degrees / 288).round();
    // Restricted BPM range: 10-260
    final newBpm = (state.bpm + bpmChange).clamp(10, 260);

    // Stop at limits
    if (newBpm == state.bpm && (state.bpm == 10 || state.bpm == 260)) {
      return;
    }

    state = state.copyWith(bpm: newBpm);

    if (state.isPlaying) {
      _timer?.cancel();
      _startTimer();
    }
  }

  /// Fine adjustment for tempo using +1, +5, +10 buttons.
  ///
  /// [delta] - Amount to change BPM by (positive or negative)
  ///
  /// Clamps the result to the valid BPM range (10-260).
  void adjustTempoFine(int delta) {
    // Restricted BPM range: 10-260
    final newBpm = (state.bpm + delta).clamp(10, 260);
    state = state.copyWith(bpm: newBpm);

    if (state.isPlaying) {
      _timer?.cancel();
      _startTimer();
    }
  }

  /// Loads tempo and metronome settings from a song.
  ///
  /// [song] - The song to load settings from
  ///
  /// Updates BPM, accent beats, regular beats, and beat modes from the song.
  void loadSongTempo(Song song) {
    state = state.copyWith(loadedSong: song);

    final songBpm = song.ourBPM ?? song.originalBPM;
    if (songBpm != null) {
      // Restricted BPM range: 10-260
      final clampedBpm = songBpm.clamp(10, 260);
      state = state.copyWith(bpm: clampedBpm);
    }

    state = state.copyWith(
      accentBeats: song.accentBeats,
      regularBeats: song.regularBeats,
      beatModes: song.beatModes.isNotEmpty ? song.beatModes : state.beatModes,
    );

    final timeSignature = TimeSignature(
      numerator: song.accentBeats,
      denominator: state.timeSignature.denominator,
    );
    state = state.copyWith(timeSignature: timeSignature);

    if (state.isPlaying) {
      _timer?.cancel();
      _startTimer();
    }
  }

  /// Saves current metronome settings to the loaded song.
  ///
  /// Returns the updated song with current accent beats, regular beats,
  /// beat modes, and BPM. Returns null if no song is loaded.
  Song? saveMetronomeToSong() {
    final song = state.loadedSong;
    if (song == null) return null;

    final updatedSong = song.copyWith(
      accentBeats: state.accentBeats,
      regularBeats: state.regularBeats,
      beatModes: state.beatModes,
      ourBPM: state.bpm,
      updatedAt: DateTime.now(),
    );

    state = state.copyWith(loadedSong: updatedSong);

    return updatedSong;
  }

  /// Loads a setlist into the metronome queue.
  ///
  /// [setlist] - The setlist to load
  ///
  /// Resets the current song index to 0.
  void loadSetlistQueue(Setlist setlist) {
    state = state.copyWith(loadedSetlist: setlist, currentSetlistIndex: 0);
  }

  /// Moves to the next song in the setlist queue.
  ///
  /// Does nothing if no setlist is loaded or already at the last song.
  void nextSetlistSong() {
    if (state.loadedSetlist == null) return;

    final newIndex = state.currentSetlistIndex + 1;
    if (newIndex < state.loadedSetlist!.songIds.length) {
      state = state.copyWith(currentSetlistIndex: newIndex);
    }
  }

  /// Moves to the previous song in the setlist queue.
  ///
  /// Does nothing if no setlist is loaded or already at the first song.
  void previousSetlistSong() {
    if (state.loadedSetlist == null) return;

    if (state.currentSetlistIndex > 0) {
      state = state.copyWith(
        currentSetlistIndex: state.currentSetlistIndex - 1,
      );
    }
  }

  /// Clears the loaded song and setlist from state.
  ///
  /// Resets currentSetlistIndex to 0.
  void clearLoadedContent() {
    state = state.copyWith(
      loadedSong: null,
      loadedSetlist: null,
      currentSetlistIndex: 0,
    );
  }

  /// Sets the tempo directly to a specific BPM value.
  ///
  /// [bpm] - New tempo in beats per minute (clamped to 10-260)
  ///
  /// Restarts the timer if currently playing.
  void setTempoDirectly(int bpm) {
    // Restricted BPM range: 10-260
    final clampedBpm = bpm.clamp(10, 260);
    state = state.copyWith(bpm: clampedBpm);

    if (state.isPlaying) {
      _timer?.cancel();
      _startTimer();
    }
  }

  /// Sets the time signature for the metronome.
  ///
  /// [ts] - The new time signature
  ///
  /// Auto-generates accent pattern based on the time signature.
  /// Special handling for 6/8 time (2 main beats).
  void setTimeSignature(TimeSignature ts) {
    int beatCount;
    List<bool> accentPattern;

    if (ts.numerator == 6 && ts.denominator == 8) {
      beatCount = 2;
      accentPattern = [true, true];
    } else {
      beatCount = ts.numerator;
      accentPattern = List.generate(beatCount, (index) => index == 0);
    }

    state = state.copyWith(
      timeSignature: ts,
      accentBeats: beatCount,
      accentPattern: accentPattern,
    );

    if (state.isPlaying) {
      _timer?.cancel();
      _startTimer();
    }
  }

  /// Sets the audio wave type.
  ///
  /// [type] - Wave type: 'sine', 'square', 'triangle', or 'sawtooth'
  void setWaveType(String type) {
    state = state.copyWith(waveType: type);
  }

  /// Sets the audio volume.
  ///
  /// [volume] - Volume level from 0.0 to 1.0 (clamped)
  void setVolume(double volume) {
    final clampedVolume = volume.clamp(0.0, 1.0);
    state = state.copyWith(volume: clampedVolume);
  }

  /// Toggles whether accent beats are enabled.
  void toggleAccent() {
    state = state.copyWith(accentEnabled: !state.accentEnabled);
  }

  /// Sets whether accent beats are enabled.
  ///
  /// [enabled] - True to enable accents, false to disable
  void setAccentEnabled(bool enabled) {
    state = state.copyWith(accentEnabled: enabled);
  }

  /// Sets the frequency for accented beats.
  ///
  /// [frequency] - Frequency in Hz
  void setAccentFrequency(double frequency) {
    state = state.copyWith(accentFrequency: frequency);
  }

  /// Sets the frequency for regular beats.
  ///
  /// [frequency] - Frequency in Hz
  void setBeatFrequency(double frequency) {
    state = state.copyWith(beatFrequency: frequency);
  }

  /// Sets the accent pattern for the metronome.
  ///
  /// [pattern] - List of booleans indicating which beats are accented
  void setAccentPattern(List<bool> pattern) {
    state = state.copyWith(accentPattern: List.unmodifiable(pattern));
  }

  /// Toggles whether vibration on beats is enabled.
  void toggleVibration() {
    state = state.copyWith(vibrationEnabled: !state.vibrationEnabled);
  }

  /// Sets whether vibration on beats is enabled.
  ///
  /// [enabled] - True to enable vibration, false to disable
  void setVibrationEnabled(bool enabled) {
    state = state.copyWith(vibrationEnabled: enabled);
  }

  /// Updates the accent pattern based on the current time signature.
  ///
  /// Generates a pattern where the first beat is accented.
  /// Special handling for 6/8 time (2 main beats).
  void updateAccentPatternFromTimeSignature() {
    final ts = state.timeSignature;
    List<bool> accentPattern;

    if (ts.numerator == 6 && ts.denominator == 8) {
      accentPattern = [true, true];
    } else {
      accentPattern = List.generate(ts.numerator, (index) => index == 0);
    }

    state = state.copyWith(accentPattern: accentPattern);
  }

  /// Plays a test sound to verify audio settings.
  ///
  /// Useful for checking volume and wave type before starting playback.
  Future<void> playTest() async {
    // Audio engine is already pre-initialized - just play the test sound
    await _audioEngine.playTest();
  }

  /// Toggles between play and stop states.
  ///
  /// Convenience method that calls [start] or [stop] based on current state.
  void toggle() {
    if (state.isPlaying) {
      stop();
    } else {
      start(state.bpm, state.timeSignature.numerator);
    }
  }

  /// Starts the internal timer based on current BPM.
  ///
  /// Calculates interval from BPM and creates a periodic timer.
  /// Interval is clamped between 1ms and 1500ms.
  void _startTimer() {
    final interval = Duration(
      milliseconds: (60000 ~/ state.bpm).clamp(1, 1500),
    );
    _timer = Timer.periodic(interval, _onTick);
  }

  /// Handles timer tick for beat playback.
  ///
  /// Calculates current beat and subdivision indices,
  /// determines beat mode and frequency, and triggers audio playback.
  /// Updates state with new beat index.
  void _onTick(Timer timer) {
    if (!state.isPlaying) return;

    final totalTicks = state.accentBeats * state.regularBeats;
    final nextTick = (state.currentBeat + 1) % totalTicks;

    final currentBeatIndex = nextTick ~/ state.regularBeats;
    final currentSubdivisionIndex = nextTick % state.regularBeats;
    final isMainBeat = currentSubdivisionIndex == 0;

    final beatMode =
        currentBeatIndex < state.beatModes.length &&
            currentSubdivisionIndex < state.beatModes[currentBeatIndex].length
        ? state.beatModes[currentBeatIndex][currentSubdivisionIndex]
        : BeatMode.normal;

    double frequency;
    bool shouldPlay = true;

    if (beatMode == BeatMode.silent) {
      shouldPlay = false;
      frequency = isMainBeat ? 1760.0 : 880.0;
    } else if (beatMode == BeatMode.accent) {
      frequency = (isMainBeat ? 1760.0 : 880.0) + 300.0;
    } else {
      frequency = isMainBeat ? 1760.0 : 880.0;
    }

    if (shouldPlay) {
      // Audio engine is already pre-initialized - direct playback (<1ms latency)
      _audioEngine.playClick(
        isAccent: isMainBeat,
        waveType: state.waveType,
        volume: state.volume,
        accentFrequency: frequency,
        beatFrequency: frequency,
      );
      
      final audioTime = DateTime.now().millisecondsSinceEpoch;
      debugPrint('[Metronome] Audio PLAYED at ${audioTime}ms (delay=${audioTime - _startTime}ms, beat=$nextTick)');
    }

    // Vibration on beats (synchronized with audio)
    // NOTE: This is SEPARATE from UI button haptic feedback
    if (state.vibrationEnabled && shouldPlay) {
      final vibrationTime = DateTime.now().millisecondsSinceEpoch;
      debugPrint('[Metronome] Vibration TRIGGERED at ${vibrationTime}ms (delay=${vibrationTime - _startTime}ms, beat=$nextTick)');
      HapticFeedback.vibrate();
    } else if (shouldPlay) {
      debugPrint('[Metronome] Vibration SKIPPED (enabled=${state.vibrationEnabled}, beat=$nextTick)');
    }

    state = state.copyWith(currentBeat: nextTick);
  }

  /// Disposes resources when the provider is destroyed.
  ///
  /// Cancels the timer and disposes the audio engine.
  @override
  void dispose() {
    _timer?.cancel();
    _audioEngine.dispose();
  }
}

/// NotifierProvider for metronome state management.
///
/// Provides access to [MetronomeNotifier] and [MetronomeState].
/// Use this provider to read state or call notifier methods.
///
/// Example usage:
/// ```dart
/// // Read state
/// final state = ref.watch(metronomeProvider);
///
/// // Call notifier method
/// ref.read(metronomeProvider.notifier).start(120, 4);
/// ```
final metronomeProvider = NotifierProvider<MetronomeNotifier, MetronomeState>(
  MetronomeNotifier.new,
);
