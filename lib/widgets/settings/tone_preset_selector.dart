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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/mono_pulse_theme.dart';
import '../../providers/global_tone_config_provider.dart';
import '../../models/metronome_tone_config.dart';
import 'tone_preset_chip.dart';

/// Available tone presets with configurations.
final _presets = [
  ('Classic', MetronomeToneConfig.classic),
  ('Subtle', MetronomeToneConfig.subtle),
  ('Extreme', MetronomeToneConfig.extreme),
  ('Wood Block', MetronomeToneConfig.woodBlock),
  ('Electronic', MetronomeToneConfig.electronic),
];

/// Preset selection widget for tone configuration.
class TonePresetSelector extends ConsumerWidget {
  const TonePresetSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(globalToneConfigProvider.notifier);

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
                children: _presets
                    .map((preset) => TonePresetChip(
                          name: preset.$1,
                          config: preset.$2,
                          notifier: notifier,
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
