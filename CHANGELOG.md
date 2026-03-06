# Changelog

All notable changes to the RepSync Metronome project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0+1] - 2026-03-06

### Added
- **Core Metronome Features**
  - BPM control with range 10-260 with rotary dial gesture support
  - Time signature support (2/4 through 12/8)
  - Beat mode customization (normal, accent, silent) per beat and subdivision
  - Subdivision support: quarter, eighth, triplet, sixteenth
  - Wave type selection: sine, square, triangle, sawtooth
  - Volume control and tone frequency customization
  - Accent pattern configuration

- **Song Management**
  - Personal song bank with full CRUD operations
  - Song metronome settings (BPM, time signature, beat modes)
  - Song sections (Verse, Chorus, Bridge, etc.)
  - External links (YouTube, Spotify, Apple Music)
  - Tags and notes for organization
  - Key and BPM tracking (original and performance)
  - Song matching fields (Spotify ID, MusicBrainz ID, ISRC)
  - Phonetic matching (Soundex codes for title and artist)

- **Band Collaboration**
  - Band creation with unique invite codes
  - Role-based access control (admin, editor, viewer)
  - Shared band song library
  - Song contribution tracking
  - Member music roles (guitarist, vocalist, drummer, etc.)
  - Band member management

- **Setlist Management**
  - Event setlist creation
  - Event date, time, and location tracking
  - Song assignments with role overrides
  - Duration calculation
  - Participant management

- **Firebase Integration**
  - Firebase Authentication
  - Firestore real-time database
  - Stream-based data synchronization
  - Offline support with local caching
  - Security rules for role-based access

- **State Management**
  - Riverpod 3.x implementation
  - NotifierProvider for metronome state
  - AsyncNotifierProvider for tone configuration
  - StreamProvider for data providers

- **Audio Engine**
  - Cross-platform audio playback
  - Platform-specific implementations (mobile/web)
  - Test tone functionality
  - Metronome sample generation

### Changed
- Migrated to Riverpod 3.x syntax and patterns
- Updated Firebase dependencies to latest versions
- Improved error handling with standardized `ApiError` class
- Enhanced beat mode serialization (map format support)
- Refined time signature handling for 6/8 compound meter

### Fixed
- BPM clamping to prevent invalid values
- Audio engine initialization on first user interaction
- Time signature accent pattern auto-generation
- Beat mode grid initialization for edge cases

### Technical
- **Dependencies**
  - Flutter SDK >=3.11.0 <4.0.0
  - flutter_riverpod: ^3.0.3
  - riverpod_annotation: ^3.0.3
  - go_router: ^17.1.0
  - firebase_core: ^4.5.0
  - firebase_auth: ^6.2.0
  - cloud_firestore: ^6.1.3
  - audioplayers: ^6.4.0
  - shared_preferences: ^2.5.4
  - json_annotation: ^4.9.0
  - flutter_dotenv: ^5.1.0

- **Architecture**
  - Unidirectional data flow with Riverpod
  - Separation of concerns (models, providers, services, screens, widgets)
  - Repository pattern for data access
  - Service layer for business logic

---

## [1.0.0] - Previous Version

### Added
- Initial metronome functionality
- Basic BPM and time signature controls
- Simple audio playback
- Local storage with SharedPreferences

### Notes
- Pre-Firebase integration version
- Limited to single-user functionality
- Basic metronome features only

---

## Version Numbering

This project uses semantic versioning with Flutter build numbers:
- **Major.Minor.Patch+Build** (e.g., 2.0.0+1)
- Major: Breaking changes
- Minor: New features (backward compatible)
- Patch: Bug fixes (backward compatible)
- Build: Flutter-specific build number

## Migration Notes

### Migrating from 1.x to 2.x

1. **Firebase Setup Required**
   - Create Firebase project
   - Enable Authentication and Firestore
   - Update configuration files

2. **Data Migration**
   - Local settings will be migrated to Firestore
   - SharedPreferences data preserved for offline use

3. **Breaking Changes**
   - Riverpod 3.x API changes
   - New data model structures
   - Updated provider patterns

## Release Schedule

- **Major releases**: Quarterly
- **Minor releases**: Monthly
- **Patch releases**: As needed for bug fixes

## Contributing

When contributing changes:
1. Update CHANGELOG.md under the "Unreleased" section
2. Use appropriate categories: Added, Changed, Deprecated, Removed, Fixed, Security
3. Include issue/PR references where applicable

---

*For more information, see [README.md](README.md) and the project documentation.*
