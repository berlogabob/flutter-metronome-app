/// Tone matrix widget for configuring frequencies per beat type.
///
/// Displays frequency controls for:
/// - Main beat (regular + accent)
/// - Sub beat (regular + accent)
/// - Divider beat (regular + accent)
///
/// Example:
/// ```dart
/// const ToneMatrixWidget(),
/// ```
library tone_matrix_widget;

import 'package:flutter/material.dart';
import '../../theme/mono_pulse_theme.dart';
import '../../models/metronome_tone_config.dart';
import 'beat_frequency_control.dart';

/// Matrix of frequency controls for all beat types.
///
/// Uses const constructor - individual controls manage their own state.
class ToneMatrixWidget extends StatelessWidget {
  const ToneMatrixWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Tone matrix. Customize frequency for each beat type.',
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
                'Tone Matrix',
                style: MonoPulseTypography.headlineSmall.copyWith(
                  color: MonoPulseColors.textPrimary,
                ),
              ),
              const SizedBox(height: MonoPulseSpacing.sm),
              Text(
                'Customize frequency for each beat type',
                style: MonoPulseTypography.bodyMedium.copyWith(
                  color: MonoPulseColors.textSecondary,
                ),
              ),
              const SizedBox(height: MonoPulseSpacing.lg),
              const BeatFrequencyControl(
                label: 'Main Beat',
                subtitle: 'First beat of measure',
                beatType: BeatType.main,
              ),
              const Divider(height: MonoPulseSpacing.xxl, color: MonoPulseColors.borderSubtle),
              const BeatFrequencyControl(
                label: 'Sub Beat',
                subtitle: 'Regular beats within measure',
                beatType: BeatType.sub,
              ),
              const Divider(height: MonoPulseSpacing.xxl, color: MonoPulseColors.borderSubtle),
              const BeatFrequencyControl(
                label: 'Divider Beat',
                subtitle: 'Subdivision markers',
                beatType: BeatType.divider,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
