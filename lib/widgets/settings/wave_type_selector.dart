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
final _waveTypes = [
  ('sine', 'Sine', Icons.waves, 'Smooth, pure tone (recommended)'),
  ('square', 'Square', Icons.square, 'Harsh, electronic sound'),
  ('triangle', 'Triangle', Icons.change_history, 'Soft, mellow tone'),
  ('sawtooth', 'Sawtooth', Icons.trending_up, 'Sharp, buzzy sound'),
];

/// Segmented button selector for wave type.
class WaveTypeSelector extends ConsumerWidget {
  const WaveTypeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configAsync = ref.watch(globalToneConfigProvider);
    final notifier = ref.read(globalToneConfigProvider.notifier);
    
    return configAsync.when(
      data: (config) => Semantics(
        label: 'Wave type selector. Current: ${config.waveType}',
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
                  selected: {config.waveType},
                  onSelectionChanged: (selected) {
                    HapticFeedback.lightImpact();
                    notifier.setWaveType(selected.first);
                  },
                ),
                const SizedBox(height: MonoPulseSpacing.sm),
                ExcludeSemantics(
                  child: Text(
                    _waveTypes.firstWhere((w) => w.$1 == config.waveType).$4,
                    style: MonoPulseTypography.bodySmall.copyWith(
                      color: MonoPulseColors.textTertiary,
                    ),
                  ),
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
