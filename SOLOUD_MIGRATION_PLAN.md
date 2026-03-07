# 🔊 flutter_soloud Migration Plan

## 📋 Executive Summary

**Current State**: Using `audioplayers 6.4.0` with MediaPlayer (Android)  
**Problem**: 500ms latency on first beat due to MediaPlayer initialization  
**Solution**: Migrate to `flutter_soloud` - Google's recommended low-latency audio package

---

## 🎯 Why flutter_soloud?

### Advantages Over audioplayers

| Feature | audioplayers | flutter_soloud | Improvement |
|---------|--------------|----------------|-------------|
| **Latency** | 100-500ms | **<10ms** | **50x faster** |
| **Backend** | MediaPlayer/AVPlayer | **SoLoud (C++)** | Native performance |
| **Voice Pool** | 4 players | **Unlimited** | No player management |
| **3D Audio** | ❌ No | ✅ Yes | Future features |
| **DSP Effects** | ❌ No | ✅ Yes (reverb, filter, etc.) | Enhanced UX |
| **Live Mixing** | ❌ No | ✅ Yes | Dynamic sound generation |
| **Google Recommended** | ❌ No | ✅ **Yes** | Official support |

### Google's Official Codelab
- **Title**: "Build a low-latency audio app with Flutter"
- **Package**: flutter_soloud
- **Based on**: SoLoud C++ library (battle-tested, used in games)
- **Platform Support**: Android, iOS, Windows, macOS, Linux, Web

---

## 📦 Installation

### pubspec.yaml
```yaml
dependencies:
  flutter_soloud: ^2.1.0  # Latest version
  
dev_dependencies:
  flutter_test:
    sdk: flutter
```

### Platform-Specific Setup

#### Android (No Changes Required)
flutter_soloud works out-of-the-box on Android.

#### iOS (Minimum Version Update)
```ruby
# ios/Podfile
platform :ios, '13.0'  # Update from 12.0
```

---

## 🔄 Migration Strategy

### Phase 1: Audio Engine Rewrite (4-6 hours)

#### Current Architecture (audioplayers)
```
AudioEngine (mobile)
├── Player Pool (4 players)
├── Pre-generated Buffers (24 samples)
└── playClick() → BytesSource → AudioPlayer.play()
```

#### New Architecture (flutter_soloud)
```
AudioEngine (soloud)
├── SoLoud Instance (singleton)
├── Sound Bank (24 pre-loaded sounds)
└── playClick() → soloud.play() → Instant (<10ms)
```

### Phase 2: Implementation Steps

#### Step 1: Create New Audio Engine Interface
**File**: `lib/services/audio/i_audio_engine.dart`

```dart
abstract class IAudioEngine {
  bool get initialized;
  Future<void> initialize();
  Future<void> playClick({
    required bool isAccent,
    required String waveType,
    required double volume,
    double? accentFrequency,
    double? beatFrequency,
  });
  Future<void> playTest();
  void dispose();
}
```

#### Step 2: Implement flutter_soloud Engine
**File**: `lib/services/audio/audio_engine_soloud.dart`

```dart
import 'package:flutter_soloud/flutter_soloud.dart';

class AudioEngineSoloud implements IAudioEngine {
  final SoLoud _soloud = SoLoud.instance;
  final Map<String, SoundHandle> _soundHandles = {};
  bool _initialized = false;

  @override
  bool get initialized => _initialized;

  @override
  Future<void> initialize() async {
    if (_initialized) return;

    // Initialize SoLoud
    await _soloud.init();
    
    // Pre-load all 24 sounds into memory
    await _preloadAllSounds();
    
    _initialized = true;
    debugPrint('[AudioEngineSoloud] Initialized with ${_soundHandles.length} sounds');
  }

  Future<void> _preloadAllSounds() async {
    const frequencies = [800.0, 880.0, 1600.0, 1760.0, 2000.0, 2200.0];
    const waveTypes = ['sine', 'square', 'triangle', 'sawtooth'];

    for (final freq in frequencies) {
      for (final wave in waveTypes) {
        final key = '${freq}_$wave';
        
        // Generate sound programmatically with SoLoud
        final handle = await _generateSound(freq, wave);
        _soundHandles[key] = handle;
      }
    }
  }

  Future<SoundHandle> _generateSound(double frequency, String waveType) async {
    // Create sound source based on wave type
    final source = switch (waveType) {
      'sine' => SoloudSynth.createOscillator(oscillatorType: OscillatorType.SINE),
      'square' => SoloudSynth.createOscillator(oscillatorType: OscillatorType.SQUARE),
      'triangle' => SoloudSynth.createOscillator(oscillatorType: OscillatorType.TRIANGLE),
      'sawtooth' => SoloudSynth.createOscillator(oscillatorType: OscillatorType.SAW),
      _ => throw ArgumentError('Unknown wave type: $waveType'),
    };

    // Set frequency
    source.setFrequency(frequency);
    
    // Create envelope (ADSR) for click sound (40ms decay)
    source.setEnvelope(
      envelope: Envelope(
        attack: 0.001,    // 1ms attack
        decay: 0.04,      // 40ms decay (like Reaper)
        sustain: 0.0,     // No sustain
        release: 0.001,   // 1ms release
      ),
    );

    // Load into SoLoud and get handle
    final handle = await _soloud.loadSound(source);
    return handle;
  }

  @override
  Future<void> playClick({
    required bool isAccent,
    required String waveType,
    required double volume,
    double? accentFrequency,
    double? beatFrequency,
  }) async {
    if (!_initialized) await initialize();

    final frequency = isAccent
        ? (accentFrequency ?? 1600.0)
        : (beatFrequency ?? 800.0);

    final key = '${frequency}_$waveType';
    final handle = _soundHandles[key];

    if (handle == null) {
      debugPrint('[AudioEngineSoloud] Sound not found: $key');
      return;
    }

    // Play with <10ms latency
    await _soloud.play(handle, volume: volume);
  }

  @override
  Future<void> playTest() async {
    await playClick(
      isAccent: true,
      waveType: 'sine',
      volume: 0.5,
    );
  }

  @override
  Future<void> dispose() async {
    // Unload all sounds
    for (final handle in _soundHandles.values) {
      await _soloud.unloadSound(handle);
    }
    _soundHandles.clear();
    
    // Deinitialize SoLoud
    await _soloud.deinit();
    _initialized = false;
  }
}
```

#### Step 3: Update main.dart
**File**: `lib/main.dart`

```dart
import 'services/audio/audio_engine_soloud.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Pre-initialize Soloud audio engine
  final audioEngine = AudioEngineSoloud();
  await audioEngine.initialize();

  // Share with metronomeProvider
  MetronomeNotifier.setAudioEngineFactory(() => audioEngine);

  runApp(const ProviderScope(child: MetronomeApp()));
}
```

#### Step 4: Update metronome_provider.dart
**File**: `lib/providers/metronome_provider.dart`

```dart
// No changes needed - uses IAudioEngine interface
// Just import the new implementation in main.dart
```

#### Step 5: Remove Old Audio Engine Files
```bash
# Delete these files
rm lib/services/audio/audio_engine_mobile.dart
rm lib/services/audio/audio_engine_web.dart  # Create new web version
rm lib/services/audio/audio_player_adapter.dart
```

---

## 📊 Expected Performance Improvements

### Latency Comparison

| Scenario | audioplayers | flutter_soloud | Improvement |
|----------|--------------|----------------|-------------|
| **Cold Start (1st beat)** | 350-700ms | **<10ms** | **35-70x faster** |
| **Warm (subsequent)** | 50-100ms | **<10ms** | **5-10x faster** |
| **Pre-warm overhead** | 200-400ms | **<50ms** | **4-8x faster** |

### Memory Usage

| Metric | audioplayers | flutter_soloud | Notes |
|--------|--------------|----------------|-------|
| **App Size** | +2.5MB | +3.5MB | SoLoud library |
| **RAM (idle)** | ~10MB | ~15MB | Sound bank in memory |
| **RAM (playing)** | ~25MB | ~20MB | More efficient mixing |

---

## ⚠️ Breaking Changes & Considerations

### 1. Web Support
- **Current**: `audio_engine_web.dart` uses Web Audio API
- **Soloud**: WebAssembly-based, different API
- **Action**: Need to create separate web implementation OR use conditional imports

### 2. Sound Generation
- **Current**: Pre-generated PCM buffers (WAV format)
- **Soloud**: Programmatic synthesis (oscillators)
- **Action**: Rewrite sound generation logic (see Step 2)

### 3. Testing
- **Current**: 55 audio engine tests
- **Soloud**: Need new tests for Soloud API
- **Action**: Rewrite test suite

---

## 🧪 Testing Strategy

### Unit Tests
```dart
// test/services/audio/audio_engine_soloud_test.dart
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AudioEngineSoloud', () {
    test('initializes successfully', () async {
      final engine = AudioEngineSoloud();
      await engine.initialize();
      expect(engine.initialized, isTrue);
    });

    test('plays click with <10ms latency', () async {
      final engine = AudioEngineSoloud();
      await engine.initialize();
      
      final start = DateTime.now().millisecondsSinceEpoch;
      await engine.playClick(
        isAccent: true,
        waveType: 'sine',
        volume: 0.5,
      );
      final end = DateTime.now().millisecondsSinceEpoch;
      
      expect(end - start, lessThan(10));
    });
  });
}
```

### Integration Tests
```dart
// test/integration/metronome_audio_test.dart
void main() {
  testWidgets('Metronome starts with <10ms latency', (tester) async {
    await tester.pumpWidget(
      ProviderScope(child: MetronomeApp()),
    );

    final start = DateTime.now().millisecondsSinceEpoch;
    
    // Tap start button
    await tester.tap(find.byIcon(Icons.play_arrow));
    await tester.pump();
    
    // Verify first beat played within 10ms
    final end = DateTime.now().millisecondsSinceEpoch;
    expect(end - start, lessThan(10));
  });
}
```

---

## 📅 Migration Timeline

| Phase | Task | Estimated Time |
|-------|------|----------------|
| **1** | Research & planning | 1 hour |
| **2** | Implement AudioEngineSoloud | 3-4 hours |
| **3** | Update main.dart & providers | 1 hour |
| **4** | Remove old audio engine files | 30 min |
| **5** | Write unit tests | 2-3 hours |
| **6** | Integration testing | 2 hours |
| **7** | Performance profiling | 1 hour |
| **8** | Bug fixes & optimization | 2-3 hours |
| **TOTAL** | | **12-15 hours** |

---

## 🎯 Success Criteria

- [ ] First beat latency <10ms (currently ~500ms)
- [ ] All 24 frequency/wave combinations work
- [ ] Vibration sync maintained
- [ ] All existing tests pass (or rewritten)
- [ ] No regressions in other features
- [ ] App size increase <2MB
- [ ] RAM usage <100MB

---

## 🚀 Post-Migration Enhancements

Once migrated, we can add:

1. **Real-time frequency changes** (no buffer regeneration needed)
2. **Audio effects** (reverb, chorus, filter)
3. **3D spatial audio** (for immersive metronome experience)
4. **Live waveform visualization** (Soloud provides FFT data)
5. **Recording capability** (export metronome patterns)

---

## 📚 Resources

- **flutter_soloud Pub**: https://pub.dev/packages/flutter_soloud
- **SoLoud Documentation**: https://soloud-audio.com/
- **Google Codelab**: https://codelabs.developers.google.com/codelabs/flutter-low-latency-audio
- **GitHub Examples**: https://github.com/Flutter-Bounty-Hunters/flutter_soloud

---

**Ready to proceed with migration?**
