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

### Template Files

Template configuration files are provided in the repository:
- `android/app/google-services.json` (template)
- `ios/Runner/GoogleService-Info.plist` (template)

These templates contain placeholder values and **MUST** be replaced with your actual Firebase configuration.

### Android Production Configuration

**Step 1: Download Configuration from Firebase**
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: `repsync-app-8685c`
3. Go to **Project Settings** → **Your apps**
4. Select the Android app or add a new Android app
5. Download `google-services.json`

**Step 2: Replace Template File**
```bash
# Option A: Copy downloaded file directly
cp ~/Downloads/google-services.json android/app/google-services.json

# Option B: Edit existing template
# Replace "YOUR_API_KEY_HERE" with your actual API key in:
# android/app/google-services.json
```

**Step 3: Verify Configuration**
- Ensure `package_name` matches your app's application ID
- The file should be at: `android/app/google-services.json`

**Step 4: Build Production APK/AAB**
```bash
# Build APK
flutter build apk --release

# Build App Bundle (recommended for Play Store)
flutter build appbundle --release
```

> **Note**: When `google-services.json` is present, the Firebase SDK will use it automatically and ignore the hardcoded API key in `lib/firebase_options.dart`.

### iOS Production Configuration

**Step 1: Download Configuration from Firebase**
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: `repsync-app-8685c`
3. Go to **Project Settings** → **Your apps**
4. Select the iOS app or add a new iOS app
5. Download `GoogleService-Info.plist`

**Step 2: Replace Template File**
```bash
# Option A: Copy downloaded file directly
cp ~/Downloads/GoogleService-Info.plist ios/Runner/GoogleService-Info.plist

# Option B: Edit existing template
# Replace placeholder values in:
# ios/Runner/GoogleService-Info.plist
# - YOUR_API_KEY_HERE
# - YOUR_CLIENT_ID_HERE
```

**Step 3: Add to Xcode (if needed)**
1. Open `ios/Runner.xcworkspace` in Xcode
2. Drag `GoogleService-Info.plist` to the Runner project
3. Ensure it's included in the Runner target

**Step 4: Build Production IPA**
```bash
# Build IPA for distribution
flutter build ipa --release
```

> **Note**: When `GoogleService-Info.plist` is present, the Firebase SDK will use it automatically and ignore the hardcoded API key in `lib/firebase_options.dart`.

### Web Production Configuration

**Option 1: Update web/index.html**
1. Add Firebase config script to `web/index.html`
2. Replace placeholder values with your actual Firebase config

**Option 2: Use dart-define in Production Build**
```bash
flutter build web --dart-define=FIREBASE_API_KEY=YOUR_ACTUAL_API_KEY_HERE
```

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
- ✅ Template files contain `YOUR_API_KEY_HERE` placeholders - replace with actual values
- ✅ Add actual config files to `.gitignore` if using shared repository

### Security Best Practices

1. **Template Files**: The included `google-services.json` and `GoogleService-Info.plist` are templates with placeholder values
2. **Production Keys**: Replace templates with actual Firebase config files downloaded from Firebase Console
3. **Git Safety**: If sharing your repository, add these lines to `.gitignore`:
   ```
   android/app/google-services.json
   ios/Runner/GoogleService-Info.plist
   ```
4. **CI/CD**: Store actual config files as secrets in your CI/CD pipeline

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
