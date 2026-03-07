# App Icon Setup Instructions

## Current Status
- SVG icon available at: `assets/metronome_icon.svg`
- PNG conversion needed for app icons

## Manual Setup (Required)

### Option 1: Use Online Converter
1. Go to https://cloudconvert.com/svg-to-png
2. Upload `assets/metronome_icon.svg`
3. Set dimensions to 1024x1024
4. Download and save as `assets/metronome_icon.png`
5. Run: `dart run flutter_launcher_icons`

### Option 2: Use macOS Preview
1. Open `assets/metronome_icon.svg` in Preview
2. File → Export
3. Format: PNG
4. Resolution: 1024x1024
5. Save as `assets/metronome_icon.png`
6. Run: `dart run flutter_launcher_icons`

### Option 3: Use Inkscape (if installed)
```bash
inkscape --export-type=png --export-width=1024 --export-height=1024 assets/metronome_icon.svg -o assets/metronome_icon.png
dart run flutter_launcher_icons
```

## After Generating PNG

Run the flutter_launcher_icons tool:
```bash
dart run flutter_launcher_icons
```

This will generate icons for:
- ✅ Android (all densities)
- ✅ iOS (all sizes)
- ✅ Web (favicon, PWA icons)
- ✅ Windows
- ✅ macOS
- ✅ Linux

## Configuration

Icon configuration is in `pubspec.yaml`:
```yaml
flutter_launcher_icons:
  image_path: "assets/metronome_icon.png"
  android: true
  ios: true
  web:
    generate: true
    background_color: "#000000"
    theme_color: "#FF5E00"
  # ... etc
```

## Icon Design
- **Colors**: Orange (#FF5E00) on Black (#000000)
- **Design**: Metronome arm with vertical base
- **Size**: 1024x1024px (source)
