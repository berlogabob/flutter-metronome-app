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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/mono_pulse_theme.dart';
import '../../providers/global_tone_config_provider.dart';
import '../../models/metronome_tone_config.dart';
import 'beat_frequency_control.dart';

/// Matrix of frequency controls for all beat types.
class ToneMatrixWidget extends ConsumerWidget {
  const ToneMatrixWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configAsync = ref.watch(globalToneConfigProvider);
    final notifier = ref.read(globalToneConfigProvider.notifier);
    
    return configAsync.when(
      data: (config) => Semantics(
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
                BeatFrequencyControl(
                  label: 'Main Beat',
                  subtitle: 'First beat of measure',
                  regularFreq: config.mainRegularFreq,
                  accentFreq: config.mainAccentFreq,
                  onRegularChanged: (freq) =>
                      notifier.updateFrequency(BeatType.main, AccentState.regular, freq),
                  onAccentChanged: (freq) =>
                      notifier.updateFrequency(BeatType.main, AccentState.accent, freq),
                ),
                const Divider(height: MonoPulseSpacing.xxl, color: MonoPulseColors.borderSubtle),
                BeatFrequencyControl(
                  label: 'Sub Beat',
                  subtitle: 'Regular beats within measure',
                  regularFreq: config.subRegularFreq,
                  accentFreq: config.subAccentFreq,
                  onRegularChanged: (freq) =>
                      notifier.updateFrequency(BeatType.sub, AccentState.regular, freq),
                  onAccentChanged: (freq) =>
                      notifier.updateFrequency(BeatType.sub, AccentState.accent, freq),
                ),
                const Divider(height: MonoPulseSpacing.xxl, color: MonoPulseColors.borderSubtle),
                BeatFrequencyControl(
                  label: 'Divider Beat',
                  subtitle: 'Subdivision markers',
                  regularFreq: config.dividerRegularFreq,
                  accentFreq: config.dividerAccentFreq,
                  onRegularChanged: (freq) =>
                      notifier.updateFrequency(BeatType.divider, AccentState.regular, freq),
                  onAccentChanged: (freq) =>
                      notifier.updateFrequency(BeatType.divider, AccentState.accent, freq),
                ),
              ],
            ),
          ),
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}
