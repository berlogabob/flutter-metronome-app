# RepSync Metronome - Complete Migration Guide

**Version**: 2.0.0+1 → 2.1.0+1  
**Total Duration**: 10 Sprints (2-3 weeks)  
**Generated**: 2026-03-11

---

## Overview

This guide breaks down the complete modernization plan into **10 short sprints** (1-3 hours each). Each sprint is self-contained with clear goals, steps, and verification.

### Sprint Structure
```
📋 Goal → What we're achieving
⏱️ Time → Estimated duration
📦 Packages → What to add/update
🔧 Steps → Step-by-step instructions
✅ Verify → How to confirm success
🐛 Troubleshoot → Common issues
```

---

# Phase 1: Foundation (Sprints 1-3)

## Sprint 1.1: Update Core Dependencies

**Goal**: Update Riverpod, JSON serializer, and build tools to latest versions  
**⏱️ Time**: 45 minutes  
**📦 Packages**: `flutter_riverpod`, `json_serializable`, `build_runner`

### Steps

#### 1. Update `pubspec.yaml`
```yaml
dependencies:
  flutter_riverpod: ^3.3.1        # was ^3.0.3
  json_annotation: ^4.9.0         # keep same

dev_dependencies:
  build_runner: ^2.4.12           # was ^2.4.8
  json_serializable: ^6.8.0       # was ^6.7.1
```

#### 2. Get Dependencies
```bash
flutter pub get
```

#### 3. Regenerate Code
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

#### 4. Run Tests
```bash
flutter test
```

#### 5. Build Web
```bash
flutter build web
```

### ✅ Verify
- [ ] `flutter pub get` completes without errors
- [ ] All `.g.dart` files regenerate successfully
- [ ] All tests pass: `flutter test`
- [ ] Web build succeeds: `flutter build web`

### 🐛 Troubleshoot

**Error**: `Conflicting dependencies`  
**Fix**: 
```bash
flutter clean
flutter pub get
```

**Error**: `Generated code doesn't match`  
**Fix**:
```bash
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## Sprint 1.2: Add `gap` Package

**Goal**: Replace `SizedBox` spacers with `Gap` widget for cleaner code  
**⏱️ Time**: 2 hours  
**📦 Packages**: `gap: ^3.0.0`

### Steps

#### 1. Add Dependency
```yaml
# pubspec.yaml
dependencies:
  gap: ^3.0.0
```

#### 2. Get Package
```bash
flutter pub get
```

#### 3. Update Imports
Add to all widget files:
```dart
import 'package:gap/gap.dart';
```

#### 4. Replace `SizedBox` with `Gap`

**Files to update:**
- `lib/screens/metronome_screen.dart`
- `lib/widgets/metronome/time_signature_block.dart`
- `lib/widgets/metronome/central_tempo_circle.dart`
- `lib/widgets/metronome/fine_adjustment_buttons.dart`
- `lib/widgets/metronome/bottom_transport_bar.dart`
- `lib/widgets/metronome/song_library_block.dart`
- `lib/widgets/settings/tone_settings_dialog.dart`

**Before:**
```dart
Column(
  children: [
    Widget1(),
    SizedBox(height: 16),
    Widget2(),
    SizedBox(height: 24),
    Widget3(),
  ],
)
```

**After:**
```dart
Column(
  children: [
    Widget1(),
    const Gap(16),
    Widget2(),
    const Gap(24),
    Widget3(),
  ],
)
```

#### 5. Run Analysis
```bash
flutter analyze
```

### ✅ Verify
- [ ] No `SizedBox(height: X)` in widget files (use grep to confirm)
- [ ] `flutter analyze` shows no errors
- [ ] UI looks identical (manual check)
- [ ] Tests pass

### 🐛 Troubleshoot

**Error**: `The name Gap isn't a class`  
**Fix**: Add import `import 'package:gap/gap.dart';`

**Error**: `const Gap` fails  
**Fix**: Remove `const` - Gap constructor is not const

---

## Sprint 1.3: Add `very_good_analysis`

**Goal**: Enable stricter linting for better code quality  
**⏱️ Time**: 1.5 hours  
**📦 Packages**: `very_good_analysis: ^6.0.0`

### Steps

#### 1. Add Dev Dependency
```yaml
# pubspec.yaml
dev_dependencies:
  very_good_analysis: ^6.0.0
```

#### 2. Update `analysis_options.yaml`
```yaml
include: package:very_good_analysis/analysis_options.yaml

linter:
  rules:
    # Override for our project
    public_member_api_docs: false      # Too strict for widgets
    lines_longer_than_80_chars: false  # Allow longer lines
    use_setters_to_change_properties: false
    avoid_print: false                 # Allow debugPrint
```

#### 3. Get Package
```bash
flutter pub get
```

#### 4. Run Analysis
```bash
flutter analyze
```

#### 5. Fix Common Issues

**Issue 1**: Missing documentation comments
```dart
// Add to public members
/// Initializes the metronome state.
@override
MetronomeState build() => MetronomeState.initial();
```

**Issue 2**: Long lines
```dart
// Break into multiple lines
final newState = state.copyWith(
  isPlaying: true,
  bpm: clampedBpm,
  timeSignature: timeSignature,
);
```

**Issue 3**: Unused imports
```bash
# Remove imports flagged by analyzer
```

**Issue 4**: Use `debugPrint` instead of `print`
```dart
// Before
print('Metronome started');

// After
debugPrint('[Metronome] Started');
```

### ✅ Verify
- [ ] `flutter analyze` shows < 50 warnings
- [ ] No errors in analysis
- [ ] All tests still pass
- [ ] Code compiles

### 🐛 Troubleshoot

**Too many warnings (>100)**:  
**Fix**: Temporarily disable some rules:
```yaml
linter:
  rules:
    public_member_api_docs: false
    lines_longer_than_80_chars: false
    sort_pub_directives: false
    prefer_single_quotes: false
```

**Build fails**:  
**Fix**: Add `// ignore:` comments for specific lines:
```dart
// ignore: avoid_print
print('Debug info');
```

---

# Phase 2: Form Validation (Sprints 2-3)

## Sprint 2.1: Add `formz` Package

**Goal**: Set up formz for type-safe form validation  
**⏱️ Time**: 1 hour  
**📦 Packages**: `formz: ^0.8.0`

### Steps

#### 1. Add Dependency
```yaml
# pubspec.yaml
dependencies:
  formz: ^0.8.0
```

#### 2. Get Package
```bash
flutter pub get
```

#### 3. Create Directory Structure
```bash
mkdir -p lib/models/forms
mkdir -p lib/widgets/forms
```

#### 4. Create Error Enum
```dart
// lib/models/forms/song_input_error.dart
/// Validation errors for song input fields.
enum SongInputError {
  /// Title is empty or whitespace only.
  emptyTitle,
  
  /// BPM is outside valid range (10-260).
  invalidBpm,
  
  /// Artist name is empty.
  emptyArtist,
  
  /// Time signature numerator invalid (2-12).
  invalidNumerator,
  
  /// Time signature denominator invalid (4 or 8).
  invalidDenominator,
}
```

#### 5. Create First Input: `SongTitle`
```dart
// lib/models/forms/song_title.dart
import 'package:formz/formz.dart';
import 'song_input_error.dart';

/// Form input for song title validation.
class SongTitle extends FormzInput<String, SongInputError> {
  /// Pure state (no user interaction).
  const SongTitle.pure() : super.pure('');

  /// Dirty state (user has interacted).
  const SongTitle.dirty([super.value = '']) : super.dirty();

  @override
  SongInputError? validator(String value) {
    if (value.trim().isEmpty) {
      return SongInputError.emptyTitle;
    }
    return null;
  }

  /// Display-friendly error message.
  String get errorMessage {
    switch (error) {
      case SongInputError.emptyTitle:
        return 'Title cannot be empty';
      default:
        return null;
    }
  }
}
```

#### 6. Create Second Input: `SongBpm`
```dart
// lib/models/forms/song_bpm.dart
import 'package:formz/formz.dart';
import 'song_input_error.dart';

/// Form input for BPM validation.
class SongBpm extends FormzInput<int?, SongInputError> {
  /// Pure state.
  const SongBpm.pure() : super.pure(null);

  /// Dirty state.
  const SongBpm.dirty([super.value]) : super.dirty();

  @override
  SongInputError? validator(int? value) {
    if (value == null) return SongInputError.invalidBpm;
    if (value < 10 || value > 260) return SongInputError.invalidBpm;
    return null;
  }

  /// Display error message.
  String get errorMessage {
    switch (error) {
      case SongInputError.invalidBpm:
        return 'BPM must be between 10 and 260';
      default:
        return null;
    }
  }
}
```

### ✅ Verify
- [ ] `flutter pub get` succeeds
- [ ] Form inputs compile
- [ ] `flutter analyze` shows no errors
- [ ] Can create instances: `SongTitle.pure()`, `SongBpm.dirty(120)`

### 🐛 Troubleshoot

**Error**: `FormzInput not found`  
**Fix**: Check import: `import 'package:formz/formz.dart';`

---

## Sprint 2.2: Create Song Form State

**Goal**: Combine inputs into a complete form state  
**⏱️ Time**: 1.5 hours  

### Steps

#### 1. Create Form State Class
```dart
// lib/models/forms/song_form.dart
import 'package:formz/formz.dart';
import 'song_title.dart';
import 'song_bpm.dart';
import 'song_input_error.dart';

/// Complete form state for song creation/editing.
class SongForm extends FormzMixin<SongInputError> {
  /// Song title input.
  final SongTitle title;
  
  /// Song BPM input.
  final SongBpm bpm;
  
  /// Artist name (optional).
  final String artist;

  /// Create new form (pure state).
  const SongForm({
    this.title = const SongTitle.pure(),
    this.bpm = const SongBpm.pure(),
    this.artist = '',
  });

  /// Create form with existing song data.
  factory SongForm.fromSong(Map<String, dynamic> song) {
    return SongForm(
      title: SongTitle.dirty(song['title'] ?? ''),
      bpm: SongBpm.dirty(song['bpm']),
      artist: song['artist'] ?? '',
    );
  }

  /// Update title.
  SongForm copyWithTitle(String value) {
    return SongForm(
      title: SongTitle.dirty(value),
      bpm: bpm,
      artist: artist,
    );
  }

  /// Update BPM.
  SongForm copyWithBpm(int? value) {
    return SongForm(
      title: title,
      bpm: SongBpm.dirty(value),
      artist: artist,
    );
  }

  /// Update artist.
  SongForm copyWithArtist(String value) {
    return SongForm(
      title: title,
      bpm: bpm,
      artist: value,
    );
  }

  /// Get all inputs for validation.
  @override
  List<FormzInput<dynamic, SongInputError>> get inputs => [title, bpm];

  /// Check if form can be submitted.
  bool get canSubmit => isValid && title.value.isNotEmpty && bpm.value != null;

  /// Get current BPM value.
  int? get bpmValue => bpm.value;

  /// Get current title value.
  String get titleValue => title.value;

  /// Get current artist value.
  String get artistValue => artist;
}
```

#### 2. Create Form Provider
```dart
// lib/providers/song_form_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/forms/song_form.dart';

/// Provider for song form state.
final songFormProvider = StateNotifierProvider<SongFormNotifier, SongForm>(
  (ref) => SongFormNotifier(),
);

/// Notifier for song form state management.
class SongFormNotifier extends StateNotifier<SongForm> {
  /// Create notifier.
  SongFormNotifier() : super(const SongForm());

  /// Update title.
  void updateTitle(String value) {
    state = state.copyWithTitle(value);
  }

  /// Update BPM.
  void updateBpm(int? value) {
    state = state.copyWithBpm(value);
  }

  /// Update artist.
  void updateArtist(String value) {
    state = state.copyWithArtist(value);
  }

  /// Reset form to initial state.
  void reset() {
    state = const SongForm();
  }

  /// Check if form is valid.
  bool get isValid => state.isValid;

  /// Check if form can be submitted.
  bool get canSubmit => state.canSubmit;
}
```

### ✅ Verify
- [ ] Form state compiles
- [ ] Provider compiles
- [ ] Can update form: `ref.read(songFormProvider.notifier).updateTitle('Test')`
- [ ] Validation works: `state.isValid` returns correct value

---

## Sprint 2.3: Build Song Form UI

**Goal**: Create UI widget with validation feedback  
**⏱️ Time**: 2 hours  

### Steps

#### 1. Create Form Widget
```dart
// lib/widgets/forms/song_form_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../../providers/song_form_provider.dart';
import '../../models/forms/song_input_error.dart';
import '../../theme/mono_pulse_theme.dart';

/// Song creation/editing form with validation.
class SongFormWidget extends ConsumerWidget {
  /// Callback when form is submitted.
  final void Function(String title, int bpm, String artist) onSubmit;

  /// Create form widget.
  const SongFormWidget({super.key, required this.onSubmit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(songFormProvider);
    final notifier = ref.read(songFormProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Title Field
        TextFormField(
          initialValue: form.titleValue,
          decoration: InputDecoration(
            labelText: 'Title',
            errorText: form.title.displayError?.errorMessage,
            filled: true,
            fillColor: MonoPulseColors.surfaceRaised,
          ),
          onChanged: notifier.updateTitle,
          textInputAction: TextInputAction.next,
        ),
        const Gap(16),

        // BPM Field
        TextFormField(
          initialValue: form.bpmValue?.toString() ?? '',
          decoration: InputDecoration(
            labelText: 'BPM',
            errorText: form.bpm.displayError?.errorMessage,
            filled: true,
            fillColor: MonoPulseColors.surfaceRaised,
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            final bpm = int.tryParse(value);
            notifier.updateBpm(bpm);
          },
          textInputAction: TextInputAction.next,
        ),
        const Gap(16),

        // Artist Field
        TextFormField(
          initialValue: form.artistValue,
          decoration: InputDecoration(
            labelText: 'Artist (optional)',
            filled: true,
            fillColor: MonoPulseColors.surfaceRaised,
          ),
          onChanged: notifier.updateArtist,
          textInputAction: TextInputAction.done,
        ),
        const Gap(24),

        // Submit Button
        ElevatedButton(
          onPressed: form.canSubmit ? () => _submit(form, context) : null,
          child: const Text('Save Song'),
        ),
      ],
    );
  }

  void _submit(SongForm form, BuildContext context) {
    onSubmit(form.titleValue, form.bpmValue!, form.artistValue);
  }
}
```

#### 2. Test Form Integration
```dart
// In metronome_screen.dart or new screen
SongFormWidget(
  onSubmit: (title, bpm, artist) {
    // Save song logic
    debugPrint('Save: $title - $bpm BPM - $artist');
  },
)
```

### ✅ Verify
- [ ] Form displays correctly
- [ ] Validation errors show when invalid
- [ ] Submit button disabled when form invalid
- [ ] `onSubmit` called with correct values
- [ ] UI matches Mono Pulse theme

### 🐛 Troubleshoot

**Error**: `displayError not found`  
**Fix**: Use `FormzMixin` - check `SongForm` extends/mixes in correctly

**Form not updating**:  
**Fix**: Ensure using `ref.watch` for state and `ref.read` for notifier

---

# Phase 3: Code Generation (Sprints 3-4)

## Sprint 3.1: Add `riverpod_generator`

**Goal**: Set up code generation for Riverpod providers  
**⏱️ Time**: 1.5 hours  
**📦 Packages**: `riverpod_annotation`, `riverpod_generator`

### Steps

#### 1. Add Dependencies
```yaml
# pubspec.yaml
dependencies:
  riverpod_annotation: ^2.3.5

dev_dependencies:
  riverpod_generator: ^2.4.0
```

#### 2. Get Packages
```bash
flutter pub get
```

#### 3. Create First Generated Provider
```dart
// lib/providers/global_tone_config_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/metronome_tone_config.dart';

part 'global_tone_config_provider.g.dart';

/// Global tone configuration provider.
@riverpod
class GlobalToneConfig extends _$GlobalToneConfig {
  @override
  MetronomeToneConfig build() {
    return MetronomeToneConfig.initial();
  }

  /// Update wave type.
  void setWaveType(String type) {
    state = state.copyWith(waveType: type);
  }

  /// Update volume.
  void setVolume(double volume) {
    state = state.copyWith(volume: volume);
  }
}
```

#### 4. Generate Code
```bash
flutter pub run build_runner build
```

#### 5. Verify Generated File
Check that `global_tone_config_provider.g.dart` was created.

### ✅ Verify
- [ ] `.g.dart` file generated
- [ ] No build errors
- [ ] Provider accessible: `ref.watch(globalToneConfigProvider)`
- [ ] Notifier methods work: `ref.read(globalToneConfigProvider.notifier).setWaveType('sine')`

### 🐛 Troubleshoot

**Error**: `part file doesn't exist`  
**Fix**: Run `flutter pub run build_runner build`

**Error**: `@riverpod annotation not found`  
**Fix**: Check import: `import 'package:riverpod_annotation/riverpod_annotation.dart';`

---

## Sprint 3.2: Migrate Metronome Provider

**Goal**: Convert main metronome provider to use generator  
**⏱️ Time**: 2 hours  

### Steps

#### 1. Backup Current Provider
```bash
cp lib/providers/metronome_provider.dart lib/providers/metronome_provider.dart.bak
```

#### 2. Rewrite with Generator
```dart
// lib/providers/metronome_provider.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/metronome_state.dart';
import '../models/time_signature.dart';
import '../models/song.dart';
import '../models/beat_mode.dart';
import '../services/audio/audio_engine_mobile.dart';
import '../services/audio/i_audio_engine.dart';

part 'metronome_provider.g.dart';

/// Metronome state management notifier.
@riverpod
class Metronome extends _$Metronome {
  Timer? _timer;
  int _startTime = 0;
  late IAudioEngine _audioEngine;

  static IAudioEngine Function() _audioEngineFactory = () => AudioEngine();

  static void setAudioEngineFactory(IAudioEngine Function() factory) {
    _audioEngineFactory = factory;
  }

  static void resetAudioEngineFactory() {
    _audioEngineFactory = () => AudioEngine();
  }

  @override
  MetronomeState build() {
    _audioEngine = _audioEngineFactory();
    debugPrint('[MetronomeProvider] Audio engine assigned');
    return MetronomeState.initial();
  }

  /// Start metronome playback.
  void start(int bpm, int beatsPerMeasure) {
    if (state.isPlaying) return;

    _startTime = DateTime.now().millisecondsSinceEpoch;
    debugPrint('[Metronome] START pressed at ${_startTime}ms');

    final clampedBpm = bpm.clamp(10, 260);
    final timeSignature = TimeSignature(
      numerator: beatsPerMeasure,
      denominator: state.timeSignature.denominator,
    );

    List<bool> accentPattern;
    if (beatsPerMeasure == 6 && timeSignature.denominator == 8) {
      accentPattern = [true, true];
    } else {
      accentPattern = List.generate(beatsPerMeasure, (index) => index == 0);
    }

    state = state.copyWith(
      isPlaying: true,
      bpm: clampedBpm,
      timeSignature: timeSignature,
      currentBeat: -1,
      accentPattern: accentPattern,
    );

    _startTimer();
  }

  /// Stop metronome playback.
  void stop() {
    if (!state.isPlaying) return;

    _timer?.cancel();
    _timer = null;
    state = state.copyWith(isPlaying: false, currentBeat: 0);
  }

  // ... rest of methods stay the same ...

  void _startTimer() {
    final interval = Duration(milliseconds: (60000 ~/ state.bpm).clamp(1, 1500));
    _timer = Timer.periodic(interval, _onTick);
  }

  void _onTick(Timer timer) {
    // ... existing implementation ...
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioEngine.dispose();
  }
}
```

#### 3. Generate Code
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

#### 4. Update All Usages
The usage stays the same! No changes needed in widgets.

#### 5. Run Tests
```bash
flutter test test/providers/metronome_provider_test.dart
```

### ✅ Verify
- [ ] `.g.dart` file generated
- [ ] All tests pass
- [ ] Metronome starts/stops correctly
- [ ] No runtime errors

---

## Sprint 3.3: Migrate Data Providers

**Goal**: Convert data stream providers to generator  
**⏱️ Time**: 1 hour  

### Steps

#### 1. Update Data Providers
```dart
// lib/providers/data/data_providers.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../models/song.dart';
import '../../models/setlist.dart';

part 'data_providers.g.dart';

/// Provider for streaming user's songs.
@riverpod
Stream<List<Song>> songs(SongsRef ref) {
  // Return empty stream by default
  // Override in production with Firestore
  return Stream.value([]);
}

/// Provider for streaming user's setlists.
@riverpod
Stream<List<Setlist>> setlists(SetlistsRef ref) {
  return Stream.value([]);
}
```

#### 2. Generate Code
```bash
flutter pub run build_runner build
```

#### 3. Update Usage in Widgets
```dart
// Before
final songsAsync = ref.watch(songsProvider);

// After (same!)
final songsAsync = ref.watch(songsProvider);
```

### ✅ Verify
- [ ] Generated files created
- [ ] Stream providers work
- [ ] No breaking changes in widgets

---

# Phase 4: Model Migration (Sprints 4-7)

## Sprint 4.1: Add `freezed` Package

**Goal**: Set up freezed for code-generated models  
**⏱️ Time**: 1 hour  
**📦 Packages**: `freezed_annotation`, `freezed`

### Steps

#### 1. Add Dependencies
```yaml
# pubspec.yaml
dependencies:
  freezed_annotation: ^2.4.4

dev_dependencies:
  freezed: ^2.5.2
```

#### 2. Get Packages
```bash
flutter pub get
```

#### 3. Migrate `TimeSignature`
```dart
// lib/models/time_signature.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'time_signature.freezed.dart';
part 'time_signature.g.dart';

/// Represents a musical time signature.
@freezed
class TimeSignature with _$TimeSignature {
  /// Create time signature.
  const factory TimeSignature({
    @Default(4) int numerator,
    @Default(4) int denominator,
  }) = _TimeSignature;

  /// Parse from JSON.
  factory TimeSignature.fromJson(Map<String, dynamic> json) =>
      _$TimeSignatureFromJson(json);

  /// Common time: 4/4.
  static const commonTime = TimeSignature(numerator: 4, denominator: 4);

  /// Cut time: 2/2.
  static const cutTime = TimeSignature(numerator: 2, denominator: 2);

  /// Waltz time: 3/4.
  static const waltz = TimeSignature(numerator: 3, denominator: 4);

  /// Check if valid.
  bool get isValid =>
      numerator >= 2 &&
      numerator <= 12 &&
      (denominator == 4 || denominator == 8);

  /// Display name.
  String get displayName => '$numerator / $denominator';

  @override
  String toString() => displayName;
}
```

#### 4. Generate Code
```bash
flutter pub run build_runner build
```

#### 5. Verify Generated Files
- `time_signature.freezed.dart`
- `time_signature.g.dart`

### ✅ Verify
- [ ] Both `.freezed.dart` and `.g.dart` created
- [ ] `copyWith` auto-generated
- [ ] JSON serialization works
- [ ] Tests pass

---

## Sprint 4.2: Migrate Simple Models

**Goal**: Migrate small models to freezed  
**⏱️ Time**: 2 hours  

### Models to Migrate

#### 1. `MetronomeToneConfig`
```dart
// lib/models/metronome_tone_config.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'metronome_tone_config.freezed.dart';
part 'metronome_tone_config.g.dart';

/// Metronome tone configuration.
@freezed
class MetronomeToneConfig with _$MetronomeToneConfig {
  const factory MetronomeToneConfig({
    @Default('sine') String waveType,
    @Default(0.5) double volume,
    @Default(1600.0) double accentFrequency,
    @Default(800.0) double beatFrequency,
  }) = _MetronomeToneConfig;

  factory MetronomeToneConfig.fromJson(Map<String, dynamic> json) =>
      _$MetronomeToneConfigFromJson(json);

  factory MetronomeToneConfig.initial() {
    return const MetronomeToneConfig();
  }
}
```

#### 2. `Link`
```dart
// lib/models/link.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'link.freezed.dart';
part 'link.g.dart';

/// External resource link.
@freezed
class Link with _$Link {
  const factory Link({
    required String url,
    required String type,
    String? title,
  }) = _Link;

  factory Link.fromJson(Map<String, dynamic> json) => _$LinkFromJson(json);
}
```

#### 3. `Section`
```dart
// lib/models/section.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'section.freezed.dart';
part 'section.g.dart';

/// Song structure section.
@freezed
class Section with _$Section {
  const factory Section({
    required String name,
    required int startBeat,
    required int endBeat,
  }) = _Section;

  factory Section.fromJson(Map<String, dynamic> json) =>
      _$SectionFromJson(json);
}
```

### Generate Code
```bash
flutter pub run build_runner build
```

### ✅ Verify
- [ ] All models compile
- [ ] `copyWith` works for each
- [ ] JSON serialization works
- [ ] No breaking changes

---

## Sprint 4.3: Migrate `MetronomeState`

**Goal**: Migrate core state model to freezed  
**⏱️ Time**: 2 hours  

### Steps

#### 1. Rewrite Model
```dart
// lib/models/metronome_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'time_signature.dart';
import 'beat_mode.dart';
import 'song.dart';
import 'setlist.dart';

part 'metronome_state.freezed.dart';
part 'metronome_state.g.dart';

/// Metronome state.
@freezed
class MetronomeState with _$MetronomeState {
  const factory MetronomeState({
    @Default(false) bool isPlaying,
    @Default(120) int bpm,
    @Default(0) int currentBeat,
    @Default(TimeSignature.commonTime) TimeSignature timeSignature,
    @Default('sine') String waveType,
    @Default(0.5) double volume,
    @Default(true) bool accentEnabled,
    @Default(1600.0) double accentFrequency,
    @Default(800.0) double beatFrequency,
    @Default([]) List<bool> accentPattern,
    @Default(4) int accentBeats,
    @Default(1) int regularBeats,
    @Default(false) bool vibrationEnabled,
    @Default([]) List<List<BeatMode>> beatModes,
    Song? loadedSong,
    Setlist? loadedSetlist,
    @Default(0) int currentSetlistIndex,
  }) = _MetronomeState;

  factory MetronomeState.fromJson(Map<String, dynamic> json) =>
      _$MetronomeStateFromJson(json);

  factory MetronomeState.initial() {
    return const MetronomeState(
      isPlaying: false,
      bpm: 120,
      currentBeat: 0,
      timeSignature: TimeSignature.commonTime,
      waveType: 'sine',
      volume: 0.5,
      accentEnabled: true,
      accentFrequency: 1600.0,
      beatFrequency: 800.0,
      accentPattern: [true, false, false, false],
      accentBeats: 4,
      regularBeats: 1,
      beatModes: [],
    );
  }

  /// Check if accent beat.
  bool isAccentBeat(int beatIndex) {
    if (beatIndex < 0 || beatIndex >= accentPattern.length) return false;
    return accentPattern[beatIndex];
  }
}
```

#### 2. Generate Code
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

#### 3. Update Provider Usage
The `copyWith` is now auto-generated - no changes needed!

### ✅ Verify
- [ ] Provider compiles
- [ ] State updates work
- [ ] Tests pass
- [ ] JSON serialization works

---

## Sprint 4.4: Migrate `Song` Model

**Goal**: Migrate largest model to freezed  
**⏱️ Time**: 3 hours  

### Steps

#### 1. Rewrite Model
```dart
// lib/models/song.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'link.dart';
import 'beat_mode.dart';
import 'section.dart';

part 'song.freezed.dart';
part 'song.g.dart';

/// Song model.
@freezed
class Song with _$Song {
  const factory Song({
    required String id,
    required String title,
    required String artist,
    String? originalKey,
    int? originalBPM,
    String? ourKey,
    int? ourBPM,
    @Default([]) List<Link> links,
    String? notes,
    @Default([]) List<String> tags,
    String? bandId,
    String? spotifyUrl,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? originalOwnerId,
    String? originalSongId,
    String? contributedBy,
    @Default(false) bool isCopy,
    DateTime? contributedAt,
    @Default(4) int accentBeats,
    @Default(1) int regularBeats,
    @Default([]) List<List<BeatMode>> beatModes,
    @Default([]) List<Section> sections,
    String? spotifyId,
    String? musicbrainzId,
    String? isrc,
    String? deezerId,
    String? normalizedTitle,
    String? normalizedArtist,
    String? titleSoundex,
    String? artistSoundex,
    int? durationMs,
    String? album,
    String? variantType,
    String? variantOf,
  }) = _Song;

  factory Song.fromJson(Map<String, dynamic> json) => _$SongFromJson(json);
}
```

#### 2. Generate Code
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

#### 3. Update Firestore Service
Update any `copyWith` calls - they now use auto-generated version.

### ✅ Verify
- [ ] Model compiles
- [ ] Firestore operations work
- [ ] JSON serialization works
- [ ] All tests pass

---

## Sprint 4.5: Migrate Remaining Models

**Goal**: Complete model migration  
**⏱️ Time**: 2 hours  

### Models to Migrate

1. `MetronomePreset`
2. `Band`
3. `BandMember`
4. `Setlist`
5. `SetlistAssignment`
6. `User`

### Pattern (repeat for each)
```dart
// lib/models/[model].dart
import 'package:freezed_annotation/freezed_annotation.dart';

part '[model].freezed.dart';
part '[model].g.dart';

@freezed
class [Model] with _$[Model] {
  const factory [Model]({
    // fields with @Default for defaults
  }) = _[Model];

  factory [Model].fromJson(Map<String, dynamic> json) =>
      _$$[Model]FromJson(json);
}
```

### Generate All
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### ✅ Verify
- [ ] All 11 models migrated
- [ ] All `.freezed.dart` and `.g.dart` files exist
- [ ] Full test suite passes
- [ ] App builds and runs

---

# Phase 5: Optional Enhancements (Sprints 5-7)

## Sprint 5.1: Add `flutter_secure_storage`

**Goal**: Add encrypted storage for sensitive data  
**⏱️ Time**: 1.5 hours  
**📦 Packages**: `flutter_secure_storage: ^9.2.0`

### Steps

#### 1. Add Dependency
```yaml
dependencies:
  flutter_secure_storage: ^9.2.0
```

#### 2. Create Service
```dart
// lib/services/secure_storage_service.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure storage for sensitive data.
class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  /// Write auth token.
  Future<void> writeAuthToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  /// Read auth token.
  Future<String?> readAuthToken() async {
    return await _storage.read(key: 'auth_token');
  }

  /// Delete auth token.
  Future<void> deleteAuthToken() async {
    await _storage.delete(key: 'auth_token');
  }
}
```

### ✅ Verify
- [ ] Service compiles
- [ ] Can write/read values
- [ ] Android options configured

---

## Sprint 5.2: Add `hooks_riverpod`

**Goal**: Enable hooks for functional widgets  
**⏱️ Time**: 2 hours  
**📦 Packages**: `hooks_riverpod`, `flutter_hooks`

### Steps

#### 1. Add Dependencies
```yaml
dependencies:
  hooks_riverpod: ^3.3.1
  flutter_hooks: ^0.20.0
```

#### 2. Convert First Widget
```dart
// lib/widgets/metronome/central_tempo_circle.dart
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../providers/metronome_provider.dart';

class CentralTempoCircle extends HookConsumerWidget {
  const CentralTempoCircle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(metronomeProvider);
    final notifier = ref.watch(metronomeProvider.notifier);
    final rotation = useState<double>(0);

    useEffect(() {
      debugPrint('CentralTempoCircle mounted');
      return () => debugPrint('CentralTempoCircle disposed');
    }, []);

    return GestureDetector(
      onPanUpdate: (details) {
        rotation.value += details.delta.dx;
        notifier.rotateTempo(rotation.value);
      },
      child: Container(),
    );
  }
}
```

### ✅ Verify
- [ ] Widgets compile
- [ ] Hooks work correctly
- [ ] No memory leaks

---

## Sprint 5.3: Add `isar` (Optional)

**Goal**: Add local database for offline caching  
**⏱️ Time**: 3 hours  
**📦 Packages**: `isar`, `isar_flutter_libs`, `isar_generator`

### Steps

#### 1. Add Dependencies
```yaml
dependencies:
  isar: ^3.1.0+1
  isar_flutter_libs: ^3.1.0+1

dev_dependencies:
  isar_generator: ^3.1.0+1
```

#### 2. Define Schema
```dart
// lib/models/local_song.dart
import 'package:isar/isar.dart';

part 'local_song.g.dart';

/// Local cached song.
@collection
class LocalSong {
  Id id = Isar.autoIncrement;
  
  @Index(unique: true)
  late String songId;
  
  late String title;
  late String artist;
  late int bpm;
  late DateTime cachedAt;
}
```

### ✅ Verify
- [ ] Isar initializes
- [ ] Can cache songs
- [ ] Can query cached songs

---

# Phase 6: Final Steps (Sprints 6-7)

## Sprint 6.1: Full Test Suite

**Goal**: Run complete test suite and fix any issues  
**⏱️ Time**: 2 hours  

### Steps

#### 1. Run All Tests
```bash
flutter test --coverage
```

#### 2. Check Coverage
```bash
genhtml coverage/lcov.info -o coverage/html
```

#### 3. Fix Failing Tests
Address any test failures from migrations.

#### 4. Build All Platforms
```bash
flutter build web
flutter build apk --release
flutter build ios --release
```

### ✅ Verify
- [ ] All tests pass
- [ ] Coverage > 70%
- [ ] All platforms build
- [ ] No runtime errors

---

## Sprint 6.2: Documentation Update

**Goal**: Update all documentation for changes  
**⏱️ Time**: 1 hour  

### Steps

#### 1. Update README.md
- Document new packages
- Update architecture diagram
- Add migration notes

#### 2. Update CHANGELOG.md
```markdown
## [2.1.0+1] - 2026-03-11

### Added
- `gap` package for cleaner layouts
- `formz` for form validation
- `riverpod_generator` for code generation
- `freezed` for immutable models

### Changed
- Migrated all models to freezed
- Migrated all providers to riverpod_generator
- Updated dependencies to latest versions

### Improved
- Code quality with very_good_analysis
- Form validation with formz
- Developer experience with code generation
```

### ✅ Verify
- [ ] README updated
- [ ] CHANGELOG complete
- [ ] QWEN.md accurate

---

## Sprint 7: Final Review & Cleanup

**Goal**: Final code review and cleanup  
**⏱️ Time**: 2 hours  

### Steps

#### 1. Remove Backup Files
```bash
rm lib/providers/*.bak
```

#### 2. Run Final Analysis
```bash
flutter analyze
```

#### 3. Format Code
```bash
dart format .
```

#### 4. Clean Build
```bash
flutter clean
flutter pub get
flutter pub run build_runner build
```

#### 5. Final Test Run
```bash
flutter test
```

#### 6. Commit Changes
```bash
git add .
git commit -m "feat: Complete modernization migration

- Updated all dependencies to latest versions
- Added gap, formz, riverpod_generator, freezed
- Migrated all models to freezed
- Migrated all providers to riverpod_generator
- Added very_good_analysis for stricter linting

BREAKING CHANGE: Model APIs changed with freezed migration

Co-authored-by: Qwen-Coder <qwen-coder@alibabacloud.com>"
```

### ✅ Verify
- [ ] No backup files
- [ ] Clean analysis
- [ ] All tests pass
- [ ] Git commit complete

---

# Completion Checklist

## Phase 1: Foundation
- [ ] Sprint 1.1: Dependencies updated
- [ ] Sprint 1.2: `gap` package added
- [ ] Sprint 1.3: `very_good_analysis` added

## Phase 2: Form Validation
- [ ] Sprint 2.1: `formz` package added
- [ ] Sprint 2.2: Form state created
- [ ] Sprint 2.3: Form UI built

## Phase 3: Code Generation
- [ ] Sprint 3.1: `riverpod_generator` set up
- [ ] Sprint 3.2: Metronome provider migrated
- [ ] Sprint 3.3: Data providers migrated

## Phase 4: Models
- [ ] Sprint 4.1: `freezed` set up
- [ ] Sprint 4.2: Simple models migrated
- [ ] Sprint 4.3: `MetronomeState` migrated
- [ ] Sprint 4.4: `Song` model migrated
- [ ] Sprint 4.5: Remaining models migrated

## Phase 5: Optional
- [ ] Sprint 5.1: `flutter_secure_storage` (optional)
- [ ] Sprint 5.2: `hooks_riverpod` (optional)
- [ ] Sprint 5.3: `isar` (optional)

## Phase 6: Final
- [ ] Sprint 6.1: Full test suite
- [ ] Sprint 6.2: Documentation updated
- [ ] Sprint 7: Final review & cleanup

---

**Total Time**: 25-30 hours (10 sprints × 1.5-3 hours)  
**Risk Level**: Medium (mitigated by incremental approach)  
**Expected Outcome**: Modern, maintainable codebase with better DX

---

**Generated**: 2026-03-11  
**Version**: 2.0.0+1 → 2.1.0+1
