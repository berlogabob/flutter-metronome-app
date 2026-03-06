// Example UI widget for metronome tone configuration
// Shows how to implement user settings for the tone matrix

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/metronome_tone_config.dart';

/// Provider for metronome tone configuration
final toneConfigProvider = StateNotifierProvider<ToneConfigNotifier, MetronomeToneConfig>(
  (ref) => ToneConfigNotifier(),
);

class ToneConfigNotifier extends StateNotifier<MetronomeToneConfig> {
  ToneConfigNotifier() : super(const MetronomeToneConfig());

  void updateFrequency(BeatType beatType, AccentState accent, double frequency) {
    state = switch (beatType) {
      BeatType.main => switch (accent) {
          AccentState.regular => state.copyWith(mainRegularFreq: frequency),
          AccentState.accent => state.copyWith(mainAccentFreq: frequency),
        },
      BeatType.sub => switch (accent) {
          AccentState.regular => state.copyWith(subRegularFreq: frequency),
          AccentState.accent => state.copyWith(subAccentFreq: frequency),
        },
      BeatType.divider => switch (accent) {
          AccentState.regular => state.copyWith(dividerRegularFreq: frequency),
          AccentState.accent => state.copyWith(dividerAccentFreq: frequency),
        },
    };
  }

  void setWaveType(String waveType) {
    state = state.copyWith(waveType: waveType);
  }

  void setVolume(double volume) {
    state = state.copyWith(volume: volume);
  }

  void loadPreset(MetronomeToneConfig preset) {
    state = preset;
  }
}

/// Tone Matrix Settings Screen
/// 
/// Allows users to customize frequencies for each beat type:
/// - Main beat (regular + accent)
/// - Sub beat (regular + accent)
/// - Divider beat (regular + accent)
class ToneMatrixSettings extends ConsumerWidget {
  const ToneMatrixSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(toneConfigProvider);
    final notifier = ref.read(toneConfigProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Metronome Tones'),
        actions: [
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: () => _playTest(ref),
            tooltip: 'Test Sound',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Preset Selector
            _buildPresetSelector(notifier),
            
            const SizedBox(height: 24),
            
            // Tone Matrix
            _buildToneMatrix(config, notifier),
            
            const SizedBox(height: 24),
            
            // Wave Type Selector
            _buildWaveTypeSelector(config, notifier),
            
            const SizedBox(height: 24),
            
            // Volume Control
            _buildVolumeControl(config, notifier),
            
            const SizedBox(height: 32),
            
            // Reset Button
            Center(
              child: OutlinedButton.icon(
                onPressed: () => notifier.loadPreset(MetronomeToneConfig.classic),
                icon: const Icon(Icons.refresh),
                label: const Text('Reset to Classic'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build preset selector
  Widget _buildPresetSelector(ToneConfigNotifier notifier) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Presets',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
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
  Widget _buildToneMatrix(MetronomeToneConfig config, ToneConfigNotifier notifier) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tone Matrix',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Customize frequency for each beat type',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            
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
            
            const Divider(height: 32),
            
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
            
            const Divider(height: 32),
            
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
            Icon(Icons.music_note, size: 20, color: Colors.blue[700]),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Regular frequency slider
        _buildFrequencySlider(
          label: 'Regular',
          value: regularFreq,
          min: 400,
          max: 2000,
          onChanged: (value) => onUpdate(value, accentFreq),
        ),
        
        const SizedBox(height: 12),
        
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
        Text(label, style: const TextStyle(fontSize: 14), width: 80),
        Expanded(
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: 32,
            label: '${value.toInt()} Hz',
            onChanged: onChanged,
          ),
        ),
        SizedBox(
          width: 60,
          child: Text(
            '${value.toInt()} Hz',
            style: const TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  /// Build wave type selector
  Widget _buildWaveTypeSelector(MetronomeToneConfig config, ToneConfigNotifier notifier) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Wave Type',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'sine', label: Text('Sine'), icon: Icon(Icons.waves)),
                ButtonSegment(value: 'square', label: Text('Square'), icon: Icon(Icons.square)),
                ButtonSegment(value: 'triangle', label: Text('Triangle'), icon: Icon(Icons.change_history)),
                ButtonSegment(value: 'sawtooth', label: Text('Sawtooth'), icon: Icon(Icons.trending_up)),
              ],
              selected: {config.waveType},
              onSelectionChanged: (Set<String> selected) {
                notifier.setWaveType(selected.first);
              },
            ),
            const SizedBox(height: 8),
            Text(
              _getWaveTypeDescription(config.waveType),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  /// Build volume control
  Widget _buildVolumeControl(MetronomeToneConfig config, ToneConfigNotifier notifier) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Volume',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.volume_down),
                Expanded(
                  child: Slider(
                    value: config.volume,
                    min: 0.0,
                    max: 1.0,
                    divisions: 20,
                    label: '${(config.volume * 100).toInt()}%',
                    onChanged: (value) => notifier.setVolume(value),
                  ),
                ),
                const Icon(Icons.volume_up),
                SizedBox(
                  width: 50,
                  child: Text(
                    '${(config.volume * 100).toInt()}%',
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

  void _playTest(WidgetRef ref) {
    // In real app, this would call audio engine's playTest()
    ScaffoldMessenger.of(ref.context).showSnackBar(
      const SnackBar(content: Text('Playing test sound...')),
    );
  }
}

/// Preset selection chip
class _PresetChip extends StatelessWidget {
  final String name;
  final MetronomeToneConfig preset;
  final ToneConfigNotifier notifier;

  const _PresetChip(this.name, this.preset, this.notifier);

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(name),
      onSelected: (selected) {
        if (selected) notifier.loadPreset(preset);
      },
      selected: false,
    );
  }
}
