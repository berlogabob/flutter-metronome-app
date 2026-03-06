/// Individual preset chip for tone configuration.
///
/// A single selectable chip that applies a specific tone preset
/// when tapped.
///
/// Example:
/// ```dart
/// TonePresetChip(
///   name: 'Classic',
///   config: MetronomeToneConfig.classic,
///   notifier: notifier,
/// ),
/// ```
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/mono_pulse_theme.dart';
import '../../providers/global_tone_config_provider.dart';
import '../../models/metronome_tone_config.dart';

/// Individual chip for selecting a tone preset.
class TonePresetChip extends StatefulWidget {
  /// Display name of the preset.
  final String name;

  /// Configuration to apply when selected.
  final MetronomeToneConfig config;

  /// Notifier to update tone configuration.
  final GlobalToneConfigNotifier notifier;

  const TonePresetChip({
    super.key,
    required this.name,
    required this.config,
    required this.notifier,
  });

  @override
  State<TonePresetChip> createState() => _TonePresetChipState();
}

class _TonePresetChipState extends State<TonePresetChip> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(widget.name),
      onSelected: _handleSelect,
      selected: _isSelected,
      selectedColor: MonoPulseColors.accentOrangeSubtle,
      checkmarkColor: MonoPulseColors.accentOrange,
      labelStyle: TextStyle(
        color: _isSelected
            ? MonoPulseColors.accentOrange
            : MonoPulseColors.textPrimary,
      ),
      side: BorderSide(
        color: _isSelected
            ? MonoPulseColors.accentOrange
            : MonoPulseColors.borderDefault,
      ),
    );
  }

  void _handleSelect(bool selected) {
    setState(() => _isSelected = selected);
    if (selected) {
      HapticFeedback.lightImpact();
      widget.notifier.loadPreset(widget.config);
    }
  }
}
