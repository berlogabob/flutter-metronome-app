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
///   regularFreq: 1600,
///   accentFreq: 2060,
///   onRegularChanged: (freq) => ...,
///   onAccentChanged: (freq) => ...,
/// ),
/// ```
import 'package:flutter/material.dart';
import '../../theme/mono_pulse_theme.dart';

/// Frequency control widget for a single beat type.
class BeatFrequencyControl extends StatelessWidget {
  /// Display label for the beat type.
  final String label;

  /// Subtitle describing the beat type.
  final String subtitle;

  /// Current regular frequency in Hz.
  final double regularFreq;

  /// Current accent frequency in Hz.
  final double accentFreq;

  /// Callback when regular frequency changes.
  final ValueChanged<double> onRegularChanged;

  /// Callback when accent frequency changes.
  final ValueChanged<double> onAccentChanged;

  const BeatFrequencyControl({
    super.key,
    required this.label,
    required this.subtitle,
    required this.regularFreq,
    required this.accentFreq,
    required this.onRegularChanged,
    required this.onAccentChanged,
  });

  @override
  Widget build(BuildContext context) {
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
          value: regularFreq,
          min: 400,
          max: 2000,
          onChanged: onRegularChanged,
        ),
        const SizedBox(height: MonoPulseSpacing.md),
        _FrequencySlider(
          label: 'Accent',
          value: accentFreq,
          min: 600,
          max: 3000,
          onChanged: onAccentChanged,
        ),
      ],
    );
  }
}

/// Individual frequency slider with value display.
class _FrequencySlider extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 70,
          child: Text(
            label,
            style: MonoPulseTypography.bodyMedium.copyWith(
              color: MonoPulseColors.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: 32,
            activeColor: MonoPulseColors.accentOrange,
            inactiveColor: MonoPulseColors.borderDefault,
            label: '${value.toInt()} Hz',
            onChanged: onChanged,
          ),
        ),
        SizedBox(
          width: 60,
          child: Text(
            '${value.toInt()} Hz',
            style: MonoPulseTypography.labelMedium,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
