# RepSync Metronome

A professional Flutter metronome application with Firebase synchronization, designed for musicians and bands. Features collaborative song management, setlist creation, and real-time sync across band members.

[![Version](https://img.shields.io/badge/version-2.0.0+1-blue.svg)](CHANGELOG.md)
[![Flutter](https://img.shields.io/badge/flutter-3.x-blue.svg)](https://flutter.dev)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

## Features

### Core Metronome
- **BPM Range**: 10-260 BPM with precise tempo control
- **Time Signatures**: Support for 2/4 through 12/8 time signatures
- **Beat Modes**: Customize individual beats with normal, accent, or silent modes
- **Subdivisions**: Support for quarter, eighth, triplet, and sixteenth note subdivisions
- **Wave Types**: Sine, square, triangle, and sawtooth waveforms
- **Tone Customization**: Adjustable frequencies for accented and regular beats
- **Volume Control**: Per-beat volume adjustment

### Song Management
- **Personal Song Bank**: Store and organize your personal song collection
- **Metronome Settings**: Save BPM, time signature, and beat patterns per song
- **Song Sections**: Define verse, chorus, bridge, and other song sections
- **External Links**: Add YouTube, Spotify, Apple Music, and other reference links
- **Tags & Notes**: Organize songs with custom tags and performance notes
- **Key & BPM Tracking**: Track original and performance keys/BPM

### Band Collaboration
- **Band Creation**: Create bands with invite codes for member joining
- **Role-Based Access**: Admin, editor, and viewer permission levels
- **Shared Song Bank**: Collaborative song library for band members
- **Song Contributions**: Track who contributed each song to the band
- **Music Roles**: Assign instrument/vocal roles to band members

### Setlist Management
- **Event Setlists**: Create setlists for gigs, rehearsals, and events
- **Event Details**: Set date, time, and location for performances
- **Song Assignments**: Assign songs to specific band members with role overrides
- **Duration Tracking**: Automatic total duration calculation

### Firebase Integration
- **Authentication**: Secure user authentication via Firebase Auth
- **Real-time Sync**: Automatic synchronization across devices
- **Offline Support**: Local caching with Firestore
- **Security Rules**: Role-based access control at database level

## Architecture

### Tech Stack
- **Framework**: Flutter 3.x
- **State Management**: Riverpod 3.x with NotifierProvider
- **Backend**: Firebase (Firestore, Auth)
- **Audio**: audioplayers package
- **Navigation**: go_router 17.x
- **Serialization**: json_serializable

### Project Structure
```
lib/
├── main.dart                 # App entry point
├── firebase_options.dart     # Firebase configuration
├── models/                   # Data models
│   ├── api_error.dart        # Error handling
│   ├── band.dart             # Band and member models
│   ├── beat_mode.dart        # Beat mode enum
│   ├── link.dart             # External link model
│   ├── metronome_preset.dart # Preset configurations
│   ├── metronome_state.dart  # Metronome state
│   ├── metronome_tone_config.dart # Tone settings
│   ├── section.dart          # Song section model
│   ├── setlist.dart          # Setlist model
│   ├── setlist_assignment.dart # Member assignments
│   ├── song.dart             # Song model
│   ├── subdivision_type.dart # Subdivision enum
│   ├── time_signature.dart   # Time signature model
│   └── user.dart             # User model
├── providers/                # Riverpod providers
│   ├── data/
│   │   └── data_providers.dart # Data stream providers
│   ├── global_tone_config_provider.dart # Global tone settings
│   └── metronome_provider.dart # Metronome state provider
├── router/                   # Navigation configuration
├── screens/                  # UI screens
│   ├── metronome_screen.dart # Main metronome UI
│   └── songs/                # Song management screens
├── services/                 # Business logic
│   ├── audio/                # Audio engine
│   │   ├── audio_engine.dart
│   │   ├── audio_engine_export.dart
│   │   ├── audio_engine_mobile.dart
│   │   ├── audio_engine_web.dart
│   │   ├── metronome_sample_generator.dart
│   │   └── metronome_service.dart
│   └── firestore_service.dart # Firebase operations
├── theme/                    # App theming
└── widgets/                  # Reusable UI components
```

### State Management
The app uses Riverpod 3.x with a unidirectional data flow:

```
User Action → Notifier → State Update → UI Rebuild
     ↓
   Provider
```

Key providers:
- `metronomeProvider`: Manages metronome playback state
- `globalToneConfigProvider`: Global tone preferences
- `songsProvider`: Stream of user's songs
- `setlistsProvider`: Stream of user's setlists

## Getting Started

### Prerequisites
- Flutter SDK 3.11.0 or higher
- Dart SDK 3.11.0 or higher
- Firebase project with Firestore and Auth enabled
- Android Studio / Xcode for platform-specific setup

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-org/flutter_metronome_app.git
   cd flutter_metronome_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   
   a. Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
   
   b. Enable Authentication (Email/Password, Google Sign-In)
   
   c. Create a Firestore database
   
   d. Add your app platform (iOS/Android/Web)
   
   e. Download configuration files:
      - Android: `google-services.json` → `android/app/`
      - iOS: `GoogleService-Info.plist` → `ios/Runner/`
   
   f. Run FlutterFire CLI:
      ```bash
      dart pub global activate flutterfire_cli
      flutterfire configure
      ```

4. **Configure environment variables**
   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

5. **Update Firestore rules**
   ```bash
   firebase deploy --only firestore:rules
   firebase deploy --only firestore:indexes
   ```

6. **Run the app**
   ```bash
   flutter run
   ```

### Android Setup

For Android-specific configuration, see [ANDROID_SETUP.md](ANDROID_SETUP.md).

Key steps:
- Update `android/app/build.gradle` with Firebase dependencies
- Configure audio permissions in `AndroidManifest.xml`
- Set minimum SDK version to 21

### iOS Setup

- Update `ios/Runner/Info.plist` with required permissions
- Configure audio background mode if needed
- Run `pod install` in the `ios/` directory

## Usage

### Basic Metronome

1. Open the app to access the main metronome screen
2. Adjust BPM using the rotary dial or +/- buttons
3. Set time signature (numerator/denominator)
4. Press Play to start the metronome
5. Customize beat modes by tapping individual beats

### Creating a Song

1. Navigate to Songs screen
2. Tap "+" to create a new song
3. Enter title, artist, and other details
4. Configure metronome settings (BPM, time signature, beat modes)
5. Add sections (Verse, Chorus, etc.) if needed
6. Save to your personal song bank

### Creating a Band

1. Navigate to Bands screen
2. Tap "Create Band"
3. Enter band name and description
4. Generate an invite code
5. Share the code with band members
6. Members can join using the invite code

### Creating a Setlist

1. Navigate to Setlists screen
2. Tap "Create Setlist"
3. Enter event details (date, location)
4. Add songs from your song bank
5. Assign songs to band members
6. Save and share with the band

## Configuration

### Firestore Collections

The app uses the following Firestore structure:

```
users/
  {uid}/
    songs/
      {songId}
    bands/
      {bandId}
    setlists/
      {setlistId}

bands/
  {bandId}/
    songs/
      {songId}
    setlists/
      {setlistId}
    members/
      {memberId}
```

### Security Rules

The app implements role-based access control:
- **Admins**: Full access to band resources
- **Editors**: Can add/edit songs and setlists
- **Viewers**: Read-only access

See `firestore.rules` for detailed security configuration.

## Testing

Run the test suite:
```bash
flutter test
```

Run with coverage:
```bash
flutter test --coverage
```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Troubleshooting

### Audio not playing
- Ensure device volume is not muted
- Check audio permissions in platform settings
- Try restarting the app

### Firebase connection issues
- Verify internet connection
- Check Firebase console for service status
- Ensure configuration files are correctly placed

### Build errors
- Run `flutter clean` and `flutter pub get`
- For iOS: `cd ios && pod install`
- For Android: Invalidate caches in Android Studio

## Documentation

- [Android Setup Guide](ANDROID_SETUP.md)
- [Changelog](CHANGELOG.md)
- [License](LICENSE)

## Acknowledgments

- Flutter team for the excellent framework
- Riverpod maintainers for state management
- Firebase team for backend services
- All contributors to this project

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
