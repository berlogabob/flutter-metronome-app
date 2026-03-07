/// Individual preset chip for tone configuration.
///
/// A single selectable chip that applies a specific tone preset
/// when tapped.
///
/// Example:
/// ```dart
/// TonePresetChip(
///   name: 'Classic',
///   config: MetronomeToneConfig.classic,
/// ),
/// ```
library tone_preset_chip;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/mono_pulse_theme.dart';
import '../../providers/global_tone_config_provider.dart';
import '../../models/metronome_tone_config.dart';

/// Individual chip for selecting a tone preset.
///
/// Uses [Selector] to only rebuild when this specific preset's
/// selection state changes, not on every config update.
class TonePresetChip extends ConsumerWidget {
  /// Display name of the preset.
  final String name;

  /// Configuration to apply when selected.
  final MetronomeToneConfig config;

  const TonePresetChip({
    super.key,
    required this.name,
    required this.config,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use Selector to only rebuild when this preset's selection state changes
    final isSelected = ref.watch(
      globalToneConfigProvider.select(
        (asyncConfig) => asyncConfig.value?.matchesPreset(config) ?? false,
      ),
    );

    return Semantics(
      label: '$name tone preset${isSelected ? ", selected" : ""}',
      child: FilterChip(
        label: Text(name),
        onSelected: (selected) => _handleSelect(selected, ref),
        selected: isSelected,
        selectedColor: MonoPulseColors.accentOrangeSubtle,
        checkmarkColor: MonoPulseColors.accentOrange,
        labelStyle: TextStyle(
          color: isSelected
              ? MonoPulseColors.accentOrange
              : MonoPulseColors.textPrimary,
        ),
        side: BorderSide(
          color: isSelected
              ? MonoPulseColors.accentOrange
              : MonoPulseColors.borderDefault,
        ),
      ),
    );
  }

  void _handleSelect(bool selected, WidgetRef ref) {
    if (selected) {
      ref.read(globalToneConfigProvider.notifier).loadPreset(config);
    }
  }
}

/// Extension to check if current config matches a preset
extension on MetronomeToneConfig {
  /// Checks if this config matches the given preset config
  bool matchesPreset(MetronomeToneConfig preset) {
    return mainRegularFreq == preset.mainRegularFreq &&
        mainAccentFreq == preset.mainAccentFreq &&
        subRegularFreq == preset.subRegularFreq &&
        subAccentFreq == preset.subAccentFreq &&
        dividerRegularFreq == preset.dividerRegularFreq &&
        dividerAccentFreq == preset.dividerAccentFreq &&
        waveType == preset.waveType &&
        volume == preset.volume;
  }
}
