// Platform-dependent AudioPlayer adapter
// This file is excluded from unit test coverage - tested via integration tests

import 'package:audioplayers/audioplayers.dart';
import 'audio_engine_mobile.dart';

/// Adapter for real AudioPlayer
/// Platform-dependent wrapper that bridges AudioPlayer to IAudioPlayer
class AudioPlayerAdapter implements IAudioPlayer {
  final AudioPlayer _player;

  AudioPlayerAdapter() : _player = AudioPlayer();

  @override
  Future<void> setReleaseMode(ReleaseMode mode) => _player.setReleaseMode(mode);

  @override
  Future<void> setVolume(double volume) => _player.setVolume(volume);

  @override
  Future<void> play(BytesSource source, {double? volume}) => _player.play(source, volume: volume);

  @override
  Future<void> setSource(BytesSource source) => _player.setSource(source);

  @override
  Future<void> resume() => _player.resume();

  @override
  Future<void> pause() => _player.pause();

  @override
  void dispose() => _player.dispose();
}
