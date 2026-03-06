# Metronome App Improvements - Fix "Floating" Tick/Tack

## Problem Analysis

The "floating" or inconsistent timing you're experiencing is a common issue in metronome apps. Here's what causes it:

### Root Causes

1. **Timer Drift**: Dart's `Timer.periodic()` isn't precise enough for audio timing
   - JavaScript/Dart timers can drift by 10-50ms
   - Accumulates over time, causing noticeable rhythm issues

2. **Audio Latency**: Generating sounds on-demand introduces variable delays
   - Each click is synthesized when needed
   - CPU load affects synthesis time

3. **No Lookahead**: Events are scheduled too close to playback time
   - No buffer for processing delays
   - Any lag directly affects timing

## Solution: Professional Metronome Architecture

### Recommended Approach

The industry-standard solution is the **"Tale of Two Clocks"** pattern used by professional web metronomes:

```
┌─────────────────────────────────────────┐
│  Scheduler Thread (Dart Timer)          │
│  - Runs every 25ms                      │
│  - Looks 100ms into the future          │
│  - Schedules audio events precisely     │
└─────────────────────────────────────────┘
              ↓
┌─────────────────────────────────────────┐
│  Audio Thread (Web Audio API / AudioTrack) │
│  - Hardware-timed playback              │
│  - Sample-accurate timing (±1ms)        │
│  - Independent from JavaScript/Dart     │
└─────────────────────────────────────────┘
```

### Implementation Plan

#### For Web (Priority - Best Results)

Use **Web Audio API** with lookahead scheduling:

```dart
// Key concepts:
// 1. Pre-generate audio buffers (no on-the-fly synthesis)
// 2. Schedule notes 100ms in advance
// 3. Use audioContext.currentTime for precise timing

class AudioEngine {
  web.AudioContext? _audioContext;
  final Map<String, web.AudioBuffer> _buffers = {};
  
  // Lookahead scheduler
  static const double _lookahead = 0.1; // 100ms
  static const double _scheduleInterval = 0.025; // 25ms
  
  void startScheduler({required double bpm, ...}) {
    // Schedule notes in advance using hardware timing
    Timer.periodic(25ms, (timer) {
      while (nextNoteTime < audioContext.currentTime + lookahead) {
        scheduleNote(nextNoteTime);
        advanceBeat();
      }
    });
  }
  
  void scheduleNote(double time) {
    // Schedule sound to play at exact time
    final source = audioContext.createBufferSource();
    source.buffer = _buffers['click'];
    source.start(time); // Precise hardware timing!
  }
}
```

**Benefits**:
- Sample-accurate timing (±1ms)
- No drift even after hours of playback
- Works in background tabs

#### For Mobile (iOS/Android)

Use **just_audio** with pre-loaded buffers:

```dart
// Key concepts:
// 1. Pre-generate PCM click sounds
// 2. Use player pool for overlapping clicks
// 3. Minimize synthesis during playback

class AudioEngine {
  final List<AudioPlayer> _players = [];
  final Map<String, Uint8List> _buffers = {};
  
  Future<void> initialize() async {
    // Create player pool
    for (int i = 0; i < 4; i++) {
      _players.add(await AudioPlayer());
    }
    
    // Pre-generate all sounds
    _buffers['click_accent'] = generateClick(1600 Hz);
    _buffers['click_normal'] = generateClick(800 Hz);
  }
  
  Future<void> playClick() async {
    // Use next available player from pool
    final player = _players[_currentIndex];
    await player.play(BytesSource(_buffers['click']));
    _currentIndex = (_currentIndex + 1) % 4;
  }
}
```

**Benefits**:
- Consistent timing (±5-10ms)
- No on-the-fly synthesis
- Handles rapid successive clicks

### Code Changes Required

#### 1. Update `audio_engine_web.dart`

```dart
// Add lookahead scheduler
// Pre-generate audio buffers
// Use audioContext.currentTime for scheduling
```

#### 2. Update `audio_engine_mobile.dart`

```dart
// Add player pool (4 players)
// Pre-generate PCM buffers
// Use just_audio with ByteArrayAudioSource
```

#### 3. Update `metronome_provider.dart`

```dart
// Platform-aware scheduling
if (kIsWeb) {
  _audioEngine.startScheduler(...); // Web: Use scheduler
} else {
  _startTimer(); // Mobile: Use timer with pre-loaded sounds
}
```

### Expected Results

| Platform | Current | After Fix |
|----------|---------|-----------|
| Web | ±50ms drift | ±1ms (sample-accurate) |
| Mobile | ±30ms drift | ±5-10ms |

### Additional Improvements

#### 1. Visual Metronome Sync

Sync visual beats with audio precisely:

```dart
_audioEngine.startScheduler(
  onBeat: (beatIndex) {
    // Update UI at precise time
    setState(() => _currentBeat = beatIndex);
  },
);
```

#### 2. Audio Latency Compensation

Add user-adjustable latency compensation:

```dart
// In settings
double audioLatencyMs = 20.0; // User-adjustable

// In scheduler
scheduleNote(time - (audioLatencyMs / 1000));
```

#### 3. Background Audio

Ensure metronome continues in background:

```dart
final session = await AudioSession.instance;
await session.configure(AudioSessionConfiguration(
  avAudioSessionCategory: AVAudioSessionCategoryPlayback,
  // ...
));
```

#### 4. Tap Tempo Smoothing

Improve tap tempo by averaging multiple taps:

```dart
final List<Duration> _tapIntervals = [];

void onTap() {
  _tapIntervals.add(now - lastTap);
  if (_tapIntervals.length > 4) _tapIntervals.removeAt(0);
  
  // Use median to reject outliers
  final bpm = calculateBpmFromMedian(_tapIntervals);
}
```

## Testing Checklist

- [ ] **Web**: Test at extreme BPMs (40, 220, 300)
- [ ] **Mobile**: Test on both iOS and Android
- [ ] **Drift Test**: Run for 10+ minutes, check for drift
- [ ] **Background**: Test with app in background
- [ ] **Stress Test**: Rapid BPM changes while playing

## Resources

- ["A Tale of Two Clocks" - Google I/O](https://www.html5rocks.com/en/tutorials/audio/scheduling/)
- [Web Audio API Scheduling](https://developer.mozilla.org/en-US/docs/Web/API/Web_Audio_API/Advanced_techniques#precise_scheduling)
- [just_audio package](https://pub.dev/packages/just_audio)

## Next Steps

1. **Start with Web** - Easiest to implement, best results
2. **Test thoroughly** - Verify timing improvements
3. **Mobile implementation** - Adapt for iOS/Android
4. **Add visual sync** - Match UI to audio precisely
5. **User settings** - Latency compensation, etc.

Would you like me to implement any of these improvements? I recommend starting with the **Web Audio API lookahead scheduler** as it provides the biggest improvement with manageable code changes.
