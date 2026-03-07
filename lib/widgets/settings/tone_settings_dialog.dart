/// Fullscreen dialog for configuring metronome tone settings.
///
/// Accessible from the three-dots menu in metronome screen.
/// Provides controls for:
/// - Preset selection
/// - Frequency matrix (main/sub/divider beats)
/// - Wave type selection
/// - Volume control
///
/// Example:
/// ```dart
/// Navigator.of(context).push(
///   MaterialPageRoute(builder: (_) => const ToneSettingsDialog()),
/// );
/// ```
library tone_settings_dialog;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/mono_pulse_theme.dart';
import '../../providers/global_tone_config_provider.dart';
import 'tone_preset_selector.dart';
import 'tone_matrix_widget.dart';
import 'wave_type_selector.dart';
import 'volume_control_widget.dart';
import 'tone_reset_button.dart';

class ToneSettingsDialog extends ConsumerWidget {
  const ToneSettingsDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: _ToneAppBar(),
      backgroundColor: MonoPulseColors.black,
      body: _ToneSettingsContent(),
    );
  }
}

/// Custom app bar for tone settings dialog.
class _ToneAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _ToneAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: MonoPulseColors.black,
      foregroundColor: MonoPulseColors.textPrimary,
      elevation: 0,
      title: Semantics(
        label: 'Tone Settings',
        excludeSemantics: true,
        child: const Text('Tone Settings'),
      ),
      leading: Semantics(
        label: 'Close settings',
        button: true,
        child: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      actions: [
        Semantics(
          label: 'Test sound',
          button: true,
          child: IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: () {
              HapticFeedback.lightImpact();
              // TODO: Add audio test when audio provider is available
            },
            tooltip: 'Test Sound',
          ),
        ),
      ],
    );
  }
}

/// Scrollable content of tone settings dialog.
class _ToneSettingsContent extends StatelessWidget {
  const _ToneSettingsContent();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(MonoPulseSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          TonePresetSelector(),
          SizedBox(height: MonoPulseSpacing.xxl),
          ToneMatrixWidget(),
          SizedBox(height: MonoPulseSpacing.xxl),
          WaveTypeSelector(),
          SizedBox(height: MonoPulseSpacing.xxl),
          VolumeControlWidget(),
          SizedBox(height: MonoPulseSpacing.xxl),
          ToneResetButton(),
        ],
      ),
    );
  }
}
