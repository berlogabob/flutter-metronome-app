/// Volume control widget.
///
/// Displays slider for adjusting master volume from 0% to 100%.
///
/// Example:
/// ```dart
/// const VolumeControlWidget(),
/// ```
library volume_control_widget;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/mono_pulse_theme.dart';
import '../../providers/global_tone_config_provider.dart';

/// Volume control with slider and percentage display.
///
/// Uses [Selector] to only rebuild when volume changes,
/// not when frequencies or waveType change.
class VolumeControlWidget extends ConsumerWidget {
  const VolumeControlWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use Selector to only get the volume
    final volume = ref.watch(
      globalToneConfigProvider.select(
        (asyncConfig) => asyncConfig.value?.volume ?? 0.75,
      ),
    );
    final notifier = ref.read(globalToneConfigProvider.notifier);

    return Semantics(
      label: 'Volume control. Current volume: ${(volume * 100).toInt()} percent',
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
                'Volume',
                style: MonoPulseTypography.headlineSmall.copyWith(
                  color: MonoPulseColors.textPrimary,
                ),
              ),
              const SizedBox(height: MonoPulseSpacing.md),
              Row(
                children: [
                  ExcludeSemantics(
                    child: Icon(Icons.volume_down, color: MonoPulseColors.textSecondary),
                  ),
                  Expanded(
                    child: Semantics(
                      label: 'Volume slider',
                      value: '${(volume * 100).toInt()} percent',
                      increasedValue: '${((volume + 0.05) * 100).clamp(0, 100).toInt()} percent',
                      decreasedValue: '${((volume - 0.05) * 100).clamp(0, 100).toInt()} percent',
                      onIncrease: () {
                        notifier.setVolume((volume + 0.05).clamp(0.0, 1.0));
                      },
                      onDecrease: () {
                        notifier.setVolume((volume - 0.05).clamp(0.0, 1.0));
                      },
                      child: Slider(
                        value: volume,
                        min: 0.0,
                        max: 1.0,
                        divisions: 20,
                        activeColor: MonoPulseColors.accentOrange,
                        inactiveColor: MonoPulseColors.borderDefault,
                        label: '${(volume * 100).toInt()}%',
                        onChanged: (value) {
                          HapticFeedback.lightImpact();
                          notifier.setVolume(value);
                        },
                      ),
                    ),
                  ),
                  ExcludeSemantics(
                    child: Icon(Icons.volume_up, color: MonoPulseColors.textSecondary),
                  ),
                  SizedBox(
                    width: 50,
                    child: Text(
                      '${(volume * 100).toInt()}%',
                      style: MonoPulseTypography.labelMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
