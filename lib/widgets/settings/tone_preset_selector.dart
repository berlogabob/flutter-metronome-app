/// Preset selection chips for quick tone configuration.
///
/// Displays horizontal list of preset chips that users can tap
/// to quickly configure tone settings.
///
/// Example:
/// ```dart
/// const TonePresetSelector(),
/// ```
library tone_preset_selector;

import 'package:flutter/material.dart';
import '../../theme/mono_pulse_theme.dart';
import '../../models/metronome_tone_config.dart';
import 'tone_preset_chip.dart';

/// Preset selection widget for tone configuration.
///
/// Uses const constructor and doesn't watch provider -
/// individual chips handle their own selection state.
class TonePresetSelector extends StatelessWidget {
  const TonePresetSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Tone presets. Select a preset to quickly configure tone settings.',
      child: Card(
        color: MonoPulseColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MonoPulseRadius.large),
          side: const BorderSide(color: MonoPulseColors.borderSubtle),
        ),
        child: Padding(
          padding: const EdgeInsets.all(MonoPulseSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Presets',
                style: MonoPulseTypography.headlineSmall.copyWith(
                  color: MonoPulseColors.textPrimary,
                ),
              ),
              const SizedBox(height: MonoPulseSpacing.md),
              Wrap(
                spacing: MonoPulseSpacing.sm,
                runSpacing: MonoPulseSpacing.sm,
                children: const [
                  TonePresetChip(name: 'Classic', config: MetronomeToneConfig.classic),
                  TonePresetChip(name: 'Subtle', config: MetronomeToneConfig.subtle),
                  TonePresetChip(name: 'Extreme', config: MetronomeToneConfig.extreme),
                  TonePresetChip(name: 'Wood Block', config: MetronomeToneConfig.woodBlock),
                  TonePresetChip(name: 'Electronic', config: MetronomeToneConfig.electronic),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
