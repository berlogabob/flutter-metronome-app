/// Vibration toggle widget for metronome beats.
///
/// Displays a switch to enable/disable vibration on beats.
///
/// Example:
/// ```dart
/// const VibrationToggleWidget(),
/// ```
library vibration_toggle_widget;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/mono_pulse_theme.dart';
import '../../providers/metronome_provider.dart';

/// Vibration toggle with switch and description.
///
/// Uses [Selector] to only rebuild when vibration state changes,
/// not when other metronome properties change.
class VibrationToggleWidget extends ConsumerWidget {
  const VibrationToggleWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use Selector to only get the vibration state
    final vibrationEnabled = ref.watch(
      metronomeProvider.select(
        (state) => state.vibrationEnabled,
      ),
    );
    final notifier = ref.read(metronomeProvider.notifier);

    return Semantics(
      label: 'Vibration on beats. ${vibrationEnabled ? 'Enabled' : 'Disabled'}',
      child: Card(
        color: MonoPulseColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MonoPulseRadius.large),
          side: const BorderSide(color: MonoPulseColors.borderSubtle),
        ),
        child: Padding(
          padding: const EdgeInsets.all(MonoPulseSpacing.lg),
          child: Row(
            children: [
              ExcludeSemantics(
                child: Icon(
                  vibrationEnabled ? Icons.vibration : Icons.phone_android,
                  color: vibrationEnabled
                      ? MonoPulseColors.accentOrange
                      : MonoPulseColors.textSecondary,
                ),
              ),
              const SizedBox(width: MonoPulseSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vibration',
                      style: MonoPulseTypography.labelLarge.copyWith(
                        color: vibrationEnabled
                            ? MonoPulseColors.accentOrange
                            : MonoPulseColors.textPrimary,
                      ),
                    ),
                    Text(
                      vibrationEnabled
                          ? 'Vibration enabled on beats'
                          : 'Vibration disabled',
                      style: MonoPulseTypography.bodySmall.copyWith(
                        color: MonoPulseColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: vibrationEnabled,
                onChanged: (value) {
                  HapticFeedback.lightImpact();
                  notifier.setVibrationEnabled(value);
                },
                activeThumbColor: MonoPulseColors.accentOrange,
                activeTrackColor: MonoPulseColors.accentOrange.withAlpha(128),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
