// Provider for global metronome tone configuration
// Saved to user preferences, applied to all songs
// Updated for Riverpod 3.x - using Provider pattern

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/metronome_tone_config.dart';

/// Provider for global tone configuration
/// Riverpod 3.x - Async provider with SharedPreferences
final globalToneConfigProvider = AsyncNotifierProvider<GlobalToneConfigNotifier, MetronomeToneConfig>(
  GlobalToneConfigNotifier.new,
);

/// Notifier for global tone configuration
class GlobalToneConfigNotifier extends AsyncNotifier<MetronomeToneConfig> {
  @override
  Future<MetronomeToneConfig> build() async {
    return _loadFromPrefs();
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
  Future<MetronomeToneConfig> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      return MetronomeToneConfig(
        mainRegularFreq: prefs.getDouble(_keyMainRegular) ?? 1600.0,
        mainAccentFreq: prefs.getDouble(_keyMainAccent) ?? 2060.0,
        subRegularFreq: prefs.getDouble(_keySubRegular) ?? 800.0,
        subAccentFreq: prefs.getDouble(_keySubAccent) ?? 1030.0,
        dividerRegularFreq: prefs.getDouble(_keyDividerRegular) ?? 1100.0,
        dividerAccentFreq: prefs.getDouble(_keyDividerAccent) ?? 1400.0,
        waveType: prefs.getString(_keyWaveType) ?? 'sine',
        volume: prefs.getDouble(_keyVolume) ?? 0.75,
      );
    } catch (e) {
      debugPrint('[GlobalToneConfig] Failed to load: $e');
      return const MetronomeToneConfig();
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
    final current = await future;
    final updated = switch (beatType) {
      BeatType.main => switch (accent) {
          AccentState.regular => current.copyWith(mainRegularFreq: frequency),
          AccentState.accent => current.copyWith(mainAccentFreq: frequency),
        },
      BeatType.sub => switch (accent) {
          AccentState.regular => current.copyWith(subRegularFreq: frequency),
          AccentState.accent => current.copyWith(subAccentFreq: frequency),
        },
      BeatType.divider => switch (accent) {
          AccentState.regular => current.copyWith(dividerRegularFreq: frequency),
          AccentState.accent => current.copyWith(dividerAccentFreq: frequency),
        },
    };
    
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _saveToPrefs(updated);
      return updated;
    });
  }

  /// Update wave type
  Future<void> setWaveType(String waveType) async {
    final current = await future;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final updated = current.copyWith(waveType: waveType);
      await _saveToPrefs(updated);
      return updated;
    });
  }

  /// Update volume
  Future<void> setVolume(double volume) async {
    final current = await future;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final updated = current.copyWith(volume: volume);
      await _saveToPrefs(updated);
      return updated;
    });
  }

  /// Load preset
  Future<void> loadPreset(MetronomeToneConfig preset) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _saveToPrefs(preset);
      return preset;
    });
  }

  /// Reset to classic default
  Future<void> resetToClassic() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _saveToPrefs(MetronomeToneConfig.classic);
      return MetronomeToneConfig.classic;
    });
  }
}
