// Song Library Block widget - TEMPORARILY DISABLED
// Missing dependencies: data_providers.dart, error_banner.dart
// This file is kept for future integration but disabled for now

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/metronome_provider.dart';
import '../../theme/mono_pulse_theme.dart';

/// Song Library Block widget - Mono Pulse design
/// 
/// TEMPORARY: Simplified version without data providers
/// Will be fully implemented later with proper data layer
class SongLibraryBlock extends ConsumerStatefulWidget {
  const SongLibraryBlock({super.key});

  @override
  ConsumerState<SongLibraryBlock> createState() => _SongLibraryBlockState();
}

class _SongLibraryBlockState extends ConsumerState<SongLibraryBlock> {
  bool _isExpanded = false;
  bool _showSetlists = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(metronomeProvider);

    return Column(
      children: [
        // Compact pill button
        if (!_isExpanded)
          Semantics(
            label: 'Song Library. Tap to expand.',
            button: true,
            child: GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                setState(() => _isExpanded = true);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: MonoPulseColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: MonoPulseColors.borderSubtle),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.music_note_outlined,
                      color: MonoPulseColors.textSecondary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Song Library',
                      style: MonoPulseTypography.bodyLarge.copyWith(
                        color: MonoPulseColors.textHighEmphasis,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

        // Loaded content indicator
        if (!_isExpanded &&
            (state.loadedSong != null || state.loadedSetlist != null))
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Semantics(
              label: '${state.loadedSong?.title ?? state.loadedSetlist?.name ?? ""}. Tap to expand.',
              button: true,
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  setState(() => _isExpanded = true);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: MonoPulseColors.accentOrangeSubtle,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: MonoPulseColors.accentOrange),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        state.loadedSong != null
                            ? Icons.music_note
                            : Icons.playlist_play,
                        color: MonoPulseColors.accentOrange,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        state.loadedSong?.title ??
                            state.loadedSetlist?.name ??
                            '',
                        style: MonoPulseTypography.labelMedium.copyWith(
                          color: MonoPulseColors.accentOrange,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

        // Expanded view
        if (_isExpanded)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 16),
            decoration: BoxDecoration(
              color: MonoPulseColors.surfaceRaised,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: MonoPulseColors.borderDefault),
            ),
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Text(
                        _showSetlists ? 'Setlists' : 'Songs',
                        style: MonoPulseTypography.headlineSmall.copyWith(
                          color: MonoPulseColors.textHighEmphasis,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      // Toggle button
                      Semantics(
                        label: _showSetlists ? 'Show Songs' : 'Show Setlists',
                        button: true,
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            setState(() => _showSetlists = !_showSetlists);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: MonoPulseColors.surface,
                              borderRadius: BorderRadius.circular(12),
                              border:
                                  Border.all(color: MonoPulseColors.borderSubtle),
                            ),
                            child: Text(
                              _showSetlists ? 'Show Songs' : 'Show Setlists',
                              style: MonoPulseTypography.labelSmall.copyWith(
                                color: MonoPulseColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Close button
                      Semantics(
                        label: 'Close song library',
                        button: true,
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            setState(() => _isExpanded = false);
                          },
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: MonoPulseColors.surface,
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: MonoPulseColors.borderSubtle),
                            ),
                            child: const Icon(
                              Icons.close,
                              color: MonoPulseColors.textSecondary,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Content - TEMPORARY PLACEHOLDER
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Icon(
                        Icons.construction_outlined,
                        size: 48,
                        color: MonoPulseColors.textTertiary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Library integration coming soon',
                        style: MonoPulseTypography.bodyMedium.copyWith(
                          color: MonoPulseColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Song and setlist libraries will be available here',
                        style: MonoPulseTypography.bodySmall.copyWith(
                          color: MonoPulseColors.textTertiary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
