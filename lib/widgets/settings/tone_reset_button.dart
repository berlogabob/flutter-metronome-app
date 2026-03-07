/// Reset button widget for restoring default tone settings.
///
/// Displays a button that confirms and resets to classic preset.
///
/// Example:
/// ```dart
/// const ToneResetButton(),
/// ```
library tone_reset_button;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/mono_pulse_theme.dart';
import '../../providers/global_tone_config_provider.dart';

/// Reset button with confirmation dialog.
class ToneResetButton extends ConsumerWidget {
  const ToneResetButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(globalToneConfigProvider.notifier);

    return Semantics(
      label: 'Reset to classic preset',
      button: true,
      child: Center(
        child: OutlinedButton.icon(
          onPressed: () => _showResetConfirm(context, notifier),
          icon: const Icon(Icons.refresh),
          label: const Text('Reset to Classic'),
        ),
      ),
    );
  }

  void _showResetConfirm(BuildContext context, GlobalToneConfigNotifier notifier) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: MonoPulseColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MonoPulseRadius.xlarge),
        ),
        title: Text(
          'Reset to Classic?',
          style: MonoPulseTypography.headlineSmall.copyWith(
            color: MonoPulseColors.textHighEmphasis,
          ),
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
              HapticFeedback.lightImpact();
              notifier.resetToClassic();
              _showSuccessSnackBar(context);
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

  void _showSuccessSnackBar(BuildContext context) {
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
  }
}
