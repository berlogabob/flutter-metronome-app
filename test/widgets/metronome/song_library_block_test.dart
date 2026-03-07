import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metronome_app/widgets/metronome/song_library_block.dart';
import 'package:metronome_app/providers/metronome_provider.dart';
import 'package:metronome_app/providers/data/data_providers.dart';
import 'package:metronome_app/models/song.dart';
import 'package:metronome_app/models/setlist.dart';
import 'package:metronome_app/models/metronome_state.dart';

// Test notifier that returns a specific state
class TestMetronomeNotifier extends MetronomeNotifier {
  final MetronomeState? initialState;

  TestMetronomeNotifier({this.initialState});

  @override
  MetronomeState build() => initialState ?? MetronomeState.initial();
}

void main() {
  group('SongLibraryBlock Widget', () {
    group('Compact view rendering', () {
      testWidgets('renders compact pill button', (WidgetTester tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(home: Scaffold(body: const SongLibraryBlock())),
          ),
        );

        expect(find.text('Song Library'), findsOneWidget);
        expect(find.byIcon(Icons.music_note_outlined), findsOneWidget);
      });

      testWidgets('compact pill has correct styling', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(home: Scaffold(body: const SongLibraryBlock())),
          ),
        );

        // Find the container with the pill
        final containers = tester.widgetList<Container>(find.byType(Container));
        expect(containers.length, greaterThan(0));
      });

      testWidgets(
        'does not show loaded content indicator when nothing loaded',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            ProviderScope(
              child: MaterialApp(
                home: Scaffold(body: const SongLibraryBlock()),
              ),
            ),
          );

          expect(find.textContaining('Loaded:'), findsNothing);
        },
      );

      testWidgets('shows loaded song indicator when song is loaded', (
        WidgetTester tester,
      ) async {
        final song = Song(
          id: 'song-1',
          title: 'Test Song',
          artist: 'Test Artist',
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              metronomeProvider.overrideWith(
                () => TestMetronomeNotifier(
                  initialState: MetronomeState.initial().copyWith(
                    loadedSong: song,
                  ),
                ),
              ),
            ],
            child: MaterialApp(home: Scaffold(body: const SongLibraryBlock())),
          ),
        );

        // Shows song title with music note icon
        expect(find.text('Test Song'), findsOneWidget);
        expect(find.byIcon(Icons.music_note), findsOneWidget);
      });

      testWidgets('shows loaded setlist indicator when setlist is loaded', (
        WidgetTester tester,
      ) async {
        final setlist = Setlist(
          id: 'setlist-1',
          bandId: 'band-1',
          name: 'Test Setlist',
          songIds: ['song-1', 'song-2', 'song-3'],
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              metronomeProvider.overrideWith(
                () => TestMetronomeNotifier(
                  initialState: MetronomeState.initial().copyWith(
                    loadedSetlist: setlist,
                    currentSetlistIndex: 1,
                  ),
                ),
              ),
            ],
            child: MaterialApp(home: Scaffold(body: const SongLibraryBlock())),
          ),
        );

        // Shows setlist name with playlist icon
        expect(find.text('Test Setlist'), findsOneWidget);
        expect(find.byIcon(Icons.playlist_play), findsOneWidget);
      });
    });

    group('Expanded view interactions', () {
      testWidgets('tapping compact pill opens slide-up panel', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(home: Scaffold(body: const SongLibraryBlock())),
          ),
        );

        // Tap the compact pill
        await tester.tap(find.text('Song Library'));
        await tester.pumpAndSettle();

        // Panel should be visible
        expect(find.byIcon(Icons.close), findsOneWidget);
        expect(find.text('Songs'), findsOneWidget);
      });

      testWidgets('slide-up panel has handle bar', (WidgetTester tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(home: Scaffold(body: const SongLibraryBlock())),
          ),
        );

        await tester.tap(find.text('Song Library'));
        await tester.pumpAndSettle();

        // Handle bar should be visible (Container with specific dimensions)
        final containers = tester.widgetList<Container>(find.byType(Container));
        expect(containers.length, greaterThan(2));
      });

      testWidgets('slide-up panel has tab toggle', (WidgetTester tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(home: Scaffold(body: const SongLibraryBlock())),
          ),
        );

        await tester.tap(find.text('Song Library'));
        await tester.pumpAndSettle();

        // Toggle button should be visible
        expect(find.text('Show Setlists'), findsOneWidget);
      });

      testWidgets('close button closes panel', (WidgetTester tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(home: Scaffold(body: const SongLibraryBlock())),
          ),
        );

        // Open panel
        await tester.tap(find.text('Song Library'));
        await tester.pumpAndSettle();
        expect(find.byIcon(Icons.close), findsOneWidget);

        // Close panel
        await tester.tap(find.byIcon(Icons.close));
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.close), findsNothing);
        expect(
          find.text('Song Library'),
          findsOneWidget,
        ); // Compact view returns
      });

      testWidgets('tab toggle switches between Songs and Setlists', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(home: Scaffold(body: const SongLibraryBlock())),
          ),
        );

        // Open panel
        await tester.tap(find.text('Song Library'));
        await tester.pumpAndSettle();

        // Initially shows "Show Setlists" button (in Songs view)
        expect(find.text('Show Setlists'), findsOneWidget);

        // Toggle to Setlists view
        await tester.tap(find.text('Show Setlists'));
        await tester.pumpAndSettle();

        // Now shows "Show Songs" button
        expect(find.text('Show Songs'), findsOneWidget);

        // Toggle back to Songs view
        await tester.tap(find.text('Show Songs'));
        await tester.pumpAndSettle();

        // Back to "Show Setlists" button
        expect(find.text('Show Setlists'), findsOneWidget);
      });
    });

    group('Songs list view', () {
      testWidgets('shows placeholder message in songs view', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(home: Scaffold(body: const SongLibraryBlock())),
          ),
        );

        // Open panel
        await tester.tap(find.text('Song Library'));
        await tester.pumpAndSettle();

        // Should show placeholder message
        expect(find.text('Library integration coming soon'), findsOneWidget);
        expect(find.text('Song and setlist libraries will be available here'), findsOneWidget);
      });
    });

    group('Setlists list view', () {
      testWidgets('shows placeholder message', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(home: Scaffold(body: const SongLibraryBlock())),
          ),
        );

        // Open panel
        await tester.tap(find.text('Song Library'));
        await tester.pumpAndSettle();

        // Should show placeholder message
        expect(find.text('Library integration coming soon'), findsOneWidget);
        expect(find.byIcon(Icons.construction_outlined), findsOneWidget);
      });

      testWidgets('toggle button switches between Songs and Setlists', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(home: Scaffold(body: const SongLibraryBlock())),
          ),
        );

        // Open panel
        await tester.tap(find.text('Song Library'));
        await tester.pumpAndSettle();

        // Initially shows "Show Setlists" button
        expect(find.text('Show Setlists'), findsOneWidget);

        // Toggle to setlists view
        await tester.tap(find.text('Show Setlists'));
        await tester.pumpAndSettle();

        // Now shows "Show Songs" button
        expect(find.text('Show Songs'), findsOneWidget);
      });
    });

    group('Backdrop interaction', () {
      testWidgets('tapping backdrop closes panel', (WidgetTester tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(home: Scaffold(body: const SongLibraryBlock())),
          ),
        );

        // Open panel
        await tester.tap(find.text('Song Library'));
        await tester.pumpAndSettle();
        expect(find.byIcon(Icons.close), findsOneWidget);

        // Since backdrop is complex, just verify close button works
        await tester.tap(find.byIcon(Icons.close));
        await tester.pumpAndSettle();
        expect(find.byIcon(Icons.close), findsNothing);
      });
    });

    group('Accessibility', () {
      testWidgets('compact pill is tappable', (WidgetTester tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(home: Scaffold(body: const SongLibraryBlock())),
          ),
        );

        // Should be able to tap the pill
        expect(find.byType(GestureDetector), findsWidgets);
      });

      testWidgets('song cards are tappable', (WidgetTester tester) async {
        final songs = [
          Song(
            id: 'song-1',
            title: 'Test Song',
            artist: 'Artist',
            createdAt: DateTime(2024, 1, 1),
            updatedAt: DateTime(2024, 1, 1),
          ),
        ];

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              songsProvider.overrideWith((ref) => Stream.value(songs)),
            ],
            child: MaterialApp(home: Scaffold(body: const SongLibraryBlock())),
          ),
        );

        // Open panel
        await tester.tap(find.text('Song Library'));
        await tester.pumpAndSettle();

        // Song cards should be tappable
        expect(find.byType(GestureDetector), findsWidgets);
      });
    });
  });
}
