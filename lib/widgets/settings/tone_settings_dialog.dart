// Fullscreen dialog for metronome tone settings
// Accessible from three-dots menu in metronome screen

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/mono_pulse_theme.dart';
import '../../providers/global_tone_config_provider.dart';
import '../../models/metronome_tone_config.dart';

/// Fullscreen dialog for tone matrix settings
/// Opens from three-dots menu in metronome screen
class ToneSettingsDialog extends ConsumerStatefulWidget {
  const ToneSettingsDialog({super.key});

  @override
  ConsumerState<ToneSettingsDialog> createState() => _ToneSettingsDialogState();
}

class _ToneSettingsDialogState extends ConsumerState<ToneSettingsDialog> {
  @override
  Widget build(BuildContext context) {
    final config = ref.watch(globalToneConfigProvider);
    final notifier = ref.read(globalToneConfigProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tone Settings'),
        backgroundColor: MonoPulseColors.black,
        foregroundColor: MonoPulseColors.textPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: () => _playTest(),
            tooltip: 'Test Sound',
          ),
        ],
      ),
      backgroundColor: MonoPulseColors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(MonoPulseSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Preset Selector
            _buildPresetSelector(notifier),
            
            const SizedBox(height: MonoPulseSpacing.xxl),
            
            // Tone Matrix
            _buildToneMatrix(config, notifier),
            
            const SizedBox(height: MonoPulseSpacing.xxl),
            
            // Wave Type Selector
            _buildWaveTypeSelector(config, notifier),
            
            const SizedBox(height: MonoPulseSpacing.xxl),
            
            // Volume Control
            _buildVolumeControl(config, notifier),
            
            const SizedBox(height: MonoPulseSpacing.xxl),
            
            // Reset Button
            Center(
              child: OutlinedButton.icon(
                onPressed: () => _showResetConfirm(notifier),
                icon: const Icon(Icons.refresh),
                label: const Text('Reset to Classic'),
              ),
            ),
            
            const SizedBox(height: MonoPulseSpacing.xxl),
          ],
        ),
      ),
    );
  }

  /// Build preset selector
  Widget _buildPresetSelector(GlobalToneConfigNotifier notifier) {
    return Card(
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
            const Text(
              'Presets',
              style: MonoPulseTypography.headlineSmall,
            ),
            const SizedBox(height: MonoPulseSpacing.md),
            Wrap(
              spacing: MonoPulseSpacing.sm,
              runSpacing: MonoPulseSpacing.sm,
              children: [
                _PresetChip('Classic', MetronomeToneConfig.classic, notifier),
                _PresetChip('Subtle', MetronomeToneConfig.subtle, notifier),
                _PresetChip('Extreme', MetronomeToneConfig.extreme, notifier),
                _PresetChip('Wood Block', MetronomeToneConfig.woodBlock, notifier),
                _PresetChip('Electronic', MetronomeToneConfig.electronic, notifier),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build tone matrix (frequency controls for each beat type)
  Widget _buildToneMatrix(MetronomeToneConfig config, GlobalToneConfigNotifier notifier) {
    return Card(
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
            const Text(
              'Tone Matrix',
              style: MonoPulseTypography.headlineSmall,
            ),
            const SizedBox(height: MonoPulseSpacing.sm),
            Text(
              'Customize frequency for each beat type',
              style: MonoPulseTypography.bodyMedium.copyWith(
                color: MonoPulseColors.textSecondary,
              ),
            ),
            const SizedBox(height: MonoPulseSpacing.lg),
            
            // Main Beat
            _buildBeatTypeRow(
              'Main Beat',
              'First beat of measure',
              config.mainRegularFreq,
              config.mainAccentFreq,
              (regular, accent) {
                notifier.updateFrequency(BeatType.main, AccentState.regular, regular);
                notifier.updateFrequency(BeatType.main, AccentState.accent, accent);
              },
            ),
            
            const Divider(height: MonoPulseSpacing.xxl, color: MonoPulseColors.borderSubtle),
            
            // Sub Beat
            _buildBeatTypeRow(
              'Sub Beat',
              'Regular beats within measure',
              config.subRegularFreq,
              config.subAccentFreq,
              (regular, accent) {
                notifier.updateFrequency(BeatType.sub, AccentState.regular, regular);
                notifier.updateFrequency(BeatType.sub, AccentState.accent, accent);
              },
            ),
            
            const Divider(height: MonoPulseSpacing.xxl, color: MonoPulseColors.borderSubtle),
            
            // Divider Beat
            _buildBeatTypeRow(
              'Divider Beat',
              'Subdivision markers',
              config.dividerRegularFreq,
              config.dividerAccentFreq,
              (regular, accent) {
                notifier.updateFrequency(BeatType.divider, AccentState.regular, regular);
                notifier.updateFrequency(BeatType.divider, AccentState.accent, accent);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Build a row for a beat type with regular and accent frequency sliders
  Widget _buildBeatTypeRow(
    String title,
    String subtitle,
    double regularFreq,
    double accentFreq,
    Function(double, double) onUpdate,
  ) {
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
                    title,
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
        
        // Regular frequency slider
        _buildFrequencySlider(
          label: 'Regular',
          value: regularFreq,
          min: 400,
          max: 2000,
          onChanged: (value) => onUpdate(value, accentFreq),
        ),
        
        const SizedBox(height: MonoPulseSpacing.md),
        
        // Accent frequency slider
        _buildFrequencySlider(
          label: 'Accent',
          value: accentFreq,
          min: 600,
          max: 3000,
          onChanged: (value) => onUpdate(regularFreq, value),
        ),
      ],
    );
  }

  /// Build frequency slider with value display
  Widget _buildFrequencySlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required Function(double) onChanged,
  }) {
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

  /// Build wave type selector
  Widget _buildWaveTypeSelector(MetronomeToneConfig config, GlobalToneConfigNotifier notifier) {
    return Card(
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
            const Text(
              'Wave Type',
              style: MonoPulseTypography.headlineSmall,
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
              onSelectionChanged: (Set<String> selected) {
                HapticFeedback.lightImpact();
                notifier.setWaveType(selected.first);
              },
            ),
            const SizedBox(height: MonoPulseSpacing.sm),
            Text(
              _getWaveTypeDescription(config.waveType),
              style: MonoPulseTypography.bodySmall.copyWith(
                color: MonoPulseColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build volume control
  Widget _buildVolumeControl(MetronomeToneConfig config, GlobalToneConfigNotifier notifier) {
    return Card(
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
            const Text(
              'Volume',
              style: MonoPulseTypography.headlineSmall,
            ),
            const SizedBox(height: MonoPulseSpacing.md),
            Row(
              children: [
                Icon(Icons.volume_down, color: MonoPulseColors.textSecondary),
                Expanded(
                  child: Slider(
                    value: config.volume,
                    min: 0.0,
                    max: 1.0,
                    divisions: 20,
                    activeColor: MonoPulseColors.accentOrange,
                    inactiveColor: MonoPulseColors.borderDefault,
                    label: '${(config.volume * 100).toInt()}%',
                    onChanged: (value) {
                      HapticFeedback.lightImpact();
                      notifier.setVolume(value);
                    },
                  ),
                ),
                Icon(Icons.volume_up, color: MonoPulseColors.textSecondary),
                SizedBox(
                  width: 50,
                  child: Text(
                    '${(config.volume * 100).toInt()}%',
                    style: MonoPulseTypography.labelMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getWaveTypeDescription(String waveType) {
    return switch (waveType) {
      'sine' => 'Smooth, pure tone (recommended)',
      'square' => 'Harsh, electronic sound',
      'triangle' => 'Soft, mellow tone',
      'sawtooth' => 'Sharp, buzzy sound',
      _ => '',
    };
  }

  void _playTest() {
    // In real app, this would call audio engine's playTest()
    // For now, just show feedback
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Playing test sound...'),
        backgroundColor: MonoPulseColors.accentOrange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MonoPulseRadius.medium),
        ),
      ),
    );
  }

  void _showResetConfirm(GlobalToneConfigNotifier notifier) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: MonoPulseColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MonoPulseRadius.xlarge),
        ),
        title: const Text(
          'Reset to Classic?',
          style: MonoPulseTypography.headlineSmall,
        ),
        content: Text(
          'This will reset all tone settings to the classic preset.',
          style: MonoPulseTypography.bodyMedium.copyWith(
            color: MonoPulseColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: MonoPulseTypography.labelLarge.copyWith(
                color: MonoPulseColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              notifier.resetToClassic();
              HapticFeedback.lightImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Reset to Classic'),
                  backgroundColor: MonoPulseColors.accentOrange,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(MonoPulseRadius.medium),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: MonoPulseColors.accentOrange,
              foregroundColor: MonoPulseColors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(MonoPulseRadius.medium),
              ),
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}

/// Preset selection chip
class _PresetChip extends StatefulWidget {
  final String name;
  final MetronomeToneConfig preset;
  final GlobalToneConfigNotifier notifier;

  const _PresetChip(this.name, this.preset, this.notifier);

  @override
  State<_PresetChip> createState() => _PresetChipState();
}

class _PresetChipState extends State<_PresetChip> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(widget.name),
      onSelected: (selected) {
        setState(() => _isSelected = selected);
        if (selected) {
          HapticFeedback.lightImpact();
          widget.notifier.loadPreset(widget.preset);
        }
      },
      selected: _isSelected,
      selectedColor: MonoPulseColors.accentOrangeSubtle,
      checkmarkColor: MonoPulseColors.accentOrange,
      labelStyle: TextStyle(
        color: _isSelected ? MonoPulseColors.accentOrange : MonoPulseColors.textPrimary,
      ),
      side: BorderSide(
        color: _isSelected ? MonoPulseColors.accentOrange : MonoPulseColors.borderDefault,
      ),
    );
  }
}
