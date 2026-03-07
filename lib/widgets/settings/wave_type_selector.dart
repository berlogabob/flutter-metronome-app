/// Wave type selector widget.
///
/// Displays segmented buttons for selecting wave type:
/// - Sine (smooth, pure tone)
/// - Square (harsh, electronic)
/// - Triangle (soft, mellow)
/// - Sawtooth (sharp, buzzy)
///
/// Example:
/// ```dart
/// const WaveTypeSelector(),
/// ```
library wave_type_selector;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/mono_pulse_theme.dart';
import '../../providers/global_tone_config_provider.dart';

/// Wave type option with display properties.
const _waveTypeDescriptions = {
  'sine': 'Smooth, pure tone (recommended)',
  'square': 'Harsh, electronic sound',
  'triangle': 'Soft, mellow tone',
  'sawtooth': 'Sharp, buzzy sound',
};

/// Segmented button selector for wave type.
///
/// Uses [Selector] to only rebuild when waveType changes,
/// not when frequencies or volume change.
class WaveTypeSelector extends ConsumerWidget {
  const WaveTypeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use Selector to only get the wave type
    final waveType = ref.watch(
      globalToneConfigProvider.select(
        (asyncConfig) => asyncConfig.value?.waveType ?? 'sine',
      ),
    );
    final notifier = ref.read(globalToneConfigProvider.notifier);

    return Semantics(
      label: 'Wave type selector. Current: $waveType',
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
                'Wave Type',
                style: MonoPulseTypography.headlineSmall.copyWith(
                  color: MonoPulseColors.textPrimary,
                ),
              ),
              const SizedBox(height: MonoPulseSpacing.md),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'sine', label: Text('Sine'), icon: Icon(Icons.waves)),
                  ButtonSegment(value: 'square', label: Text('Square'), icon: Icon(Icons.square)),
                  ButtonSegment(value: 'triangle', label: Text('Triangle'), icon: Icon(Icons.change_history)),
                  ButtonSegment(value: 'sawtooth', label: Text('Sawtooth'), icon: Icon(Icons.trending_up)),
                ],
                selected: {waveType},
                onSelectionChanged: (selected) {
                  notifier.setWaveType(selected.first);
                },
              ),
              const SizedBox(height: MonoPulseSpacing.sm),
              ExcludeSemantics(
                child: Text(
                  _waveTypeDescriptions[waveType] ?? '',
                  style: MonoPulseTypography.bodySmall.copyWith(
                    color: MonoPulseColors.textTertiary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
