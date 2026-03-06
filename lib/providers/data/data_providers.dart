import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/song.dart';
import '../../models/setlist.dart';

/// Provider for streaming user's songs.
///
/// In production, this connects to Firestore or another data source.
/// For testing, this can be overridden with mock data.
///
/// Example usage:
/// ```dart
/// // Watch songs stream
/// final songsAsync = ref.watch(songsProvider);
///
/// songsAsync.when(
///   data: (songs) => ListView.builder(...),
///   loading: () => CircularProgressIndicator(),
///   error: (e, _) => Text('Error: $e'),
/// );
/// ```
final songsProvider = StreamProvider<List<Song>>((ref) {
  // Default implementation returns empty stream
  // Override in production with actual data source
  return Stream.value([]);
});

/// Provider for streaming user's setlists.
///
/// In production, this connects to Firestore or another data source.
/// For testing, this can be overridden with mock data.
///
/// Example usage:
/// ```dart
/// // Watch setlists stream
/// final setlistsAsync = ref.watch(setlistsProvider);
/// ```
final setlistsProvider = StreamProvider<List<Setlist>>((ref) {
  // Default implementation returns empty stream
  // Override in production with actual data source
  return Stream.value([]);
});
