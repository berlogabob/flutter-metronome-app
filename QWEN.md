# RepSync Metronome App - Project Context

## Project Overview

**RepSync Metronome** is a standalone Flutter metronome application extracted from the main RepSync application. It shares the same Firebase backend, enabling seamless data synchronization between apps.

### Purpose
- Provides focused metronome functionality for musicians
- Shares song, setlist, and band data with the main RepSync app
- Supports real-time sync of metronome settings saved to songs

### Core Technologies
- **Framework**: Flutter (SDK >=3.0.0 <4.0.0)
- **State Management**: Riverpod (Notifier pattern)
- **Backend**: Firebase (Auth, Firestore)
- **Audio**: `just_audio`, `audio_session` packages
- **Routing**: `go_router` for declarative navigation
- **Serialization**: `json_serializable` for JSON (de)serialization

## Architecture

### Directory Structure
```
lib/
├── main.dart                    # App entry point, Firebase initialization
├── firebase_options.dart        # Firebase configuration
├── router/
│   └── app_router.dart          # GoRouter setup with named routes
├── models/                      # Data models with json_serializable
│   ├── metronome_state.dart     # Metronome state (immutable)
│   ├── metronome_preset.dart    # Saved presets
│   ├── song.dart                # Song data (shared with main app)
│   ├── setlist.dart             # Setlist data
│   ├── band.dart                # Band information
│   ├── time_signature.dart      # Time signature value object
│   ├── beat_mode.dart           # Beat modes (normal/accent/silent)
│   └── *.g.dart                 # Generated JSON serialization
├── providers/
│   └── metronome_provider.dart  # Riverpod Notifier for state management
├── screens/
│   ├── metronome_screen.dart    # Main metronome UI
│   └── songs/                   # Song-related screens
├── services/
│   ├── audio/                   # Audio engine abstraction
│   │   ├── audio_engine.dart    # Export dispatcher (web/mobile)
│   │   ├── audio_engine_web.dart# Web Audio API implementation
│   │   ├── audio_engine_mobile.dart # Mobile audioplayers implementation
│   │   └── tone_generator.dart  # Sound generation
│   └── firestore_service.dart   # Firebase CRUD operations
├── widgets/
│   ├── metronome/               # Metronome-specific widgets
│   └── tools/                   # Shared tool screen components
└── theme/
    └── mono_pulse_theme.dart    # App theming
```

### Key Design Patterns
- **Riverpod Notifier Pattern**: Centralized state management for metronome
- **Immutable State**: `MetronomeState` class with `copyWith()` for updates
- **Platform-Specific Audio**: Conditional exports for web vs mobile audio engines
- **Value Objects**: `TimeSignature`, `BeatMode` for type safety

## Building and Running

### Prerequisites
- Flutter SDK (>=3.0.0)
- Firebase project access (same as main RepSync app)
- Google account for Firebase Auth

### Setup
```bash
# Install dependencies
flutter pub get

# Generate JSON serialization code
flutter pub run build_runner build --delete-conflicting-outputs

# Run on web (recommended for development)
flutter run -d chrome

# Run on iOS
flutter run

# Run on Android
flutter run
```

### Firebase Configuration
Firebase config files are pre-configured:
- `firebase.json` - Firebase project settings
- `firestore.rules` - Security rules (user-scoped access)
- `firestore.indexes.json` - Firestore indexes
- `lib/firebase_options.dart` - Platform-specific Firebase config

**No additional Firebase setup required** - uses same project as main RepSync app.

### Testing
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/providers/metronome_provider_test.dart

# Run integration tests
flutter test test/integration/
```

## Development Conventions

### Code Style
- **Linting**: `flutter_lints` package with custom rules
- **Preferences**:
  - Prefer `const` constructors
  - Prefer single quotes for strings
  - `print` statements allowed (for debugging)

### State Management (Riverpod)
```dart
// Define notifier
final metronomeProvider = NotifierProvider<MetronomeNotifier, MetronomeState>(
  () => MetronomeNotifier(),
);

// Use in widgets
final state = ref.watch(metronomeProvider);
final notifier = ref.watch(metronomeProvider.notifier);
```

### Model Patterns
- All models use `json_serializable` with `@JsonSerializable()`
- Generated files (`*.g.dart`) committed to version control
- Immutable models with `copyWith()` for state updates
- Sentinel pattern for nullable field updates in `Song` model

### Audio Architecture
- **Web**: Uses Web Audio API via `audio_engine_web.dart`
- **Mobile**: Uses `audioplayers` with synthesized PCM via `audio_engine_mobile.dart`
- Platform selection via conditional export in `audio_engine.dart`

### Firestore Security
- Users can only access their own data
- Band members share access to band collections
- Admin/editor roles control write permissions

## Key Features

### Metronome Functionality
- BPM range: 1-300 (rotary dial + fine adjustment)
- Time signature: Customizable beats and subdivisions
- Beat modes: Normal, Accent (+300Hz), Silent
- Wave types: Sine, square, triangle, sawtooth
- Volume control per sound type
- Accent pattern customization

### Data Sync
- Metronome settings saved to songs
- Setlist queue support
- Real-time Firestore synchronization
- Offline-first with sync on reconnect

### UI Components
- **TimeSignatureBlock**: Visual beats/subdivisions display
- **CentralTempoCircle**: Rotary dial for tempo adjustment
- **FineAdjustmentButtons**: +1/-1, +5/-5, +10/-10 BPM
- **BottomTransportBar**: Play/pause, next/previous
- **SongLibraryBlock**: Load/save song presets

## Common Operations

### Regenerate JSON Serialization
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Clean and Rebuild
```bash
flutter clean
flutter pub get
flutter pub run build_runner build
```

### Firebase Emulator
```bash
firebase emulators:start
```

### Deploy to Web
```bash
flutter build web
firebase deploy --only hosting
```

## Testing Strategy

### Test Organization
- `test/models/` - Unit tests for data models
- `test/providers/` - State management tests
- `test/services/` - Service layer tests
- `test/widgets/` - Widget tests
- `test/screens/` - Screen-level tests
- `test/integration/` - End-to-end flow tests

### Test Conventions
- Use `flutter_test` framework
- Mock Firebase with `firebase_auth_mocks` if needed
- Test both happy path and error scenarios

## Notes

### Metronome Logic (NEW)
- **accentBeats**: Top row (beats per measure, e.g., 4 in 4/4)
- **regularBeats**: Bottom row (subdivisions per beat)
- **beatModes**: 2D grid (beats × subdivisions) with independent modes
- Each subdivision has independent mode (not inherited from parent beat)

### Firebase Rules
- Users authenticate with same accounts as main app
- Songs, setlists, bands shared between apps
- Metronome settings saved to songs appear in both apps

### Known Limitations
- No band management UI (view-only from main app data)
- No setlist creation/editing (can load existing setlists)
- Streamlined for practice sessions only
