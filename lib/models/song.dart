import 'package:json_annotation/json_annotation.dart';
import 'link.dart';
import 'beat_mode.dart';
import 'section.dart';

part 'song.g.dart';

// Sentinel value to detect if a parameter was passed to copyWith
const Object _sentinel = _Sentinel();

class _Sentinel {
  const _Sentinel();
  @override
  String toString() => '_sentinel';
}

/// Song model for the metronome app.
///
/// Represents a musical song with metadata, metronome settings,
/// and optional song structure sections. Supports both personal
/// and band-shared songs with contribution tracking.
///
/// Example usage:
/// ```dart
/// final song = Song(
///   id: 'song123',
///   title: 'Wonderwall',
///   artist: 'Oasis',
///   ourBPM: 87,
///   accentBeats: 4,
///   regularBeats: 1,
///   createdAt: DateTime.now(),
///   updatedAt: DateTime.now(),
/// );
/// ```
@JsonSerializable()
class Song {
  /// Unique identifier for the song.
  @JsonKey(defaultValue: '')
  final String id;

  /// Song title.
  @JsonKey(defaultValue: '')
  final String title;

  /// Artist or band name.
  @JsonKey(defaultValue: '')
  final String artist;

  /// Original musical key (e.g., 'C', 'Gm', 'Eb').
  final String? originalKey;

  /// Original tempo in beats per minute.
  final int? originalBPM;

  /// Performance key used by the band (may differ from original).
  final String? ourKey;

  /// Performance tempo used by the band (may differ from original).
  final int? ourBPM;

  /// External resource links (YouTube, Spotify, etc.).
  @JsonKey(defaultValue: [], fromJson: _linksFromJson, toJson: _linksToJson)
  final List<Link> links;

  /// Performance notes and instructions.
  final String? notes;

  /// Tags for organization and filtering.
  @JsonKey(defaultValue: [])
  final List<String> tags;

  /// ID of the band this song belongs to (null for personal songs).
  final String? bandId;

  /// Spotify URL for the song.
  final String? spotifyUrl;

  /// Creation timestamp.
  @JsonKey(fromJson: _parseDateTime, toJson: _dateTimeToJson)
  final DateTime createdAt;

  /// Last update timestamp.
  @JsonKey(fromJson: _parseDateTime, toJson: _dateTimeToJson)
  final DateTime updatedAt;

  // NEW: Sharing fields for copying songs from personal banks to band banks
  /// User ID who created the original song.
  final String? originalOwnerId;

  /// ID of the original personal song (for comparison and deduplication).
  final String? originalSongId;

  /// Display name of user who contributed this song to the band.
  final String? contributedBy;

  /// Whether this is a copy of an original personal song.
  @JsonKey(defaultValue: false)
  final bool isCopy;

  /// Timestamp when the song was contributed to the band.
  @JsonKey(fromJson: _parseNullableDateTime, toJson: _dateTimeToJson)
  final DateTime? contributedAt;

  // Metronome settings
  /// Beats per measure (top number of time signature).
  @JsonKey(defaultValue: 4)
  final int accentBeats;

  /// Subdivisions per beat (bottom number of time signature).
  @JsonKey(defaultValue: 1)
  final int regularBeats;

  /// 2D grid of beat modes for individual beat customization.
  @JsonKey(
    defaultValue: [],
    fromJson: _beatModesFromJson,
    toJson: _beatModesToJson,
  )
  final List<List<BeatMode>> beatModes;

  /// Song structure sections (Verse, Chorus, Bridge, etc.).
  @JsonKey(
    defaultValue: [],
    fromJson: _sectionsFromJson,
    toJson: _sectionsToJson,
  )
  final List<Section> sections;

  // ============================================================
  // MATCHING & EXTERNAL IDS (for song deduplication and APIs)
  // ============================================================

  /// Spotify track ID for cross-referencing.
  final String? spotifyId;

  /// MusicBrainz recording ID for cross-referencing.
  final String? musicbrainzId;

  /// International Standard Recording Code.
  final String? isrc;

  /// Deezer track ID for cross-referencing.
  final String? deezerId;

  /// Normalized title for faster search and matching.
  final String? normalizedTitle;

  /// Normalized artist name for faster search and matching.
  final String? normalizedArtist;

  /// Soundex phonetic code for title (sound-alike matching).
  final String? titleSoundex;

  /// Soundex phonetic code for artist (sound-alike matching).
  final String? artistSoundex;

  /// Duration in milliseconds (for matching and display).
  final int? durationMs;

  /// Album name (for matching and organization).
  final String? album;

  /// Variant type: 'original', 'live', 'acoustic', 'remix', etc.
  final String? variantType;

  /// ID of original song if this is a variant.
  final String? variantOf;

  /// Creates a new [Song] with the specified values.
  Song({
    required this.id,
    required this.title,
    required this.artist,
    this.originalKey,
    this.originalBPM,
    this.ourKey,
    this.ourBPM,
    this.links = const [],
    this.notes,
    this.tags = const [],
    this.bandId,
    this.spotifyUrl,
    required this.createdAt,
    required this.updatedAt,
    this.originalOwnerId,
    this.originalSongId,
    this.contributedBy,
    this.isCopy = false,
    this.contributedAt,
    this.accentBeats = 4,
    this.regularBeats = 1,
    this.beatModes = const [],
    this.sections = const [],
    this.spotifyId,
    this.musicbrainzId,
    this.isrc,
    this.deezerId,
    this.normalizedTitle,
    this.normalizedArtist,
    this.titleSoundex,
    this.artistSoundex,
    this.durationMs,
    this.album,
    this.variantType,
    this.variantOf,
  });

  Song copyWith({
    String? id,
    String? title,
    String? artist,
    Object? originalKey = _sentinel,
    Object? originalBPM = _sentinel,
    Object? ourKey = _sentinel,
    Object? ourBPM = _sentinel,
    List<Link>? links,
    Object? notes = _sentinel,
    List<String>? tags,
    Object? bandId = _sentinel,
    Object? spotifyUrl = _sentinel,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? originalOwnerId = _sentinel,
    Object? originalSongId = _sentinel,
    Object? contributedBy = _sentinel,
    Object? isCopy = _sentinel,
    Object? contributedAt = _sentinel,
    int? accentBeats,
    int? regularBeats,
    List<List<BeatMode>>? beatModes,
    List<Section>? sections,
    Object? spotifyId = _sentinel,
    Object? musicbrainzId = _sentinel,
    Object? isrc = _sentinel,
    Object? deezerId = _sentinel,
    Object? normalizedTitle = _sentinel,
    Object? normalizedArtist = _sentinel,
    Object? titleSoundex = _sentinel,
    Object? artistSoundex = _sentinel,
    Object? durationMs = _sentinel,
    Object? album = _sentinel,
    Object? variantType = _sentinel,
    Object? variantOf = _sentinel,
  }) {
    return Song(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      originalKey: originalKey == _sentinel
          ? this.originalKey
          : originalKey as String?,
      originalBPM: originalBPM == _sentinel
          ? this.originalBPM
          : originalBPM as int?,
      ourKey: ourKey == _sentinel ? this.ourKey : ourKey as String?,
      ourBPM: ourBPM == _sentinel ? this.ourBPM : ourBPM as int?,
      links: links ?? this.links,
      notes: notes == _sentinel ? this.notes : notes as String?,
      tags: tags ?? this.tags,
      bandId: bandId == _sentinel ? this.bandId : bandId as String?,
      spotifyUrl: spotifyUrl == _sentinel
          ? this.spotifyUrl
          : spotifyUrl as String?,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      originalOwnerId: originalOwnerId == _sentinel
          ? this.originalOwnerId
          : originalOwnerId as String?,
      originalSongId: originalSongId == _sentinel
          ? this.originalSongId
          : originalSongId as String?,
      contributedBy: contributedBy == _sentinel
          ? this.contributedBy
          : contributedBy as String?,
      isCopy: isCopy == _sentinel ? this.isCopy : isCopy as bool,
      contributedAt: contributedAt == _sentinel
          ? this.contributedAt
          : contributedAt as DateTime?,
      accentBeats: accentBeats ?? this.accentBeats,
      regularBeats: regularBeats ?? this.regularBeats,
      beatModes: beatModes ?? this.beatModes,
      sections: sections ?? this.sections,
      spotifyId: spotifyId == _sentinel ? this.spotifyId : spotifyId as String?,
      musicbrainzId: musicbrainzId == _sentinel
          ? this.musicbrainzId
          : musicbrainzId as String?,
      isrc: isrc == _sentinel ? this.isrc : isrc as String?,
      deezerId: deezerId == _sentinel ? this.deezerId : deezerId as String?,
      normalizedTitle: normalizedTitle == _sentinel
          ? this.normalizedTitle
          : normalizedTitle as String?,
      normalizedArtist: normalizedArtist == _sentinel
          ? this.normalizedArtist
          : normalizedArtist as String?,
      titleSoundex: titleSoundex == _sentinel
          ? this.titleSoundex
          : titleSoundex as String?,
      artistSoundex: artistSoundex == _sentinel
          ? this.artistSoundex
          : artistSoundex as String?,
      durationMs: durationMs == _sentinel
          ? this.durationMs
          : durationMs as int?,
      album: album == _sentinel ? this.album : album as String?,
      variantType: variantType == _sentinel
          ? this.variantType
          : variantType as String?,
      variantOf: variantOf == _sentinel ? this.variantOf : variantOf as String?,
    );
  }

  /// Converts this song to JSON format.
  ///
  /// Used for serializing to Firestore.
  Map<String, dynamic> toJson() => _$SongToJson(this);

  /// Creates a [Song] from JSON data.
  ///
  /// Used for deserializing Firestore documents.
  factory Song.fromJson(Map<String, dynamic> json) => _$SongFromJson(json);
}

// Helper methods for BeatMode serialization
List<List<BeatMode>> _beatModesFromJson(dynamic value) {
  if (value == null) return [];

  // Support both nested arrays (legacy) and map format (new)
  if (value is List) {
    return value.map((beatRow) {
      if (beatRow is List) {
        return beatRow.map((modeValue) {
          if (modeValue is String) {
            return BeatMode.values.firstWhere(
              (mode) => mode.name == modeValue,
              orElse: () => BeatMode.normal,
            );
          }
          return BeatMode.normal;
        }).toList();
      }
      return <BeatMode>[];
    }).toList();
  }

  // Support map format: {"0-0": "accent", "0-1": "normal", ...}
  if (value is Map) {
    // Return empty list if map is empty
    if (value.isEmpty) return [];
    
    final result = <List<BeatMode>>[];

    // Find max dimensions
    int maxBeat = 0;
    int maxSubdivision = 0;
    value.forEach((key, modeValue) {
      final parts = key.toString().split('-');
      if (parts.length == 2) {
        final beat = int.tryParse(parts[0]) ?? 0;
        final subdivision = int.tryParse(parts[1]) ?? 0;
        if (beat > maxBeat) maxBeat = beat;
        if (subdivision > maxSubdivision) maxSubdivision = subdivision;
      }
    });

    // Initialize grid
    for (int i = 0; i <= maxBeat; i++) {
      final row = <BeatMode>[];
      for (int j = 0; j <= maxSubdivision; j++) {
        row.add(BeatMode.normal);
      }
      result.add(row);
    }

    // Fill values
    value.forEach((key, modeValue) {
      final parts = key.toString().split('-');
      if (parts.length == 2) {
        final beat = int.tryParse(parts[0]) ?? 0;
        final subdivision = int.tryParse(parts[1]) ?? 0;
        if (beat < result.length && subdivision < result[beat].length) {
          result[beat][subdivision] = BeatMode.values.firstWhere(
            (mode) => mode.name == modeValue,
            orElse: () => BeatMode.normal,
          );
        }
      }
    });

    return result;
  }

  return [];
}

Map<String, String> _beatModesToJson(List<List<BeatMode>> value) {
  final result = <String, String>{};
  for (int i = 0; i < value.length; i++) {
    for (int j = 0; j < value[i].length; j++) {
      result['$i-$j'] = value[i][j].name;
    }
  }
  return result;
}

DateTime _parseDateTime(dynamic value) {
  if (value == null) return DateTime.now();
  if (value is DateTime) return value;
  return DateTime.parse(value as String);
}

DateTime? _parseNullableDateTime(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  return DateTime.parse(value as String);
}

String? _dateTimeToJson(DateTime? value) => value?.toIso8601String();

List<Link> _linksFromJson(dynamic value) {
  if (value == null) return [];
  if (value is List<Link>) return value;
  return (value as List<dynamic>)
      .map((e) => Link.fromJson(e as Map<String, dynamic>))
      .toList();
}

List<Map<String, dynamic>> _linksToJson(List<Link> links) {
  return links.map((l) => l.toJson()).toList();
}

List<Section> _sectionsFromJson(dynamic value) {
  if (value == null) return [];
  if (value is List<Section>) return value;
  return (value as List<dynamic>)
      .map((e) => Section.fromJson(e as Map<String, dynamic>))
      .toList();
}

List<Map<String, dynamic>> _sectionsToJson(List<Section> sections) {
  return sections.map((s) => s.toJson()).toList();
}
