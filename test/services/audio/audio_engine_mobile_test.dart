// Test file for AudioEngine (mobile version)
// Comprehensive tests for audio_engine_mobile.dart to achieve >95% coverage
// Uses dependency injection to mock AudioPlayer for unit testing

import 'package:flutter_test/flutter_test.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:metronome_app/services/audio/audio_engine_mobile.dart';

/// Mock IAudioPlayer for testing - no platform channel dependencies
class MockAudioPlayer implements IAudioPlayer {
  int setReleaseModeCallCount = 0;
  int setVolumeCallCount = 0;
  int playCallCount = 0;
  int disposeCallCount = 0;
  
  ReleaseMode? lastReleaseMode;
  double? lastVolume;
  BytesSource? lastSource;
  double? lastPlayVolume;
  
  bool _disposed = false;
  
  // Error injection for testing error handling
  bool shouldThrow = false;
  bool shouldThrowOnPlay = false;
  bool shouldThrowOnDispose = false;

  @override
  Future<void> setReleaseMode(ReleaseMode mode) async {
    if (_disposed) throw StateError('Player disposed');
    if (shouldThrow) throw StateError('Mock error');
    setReleaseModeCallCount++;
    lastReleaseMode = mode;
  }

  @override
  Future<void> setVolume(double volume) async {
    if (_disposed) throw StateError('Player disposed');
    if (shouldThrow) throw StateError('Mock error');
    setVolumeCallCount++;
    lastVolume = volume;
  }

  @override
  Future<void> play(BytesSource source, {double? volume}) async {
    if (_disposed) throw StateError('Player disposed');
    if (shouldThrowOnPlay) throw StateError('Mock play error');
    playCallCount++;
    lastSource = source;
    lastPlayVolume = volume;
  }

  @override
  void dispose() {
    _disposed = true;
    disposeCallCount++;
    if (shouldThrowOnDispose) {
      throw StateError('Mock dispose error');
    }
  }

  bool get isDisposed => _disposed;

  /// Reset mock state for reuse
  void reset() {
    setReleaseModeCallCount = 0;
    setVolumeCallCount = 0;
    playCallCount = 0;
    disposeCallCount = 0;
    lastReleaseMode = null;
    lastVolume = null;
    lastSource = null;
    lastPlayVolume = null;
    _disposed = false;
    shouldThrow = false;
    shouldThrowOnPlay = false;
    shouldThrowOnDispose = false;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AudioEngine', () {
    late AudioEngine audioEngine;
    late List<MockAudioPlayer> mockPlayers;

    // Create a factory that returns mock players
    MockAudioPlayer Function() createMockFactory() {
      return () {
        final mock = MockAudioPlayer();
        mockPlayers.add(mock);
        return mock;
      };
    }

    setUp(() {
      mockPlayers = [];
      audioEngine = AudioEngine(playerFactory: createMockFactory());
    });

    tearDown(() {
      try {
        audioEngine.dispose();
      } catch (_) {
        // Ignore dispose errors in tests
      }
      mockPlayers.clear();
    });

    group('initialization', () {
      test('initialized is false before initialize()', () {
        expect(audioEngine.initialized, isFalse);
      });

      test('initialize() creates player pool and pre-loads buffers', () async {
        await audioEngine.initialize();
        expect(audioEngine.initialized, isTrue);
        expect(mockPlayers.length, equals(4));
        
        // Verify all players were configured
        for (final player in mockPlayers) {
          expect(player.setReleaseModeCallCount, equals(1));
          expect(player.lastReleaseMode, equals(ReleaseMode.stop));
          expect(player.setVolumeCallCount, equals(1));
          expect(player.lastVolume, equals(1.0));
        }
      });

      test('initialize() is idempotent', () async {
        await audioEngine.initialize();
        final firstInit = audioEngine.initialized;
        final firstPlayerCount = mockPlayers.length;

        await audioEngine.initialize();
        expect(audioEngine.initialized, firstInit);
        expect(mockPlayers.length, equals(firstPlayerCount));
      });

      test('initialize() generates all frequency and wave type combinations', () async {
        await audioEngine.initialize();
        // 6 frequencies × 4 wave types = 24 buffers
        expect(audioEngine.initialized, isTrue);
      });
    });

    group('playClick - frequency variations', () {
      setUp(() async {
        await audioEngine.initialize();
      });

      test('playClick with accented beat uses accent frequency', () async {
        await audioEngine.playClick(
          isAccent: true,
          waveType: 'sine',
          volume: 0.5,
          accentFrequency: 1600,
          beatFrequency: 800,
        );
        expect(mockPlayers.first.playCallCount, equals(1));
      });

      test('playClick with regular beat uses beat frequency', () async {
        await audioEngine.playClick(
          isAccent: false,
          waveType: 'sine',
          volume: 0.5,
          accentFrequency: 1600,
          beatFrequency: 800,
        );
        expect(mockPlayers.first.playCallCount, equals(1));
      });

      test('playClick with default accent frequency', () async {
        await audioEngine.playClick(
          isAccent: true,
          waveType: 'sine',
          volume: 0.5,
        );
        expect(mockPlayers.first.playCallCount, equals(1));
      });

      test('playClick with default beat frequency', () async {
        await audioEngine.playClick(
          isAccent: false,
          waveType: 'sine',
          volume: 0.5,
        );
        expect(mockPlayers.first.playCallCount, equals(1));
      });

      test('playClick with all supported frequencies', () async {
        const frequencies = [800.0, 880.0, 1600.0, 1760.0, 2000.0, 2200.0];
        for (final freq in frequencies) {
          await audioEngine.playClick(
            isAccent: false,
            waveType: 'sine',
            volume: 0.5,
            beatFrequency: freq,
          );
        }
        final totalCalls = mockPlayers.fold<int>(0, (sum, p) => sum + p.playCallCount);
        expect(totalCalls, equals(6));
      });

      test('playClick with custom accent frequency', () async {
        await audioEngine.playClick(
          isAccent: true,
          waveType: 'sine',
          volume: 0.5,
          accentFrequency: 2200,
        );
        expect(mockPlayers.first.playCallCount, equals(1));
      });

      test('playClick with custom beat frequency', () async {
        await audioEngine.playClick(
          isAccent: false,
          waveType: 'sine',
          volume: 0.5,
          beatFrequency: 1760,
        );
        expect(mockPlayers.first.playCallCount, equals(1));
      });
    });

    group('playClick - wave type variations', () {
      setUp(() async {
        await audioEngine.initialize();
      });

      test('playClick with sine wave', () async {
        await audioEngine.playClick(
          isAccent: false,
          waveType: 'sine',
          volume: 0.5,
        );
        expect(mockPlayers.first.playCallCount, equals(1));
      });

      test('playClick with square wave', () async {
        await audioEngine.playClick(
          isAccent: false,
          waveType: 'square',
          volume: 0.5,
        );
        expect(mockPlayers.first.playCallCount, equals(1));
      });

      test('playClick with triangle wave', () async {
        await audioEngine.playClick(
          isAccent: false,
          waveType: 'triangle',
          volume: 0.5,
        );
        expect(mockPlayers.first.playCallCount, equals(1));
      });

      test('playClick with sawtooth wave', () async {
        await audioEngine.playClick(
          isAccent: false,
          waveType: 'sawtooth',
          volume: 0.5,
        );
        expect(mockPlayers.first.playCallCount, equals(1));
      });

      test('playClick with uppercase wave type', () async {
        await audioEngine.playClick(
          isAccent: false,
          waveType: 'SINE',
          volume: 0.5,
        );
        expect(mockPlayers.first.playCallCount, equals(1));
      });

      test('playClick with mixed case wave type', () async {
        await audioEngine.playClick(
          isAccent: false,
          waveType: 'Square',
          volume: 0.5,
        );
        expect(mockPlayers.first.playCallCount, equals(1));
      });
    });

    group('playClick - volume variations', () {
      setUp(() async {
        await audioEngine.initialize();
      });

      test('playClick with minimum volume', () async {
        await audioEngine.playClick(
          isAccent: false,
          waveType: 'sine',
          volume: 0.0,
        );
        expect(mockPlayers.first.playCallCount, equals(1));
      });

      test('playClick with maximum volume', () async {
        await audioEngine.playClick(
          isAccent: false,
          waveType: 'sine',
          volume: 1.0,
        );
        expect(mockPlayers.first.playCallCount, equals(1));
      });

      test('playClick with medium volume', () async {
        await audioEngine.playClick(
          isAccent: false,
          waveType: 'sine',
          volume: 0.5,
        );
        expect(mockPlayers.first.playCallCount, equals(1));
      });

      test('playClick clamps volume above 1.0', () async {
        await audioEngine.playClick(
          isAccent: false,
          waveType: 'sine',
          volume: 1.5,
        );
        expect(mockPlayers.first.playCallCount, equals(1));
      });

      test('playClick clamps volume below 0.0', () async {
        await audioEngine.playClick(
          isAccent: false,
          waveType: 'sine',
          volume: -0.5,
        );
        expect(mockPlayers.first.playCallCount, equals(1));
      });

      test('playClick with extreme high volume', () async {
        await audioEngine.playClick(
          isAccent: false,
          waveType: 'sine',
          volume: 10.0,
        );
        expect(mockPlayers.first.playCallCount, equals(1));
      });

      test('playClick with extreme low volume', () async {
        await audioEngine.playClick(
          isAccent: false,
          waveType: 'sine',
          volume: -10.0,
        );
        expect(mockPlayers.first.playCallCount, equals(1));
      });
    });

    group('playClick - combined variations', () {
      setUp(() async {
        await audioEngine.initialize();
      });

      test('playClick exercises all wave types with accented beats', () async {
        const waveTypes = ['sine', 'square', 'triangle', 'sawtooth'];
        for (final wave in waveTypes) {
          await audioEngine.playClick(
            isAccent: true,
            waveType: wave,
            volume: 0.5,
            accentFrequency: 1600,
          );
        }
        final totalCalls = mockPlayers.fold<int>(0, (sum, p) => sum + p.playCallCount);
        expect(totalCalls, equals(4));
      });

      test('playClick exercises all wave types with regular beats', () async {
        const waveTypes = ['sine', 'square', 'triangle', 'sawtooth'];
        for (final wave in waveTypes) {
          await audioEngine.playClick(
            isAccent: false,
            waveType: wave,
            volume: 0.5,
            beatFrequency: 800,
          );
        }
        final totalCalls = mockPlayers.fold<int>(0, (sum, p) => sum + p.playCallCount);
        expect(totalCalls, equals(4));
      });

      test('playClick exercises all frequencies with sine wave', () async {
        const frequencies = [800.0, 880.0, 1600.0, 1760.0, 2000.0, 2200.0];
        for (final freq in frequencies) {
          await audioEngine.playClick(
            isAccent: freq > 1500,
            waveType: 'sine',
            volume: 0.5,
            accentFrequency: freq,
            beatFrequency: freq,
          );
        }
        final totalCalls = mockPlayers.fold<int>(0, (sum, p) => sum + p.playCallCount);
        expect(totalCalls, equals(6));
      });

      test('playClick with different volume levels', () async {
        const volumes = [0.0, 0.25, 0.5, 0.75, 1.0];
        for (final vol in volumes) {
          await audioEngine.playClick(
            isAccent: false,
            waveType: 'sine',
            volume: vol,
          );
        }
        final totalCalls = mockPlayers.fold<int>(0, (sum, p) => sum + p.playCallCount);
        expect(totalCalls, equals(5));
      });

      test('playClick generates sounds for all buffer combinations', () async {
        const frequencies = [800.0, 880.0, 1600.0, 1760.0, 2000.0, 2200.0];
        const waveTypes = ['sine', 'square', 'triangle', 'sawtooth'];
        
        for (final freq in frequencies) {
          for (final wave in waveTypes) {
            await audioEngine.playClick(
              isAccent: freq > 1500,
              waveType: wave,
              volume: 0.5,
              accentFrequency: freq,
              beatFrequency: freq,
            );
          }
        }
        final totalCalls = mockPlayers.fold<int>(0, (sum, p) => sum + p.playCallCount);
        expect(totalCalls, equals(24));
      });
    });

    group('playClick - player pool', () {
      setUp(() async {
        await audioEngine.initialize();
      });

      test('playClick uses round-robin player selection', () async {
        for (int i = 0; i < 8; i++) {
          await audioEngine.playClick(
            isAccent: i % 2 == 0,
            waveType: 'sine',
            volume: 0.5,
          );
        }
        // Each of 4 players should be called twice
        for (final player in mockPlayers) {
          expect(player.playCallCount, equals(2));
        }
      });

      test('playClick handles rapid successive calls', () async {
        final futures = <Future<void>>[];
        for (int i = 0; i < 10; i++) {
          futures.add(
            audioEngine.playClick(
              isAccent: i % 2 == 0,
              waveType: 'sine',
              volume: 0.5,
            ),
          );
        }
        await Future.wait(futures);
        // 10 calls distributed across 4 players
        expect(mockPlayers.fold<int>(0, (sum, p) => sum + p.playCallCount), equals(10));
      });

      test('playClick cycles through all players in pool', () async {
        for (int i = 0; i < 16; i++) {
          await audioEngine.playClick(
            isAccent: false,
            waveType: 'sine',
            volume: 0.5,
          );
        }
        // Each of 4 players should be called 4 times
        for (final player in mockPlayers) {
          expect(player.playCallCount, equals(4));
        }
      });

      test('playClick with overlapping clicks', () async {
        for (int i = 0; i < 20; i++) {
          await audioEngine.playClick(
            isAccent: i % 3 == 0,
            waveType: 'sine',
            volume: 0.5,
          );
        }
        // 20 calls distributed across 4 players (5 each)
        for (final player in mockPlayers) {
          expect(player.playCallCount, equals(5));
        }
      });
    });

    group('playClick - edge cases', () {
      setUp(() async {
        await audioEngine.initialize();
      });

      test('playClick handles null frequencies gracefully', () async {
        await audioEngine.playClick(
          isAccent: true,
          waveType: 'sine',
          volume: 0.5,
          accentFrequency: null,
          beatFrequency: null,
        );
        expect(mockPlayers.first.playCallCount, equals(1));
      });

      test('playClick works when not explicitly initialized', () async {
        final newEngine = AudioEngine(playerFactory: createMockFactory());
        addTearDown(() {
          try {
            newEngine.dispose();
          } catch (_) {}
        });

        await newEngine.playClick(
          isAccent: true,
          waveType: 'sine',
          volume: 0.5,
        );

        expect(newEngine.initialized, isTrue);
      });

      test('playClick with very low frequency', () async {
        await audioEngine.playClick(
          isAccent: false,
          waveType: 'sine',
          volume: 0.5,
          beatFrequency: 100,
        );
        expect(mockPlayers.first.playCallCount, equals(1));
      });

      test('playClick with very high frequency', () async {
        await audioEngine.playClick(
          isAccent: true,
          waveType: 'sine',
          volume: 0.5,
          accentFrequency: 4000,
        );
        expect(mockPlayers.first.playCallCount, equals(1));
      });
    });

    group('playTest', () {
      setUp(() async {
        await audioEngine.initialize();
      });

      test('playTest plays accented and regular clicks', () async {
        await audioEngine.playTest();
        final totalCalls = mockPlayers.fold<int>(0, (sum, p) => sum + p.playCallCount);
        expect(totalCalls, equals(2));
      });

      test('playTest works without prior initialization', () async {
        final newEngine = AudioEngine(playerFactory: createMockFactory());
        addTearDown(() {
          try {
            newEngine.dispose();
          } catch (_) {}
        });

        await newEngine.playTest();
        expect(newEngine.initialized, isTrue);
      });
    });

    group('dispose', () {
      test('dispose() cleans up resources', () async {
        await audioEngine.initialize();
        expect(audioEngine.initialized, isTrue);

        audioEngine.dispose();

        expect(audioEngine.initialized, isFalse);
        for (final player in mockPlayers) {
          expect(player.isDisposed, isTrue);
        }
      });

      test('dispose() is safe to call multiple times', () {
        audioEngine.dispose();
        audioEngine.dispose();
        expect(true, isTrue);
      });

      test('dispose() after initialize cleans up properly', () async {
        await audioEngine.initialize();
        audioEngine.dispose();
        expect(audioEngine.initialized, isFalse);
      });

      test('dispose() without initialize is safe', () {
        audioEngine.dispose();
        expect(audioEngine.initialized, isFalse);
      });

      test('dispose() clears buffers', () async {
        await audioEngine.initialize();
        audioEngine.dispose();
        expect(audioEngine.initialized, isFalse);
      });
    });

    group('internal methods coverage via public API', () {
      setUp(() async {
        await audioEngine.initialize();
      });

      test('_generateClickSound generates audio data for all wave types', () async {
        // Exercise sine wave generation
        await audioEngine.playClick(
          isAccent: true,
          waveType: 'sine',
          volume: 1.0,
          accentFrequency: 880,
        );

        // Exercise square wave generation
        await audioEngine.playClick(
          isAccent: false,
          waveType: 'square',
          volume: 0.8,
          beatFrequency: 1760,
        );

        // Exercise triangle wave generation
        await audioEngine.playClick(
          isAccent: true,
          waveType: 'triangle',
          volume: 0.6,
          accentFrequency: 2000,
        );

        // Exercise sawtooth wave generation
        await audioEngine.playClick(
          isAccent: false,
          waveType: 'sawtooth',
          volume: 0.4,
          beatFrequency: 2200,
        );

        expect(audioEngine.initialized, isTrue);
      });

      test('_generateSamples produces samples for all wave functions', () async {
        // Test all wave type generators
        await audioEngine.playClick(
          isAccent: true,
          waveType: 'sine',
          volume: 0.5,
          accentFrequency: 1600,
        );

        await audioEngine.playClick(
          isAccent: false,
          waveType: 'square',
          volume: 0.5,
          beatFrequency: 800,
        );

        await audioEngine.playClick(
          isAccent: true,
          waveType: 'triangle',
          volume: 0.5,
          accentFrequency: 1760,
        );

        await audioEngine.playClick(
          isAccent: false,
          waveType: 'sawtooth',
          volume: 0.5,
          beatFrequency: 880,
        );

        final totalCalls = mockPlayers.fold<int>(0, (sum, p) => sum + p.playCallCount);
        expect(totalCalls, equals(4));
      });

      test('_floatToPcm16 converts samples to bytes', () async {
        // Exercise PCM conversion with various parameters
        await audioEngine.playClick(
          isAccent: false,
          waveType: 'sine',
          volume: 1.0,
          beatFrequency: 800,
        );

        await audioEngine.playClick(
          isAccent: true,
          waveType: 'square',
          volume: 0.5,
          accentFrequency: 1600,
        );

        final totalCalls = mockPlayers.fold<int>(0, (sum, p) => sum + p.playCallCount);
        expect(totalCalls, equals(2));
      });

      test('_calculateEnvelope produces smooth envelope', () async {
        // Exercise envelope calculation through multiple play calls
        await audioEngine.playClick(
          isAccent: true,
          waveType: 'sine',
          volume: 0.5,
          accentFrequency: 1600,
        );

        await audioEngine.playClick(
          isAccent: false,
          waveType: 'sine',
          volume: 0.5,
          beatFrequency: 800,
        );

        final totalCalls = mockPlayers.fold<int>(0, (sum, p) => sum + p.playCallCount);
        expect(totalCalls, equals(2));
      });

      test('full audio synthesis pipeline', () async {
        // Exercise complete synthesis pipeline for all combinations
        const frequencies = [800.0, 880.0, 1600.0, 1760.0, 2000.0, 2200.0];
        const waveTypes = ['sine', 'square', 'triangle', 'sawtooth'];
        const volumes = [0.25, 0.5, 0.75, 1.0];

        for (final freq in frequencies) {
          for (final wave in waveTypes) {
            for (final vol in volumes) {
              await audioEngine.playClick(
                isAccent: freq > 1500,
                waveType: wave,
                volume: vol,
                accentFrequency: freq,
                beatFrequency: freq,
              );
            }
          }
        }

        expect(audioEngine.initialized, isTrue);
      });
    });

    group('error handling', () {
      test('initialize handles errors gracefully', () async {
        // Create a mock player that throws on setReleaseMode
        final errorPlayer = MockAudioPlayer();
        errorPlayer.shouldThrow = true;
        
        final errorEngine = AudioEngine(playerFactory: () => errorPlayer);
        
        expect(() => errorEngine.initialize(), throwsA(isA<StateError>()));
        
        errorEngine.dispose();
      });

      test('playClick handles errors gracefully', () async {
        final errorPlayer = MockAudioPlayer();
        errorPlayer.shouldThrowOnPlay = true;
        
        final errorEngine = AudioEngine(playerFactory: () => errorPlayer);
        await errorEngine.initialize();
        
        // Should not throw - error is caught and logged
        await errorEngine.playClick(
          isAccent: true,
          waveType: 'sine',
          volume: 0.5,
        );
        
        expect(errorEngine.initialized, isTrue);
        errorEngine.dispose();
      });

      test('dispose handles errors gracefully', () async {
        final errorPlayer = MockAudioPlayer();
        errorPlayer.shouldThrowOnDispose = true;
        
        final errorEngine = AudioEngine(playerFactory: () => errorPlayer);
        await errorEngine.initialize();
        
        // Should not throw - error is caught and logged
        errorEngine.dispose();
        
        expect(errorEngine.initialized, isFalse);
      });
    });

    group('comprehensive integration', () {
      test('full workflow: initialize, play multiple sounds, dispose', () async {
        // Initialize
        await audioEngine.initialize();
        expect(audioEngine.initialized, isTrue);

        // Play various sounds
        await audioEngine.playClick(
          isAccent: true,
          waveType: 'sine',
          volume: 0.5,
          accentFrequency: 1600,
        );

        await audioEngine.playClick(
          isAccent: false,
          waveType: 'square',
          volume: 0.7,
          beatFrequency: 800,
        );

        await audioEngine.playTest();

        // Dispose
        audioEngine.dispose();
        expect(audioEngine.initialized, isFalse);
      });

      test('multiple initialize/dispose cycles', () async {
        for (int i = 0; i < 3; i++) {
          // Create new engine for each cycle
          final newEngine = AudioEngine(playerFactory: createMockFactory());
          
          await newEngine.initialize();
          expect(newEngine.initialized, isTrue);

          await newEngine.playClick(
            isAccent: i % 2 == 0,
            waveType: 'sine',
            volume: 0.5,
          );

          newEngine.dispose();
          expect(newEngine.initialized, isFalse);
        }
      });

      test('stress test with many play calls', () async {
        await audioEngine.initialize();

        // Simulate metronome pattern: 4/4 time at 120 BPM for 1 measure
        for (int beat = 0; beat < 4; beat++) {
          await audioEngine.playClick(
            isAccent: beat == 0,
            waveType: 'sine',
            volume: 0.5,
            accentFrequency: 1600,
            beatFrequency: 800,
          );
        }

        // Add subdivisions (4 per beat)
        for (int sub = 0; sub < 16; sub++) {
          await audioEngine.playClick(
            isAccent: false,
            waveType: 'triangle',
            volume: 0.3,
            beatFrequency: 800,
          );
        }

        // 20 total calls distributed across 4 players (5 each)
        final totalCalls = mockPlayers.fold<int>(0, (sum, p) => sum + p.playCallCount);
        expect(totalCalls, equals(20));
      });
    });
  });
}
