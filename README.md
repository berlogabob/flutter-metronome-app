# RepSync Metronome - Standalone App

This is a standalone metronome app extracted from the main RepSync application. It uses the **same Firebase backend**, so all data stays synchronized.

## Setup Instructions

### 1. Install Dependencies
```bash
cd metronomeapp
flutter pub get
```

### 2. Firebase Configuration

The app uses the same Firebase project as the main RepSync app. Firebase config files are already copied:
- `firebase.json`
- `.firebaserc`
- `firestore.rules`
- `lib/firebase_options.dart`

**No additional Firebase setup needed** - just make sure you have access to the same Google account.

### 3. Run the App
```bash
# Web (recommended for development)
flutter run -d chrome

# iOS
flutter run

# Android
flutter run
```

## Architecture

### Same Firebase, Same Data
- ✅ Users authenticate with the same accounts
- ✅ Songs, setlists, and bands are shared
- ✅ Metronome settings saved to songs appear in both apps
- ✅ Real-time sync between apps

### Key Differences from Main App
- Focused only on metronome functionality
- No band management UI
- No setlist creation/editing (but can load existing setlists)
- Streamlined for practice sessions

## Development Workflow

### Working Separately
1. Make changes to metronome code in this folder
2. Test independently
3. Commit to a separate branch if needed

### Merging Back to Main App
When ready to rejoin with the main app:

```bash
# From main app root
cp -r metronomeapp/lib/models/* lib/models/
cp -r metronomeapp/lib/providers/* lib/providers/data/
cp -r metronomeapp/lib/widgets/metronome/* lib/widgets/metronome/
cp -r metronomeapp/lib/services/audio/* lib/services/audio/
# ... etc
```

Or use git to merge branches if you're using version control.

## File Structure

```
metronomeapp/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── models/                      # Data models
│   │   ├── metronome_state.dart
│   │   ├── metronome_preset.dart
│   │   ├── song.dart               # Shared with main app
│   │   └── ...
│   ├── providers/
│   │   └── metronome_provider.dart # State management
│   ├── screens/
│   │   └── metronome_screen.dart   # Main UI
│   ├── services/
│   │   ├── audio/                  # Audio engine
│   │   └── firestore_service.dart  # Firebase operations
│   ├── widgets/
│   │   ├── metronome/              # Metronome-specific widgets
│   │   └── ...
│   └── router/
│       └── app_router.dart         # Navigation
├── test/                           # All tests
├── firebase.json                   # Firebase config
└── pubspec.yaml                    # Dependencies
```

## Testing

```bash
# Run all tests
flutter test

# Run specific test
flutter test test/providers/metronome_provider_test.dart
```

## Notes

- **Firestore Security Rules**: Same as main app - users can only access their own data
- **Offline Support**: Works offline, syncs when connected
- **Audio**: Uses `just_audio` package for metronome sounds

## Common Issues

### Firebase Auth Error
Make sure you're logged into the same Google account used for the main app.

### Port Already in Use
If running on web and port 8080 is busy:
```bash
flutter run -d chrome --web-port=8081
```

### Missing Dependencies
```bash
flutter clean
flutter pub get
```
