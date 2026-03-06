# Firebase API Key Configuration

## ⚠️ IMPORTANT: API Key Required

The app requires a Firebase API key to run. The key is **NOT** included in the repository for security reasons.

---

## Development Setup

### Option 1: Command Line Flag (Recommended for Development)

Run the app with the API key as a dart define:

```bash
# Web
flutter run -d chrome \
  --dart-define=FIREBASE_API_KEY=YOUR_ACTUAL_API_KEY_HERE

# Android
flutter run -d <device-id> \
  --dart-define=FIREBASE_API_KEY=YOUR_ACTUAL_API_KEY_HERE

# iOS
flutter run -d <device-id> \
  --dart-define=FIREBASE_API_KEY=YOUR_ACTUAL_API_KEY_HERE
```

### Option 2: Environment Variable

Set the environment variable before running:

```bash
export FIREBASE_API_KEY=YOUR_ACTUAL_API_KEY_HERE
flutter run -d chrome
```

### Option 3: IDE Configuration

#### VS Code
Add to `.vscode/launch.json`:

```json
{
  "configurations": [
    {
      "name": "Metronome",
      "request": "launch",
      "type": "dart",
      "toolArgs": [
        "--dart-define=FIREBASE_API_KEY=YOUR_ACTUAL_API_KEY_HERE"
      ]
    }
  ]
}
```

#### Android Studio / IntelliJ
Add to Run/Debug Configuration:

```
Additional args: --dart-define=FIREBASE_API_KEY=YOUR_ACTUAL_API_KEY_HERE
```

---

## Production Setup

### Android

1. Download `google-services.json` from Firebase Console
2. Place in `android/app/google-services.json`
3. The hardcoded key will be ignored (google-services.json takes precedence)

### iOS

1. Download `GoogleService-Info.plist` from Firebase Console
2. Place in `ios/Runner/GoogleService-Info.plist`
3. The hardcoded key will be ignored (plist takes precedence)

### Web

1. Update `web/index.html` with Firebase config
2. Or use `--dart-define` flag in production build

---

## Getting Your API Key

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: `repsync-app-8685c`
3. Go to **Project Settings** → **General**
4. Under "Your apps", find the API key
5. Copy the key and use it in the commands above

---

## Security Notes

- ✅ **NEVER** commit API keys to git
- ✅ Use `--dart-define` for development
- ✅ Use `google-services.json` / `GoogleService-Info.plist` for production
- ✅ Rotate keys if accidentally exposed

---

## Troubleshooting

### Error: "FirebaseException: No Firebase App"

**Cause**: API key not provided or invalid

**Solution**:
1. Verify API key is correct
2. Ensure `--dart-define` flag is used
3. Check for typos in the key

### Error: "FIREBASE_API_KEY not defined"

**Cause**: Missing dart-define flag

**Solution**:
```bash
flutter run --dart-define=FIREBASE_API_KEY=YOUR_KEY
```

---

## Example Full Command

```bash
# Full example for Android development
flutter run -d XPH0219904001750 \
  --dart-define=FIREBASE_API_KEY=AIzaSyXXXXXXXXXXXXXXXXXXXXXXXXX \
  --flavor development
```

---

**Last Updated**: 2026-03-06  
**Repository**: flutter-flowgroove-app-metronome
