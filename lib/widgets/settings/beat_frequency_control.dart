/// Individual frequency control for a beat type.
///
/// Displays two sliders for regular and accent frequencies
/// with labeled value displays.
///
/// Example:
/// ```dart
/// BeatFrequencyControl(
///   label: 'Main Beat',
///   subtitle: 'First beat of measure',
///   beatType: BeatType.main,
/// ),
/// ```
library beat_frequency_control;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/mono_pulse_theme.dart';
import '../../providers/global_tone_config_provider.dart';
import '../../models/metronome_tone_config.dart';

/// Frequency control widget for a single beat type.
///
/// Uses [Selector] to only rebuild when its specific frequencies change,
/// not when other beat types or volume/waveType change.
class BeatFrequencyControl extends ConsumerWidget {
  /// Display label for the beat type.
  final String label;

  /// Subtitle describing the beat type.
  final String subtitle;

  /// Type of beat this control manages.
  final BeatType beatType;

  const BeatFrequencyControl({
    super.key,
    required this.label,
    required this.subtitle,
    required this.beatType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use Selector to only get the frequencies we care about
    final frequencies = ref.watch(
      globalToneConfigProvider.select(
        (asyncConfig) => asyncConfig.value?.getFrequenciesForBeat(beatType),
      ),
    );

    if (frequencies == null) {
      return const SizedBox.shrink();
    }

    final notifier = ref.read(globalToneConfigProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.music_note, size: 20, color: MonoPulseColors.accentOrange),
            const SizedBox(width: MonoPulseSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: MonoPulseTypography.labelLarge,
                  ),
                  Text(
                    subtitle,
                    style: MonoPulseTypography.bodySmall.copyWith(
                      color: MonoPulseColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: MonoPulseSpacing.lg),
        _FrequencySlider(
          label: 'Regular',
          value: frequencies.$1,
          min: 400,
          max: 2000,
          onChanged: (freq) => notifier.updateFrequency(beatType, AccentState.regular, freq),
        ),
        const SizedBox(height: MonoPulseSpacing.md),
        _FrequencySlider(
          label: 'Accent',
          value: frequencies.$2,
          min: 600,
          max: 3000,
          onChanged: (freq) => notifier.updateFrequency(beatType, AccentState.accent, freq),
        ),
      ],
    );
  }
}

/// Individual frequency slider with value display.
///
/// Uses ValueNotifier for slider value to avoid rebuilding on drag.
class _FrequencySlider extends StatefulWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  const _FrequencySlider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  State<_FrequencySlider> createState() => _FrequencySliderState();
}

class _FrequencySliderState extends State<_FrequencySlider> {
  late double _sliderValue;

  @override
  void initState() {
    super.initState();
    _sliderValue = widget.value;
  }

  @override
  void didUpdateWidget(_FrequencySlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only update if the value changed externally (not from user dragging)
    if (oldWidget.value != widget.value) {
      _sliderValue = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${widget.label} frequency slider',
      value: '${_sliderValue.toInt()} Hz',
      increasedValue: '${(_sliderValue + (widget.max - widget.min) / 32).toInt()} Hz',
      decreasedValue: '${(_sliderValue - (widget.max - widget.min) / 32).toInt()} Hz',
      onIncrease: () {
        widget.onChanged((_sliderValue + (widget.max - widget.min) / 32).clamp(widget.min, widget.max));
      },
      onDecrease: () {
        widget.onChanged((_sliderValue - (widget.max - widget.min) / 32).clamp(widget.min, widget.max));
      },
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              widget.label,
              style: MonoPulseTypography.bodyMedium.copyWith(
                color: MonoPulseColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Slider(
              value: _sliderValue,
              min: widget.min,
              max: widget.max,
              divisions: 32,
              activeColor: MonoPulseColors.accentOrange,
              inactiveColor: MonoPulseColors.borderDefault,
              label: '${_sliderValue.toInt()} Hz',
              onChanged: (value) {
                setState(() => _sliderValue = value);
                widget.onChanged(value);
              },
            ),
          ),
          SizedBox(
            width: 60,
            child: Text(
              '${_sliderValue.toInt()} Hz',
              style: MonoPulseTypography.labelMedium,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
