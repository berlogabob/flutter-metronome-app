// Provider for global metronome tone configuration
// Saved to user preferences, applied to all songs
// Updated for Riverpod 3.x

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/metronome_tone_config.dart';

/// Provider for global tone configuration
/// Riverpod 3.x syntax
final globalToneConfigProvider = StateNotifierProvider<GlobalToneConfigNotifier, MetronomeToneConfig>(
  (ref) => GlobalToneConfigNotifier(),
);

/// Notifier for global tone configuration
/// Loads/saves from SharedPreferences
class GlobalToneConfigNotifier extends StateNotifier<MetronomeToneConfig> {
  GlobalToneConfigNotifier() : super(const MetronomeToneConfig()) {
    _loadFromPrefs();
  }

  /// Storage keys
  static const String _keyMainRegular = 'tone_main_regular';
  static const String _keyMainAccent = 'tone_main_accent';
  static const String _keySubRegular = 'tone_sub_regular';
  static const String _keySubAccent = 'tone_sub_accent';
  static const String _keyDividerRegular = 'tone_divider_regular';
  static const String _keyDividerAccent = 'tone_divider_accent';
  static const String _keyWaveType = 'tone_wave_type';
  static const String _keyVolume = 'tone_volume';

  /// Load configuration from SharedPreferences
  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      state = MetronomeToneConfig(
        mainRegularFreq: prefs.getDouble(_keyMainRegular) ?? 1600.0,
        mainAccentFreq: prefs.getDouble(_keyMainAccent) ?? 2060.0,
        subRegularFreq: prefs.getDouble(_keySubRegular) ?? 800.0,
        subAccentFreq: prefs.getDouble(_keySubAccent) ?? 1030.0,
        dividerRegularFreq: prefs.getDouble(_keyDividerRegular) ?? 1100.0,
        dividerAccentFreq: prefs.getDouble(_keyDividerAccent) ?? 1400.0,
        waveType: prefs.getString(_keyWaveType) ?? 'sine',
        volume: prefs.getDouble(_keyVolume) ?? 0.75,
      );
      
      debugPrint('[GlobalToneConfig] Loaded from prefs');
    } catch (e) {
      debugPrint('[GlobalToneConfig] Failed to load: $e');
    }
  }

  /// Save configuration to SharedPreferences
  Future<void> _saveToPrefs(MetronomeToneConfig config) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setDouble(_keyMainRegular, config.mainRegularFreq);
      await prefs.setDouble(_keyMainAccent, config.mainAccentFreq);
      await prefs.setDouble(_keySubRegular, config.subRegularFreq);
      await prefs.setDouble(_keySubAccent, config.subAccentFreq);
      await prefs.setDouble(_keyDividerRegular, config.dividerRegularFreq);
      await prefs.setDouble(_keyDividerAccent, config.dividerAccentFreq);
      await prefs.setString(_keyWaveType, config.waveType);
      await prefs.setDouble(_keyVolume, config.volume);
      
      debugPrint('[GlobalToneConfig] Saved to prefs');
    } catch (e) {
      debugPrint('[GlobalToneConfig] Failed to save: $e');
    }
  }

  /// Update frequency for specific beat type and accent
  Future<void> updateFrequency(BeatType beatType, AccentState accent, double frequency) async {
    state = switch (beatType) {
      BeatType.main => switch (accent) {
          AccentState.regular => state.copyWith(mainRegularFreq: frequency),
          AccentState.accent => state.copyWith(mainAccentFreq: frequency),
        },
      BeatType.sub => switch (accent) {
          AccentState.regular => state.copyWith(subRegularFreq: frequency),
          AccentState.accent => state.copyWith(subAccentFreq: frequency),
        },
      BeatType.divider => switch (accent) {
          AccentState.regular => state.copyWith(dividerRegularFreq: frequency),
          AccentState.accent => state.copyWith(dividerAccentFreq: frequency),
        },
    };
    await _saveToPrefs(state);
  }

  /// Update wave type
  Future<void> setWaveType(String waveType) async {
    state = state.copyWith(waveType: waveType);
    await _saveToPrefs(state);
  }

  /// Update volume
  Future<void> setVolume(double volume) async {
    state = state.copyWith(volume: volume);
    await _saveToPrefs(state);
  }

  /// Load preset
  Future<void> loadPreset(MetronomeToneConfig preset) async {
    state = preset;
    await _saveToPrefs(state);
  }

  /// Reset to classic default
  Future<void> resetToClassic() async {
    state = MetronomeToneConfig.classic;
    await _saveToPrefs(state);
  }
}
