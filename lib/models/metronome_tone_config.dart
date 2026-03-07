// Metronome tone configuration
// Defines frequencies for different beat types in the 2-step system

/// Beat type in metronome 2-step system
enum BeatType {
  /// Main beat (first beat of measure - always accented in pattern)
  main,
  
  /// Subdivision beat (regular beats within measure)
  sub,
  
  /// Divider beat (subdivision marker - for complex rhythms)
  divider,
}

/// Accent state for a beat
enum AccentState {
  /// Regular (normal volume/frequency)
  regular,
  
  /// Accented (higher frequency/volume)
  accent,
}

/// Tone configuration for metronome sounds
/// 
/// Allows users to customize frequencies for each beat type and accent state
class MetronomeToneConfig {
  /// Frequency for main beat, regular (Hz)
  final double mainRegularFreq;
  
  /// Frequency for main beat, accented (Hz)
  final double mainAccentFreq;
  
  /// Frequency for sub beat, regular (Hz)
  final double subRegularFreq;
  
  /// Frequency for sub beat, accented (Hz)
  final double subAccentFreq;
  
  /// Frequency for divider beat, regular (Hz)
  final double dividerRegularFreq;
  
  /// Frequency for divider beat, accented (Hz)
  final double dividerAccentFreq;
  
  /// Wave type ('sine', 'square', 'triangle', 'sawtooth')
  final String waveType;
  
  /// Volume (0.0 - 1.0)
  final double volume;
  
  /// Click duration in seconds
  final double clickDuration;

  const MetronomeToneConfig({
    this.mainRegularFreq = 1600.0,
    this.mainAccentFreq = 2060.0,
    this.subRegularFreq = 800.0,
    this.subAccentFreq = 1030.0,
    this.dividerRegularFreq = 1100.0,
    this.dividerAccentFreq = 1400.0,
    this.waveType = 'sine',
    this.volume = 0.75,
    this.clickDuration = 0.04,
  });

  /// Get frequency for a specific beat type and accent state
  double getFrequency(BeatType beatType, AccentState accent) {
    switch (beatType) {
      case BeatType.main:
        return accent == AccentState.accent
            ? mainAccentFreq
            : mainRegularFreq;
      case BeatType.sub:
        return accent == AccentState.accent
            ? subAccentFreq
            : subRegularFreq;
      case BeatType.divider:
        return accent == AccentState.accent
            ? dividerAccentFreq
            : dividerRegularFreq;
    }
  }

  /// Get both regular and accent frequencies for a beat type
  /// Returns (regularFreq, accentFreq) tuple
  (double, double) getFrequenciesForBeat(BeatType beatType) {
    switch (beatType) {
      case BeatType.main:
        return (mainRegularFreq, mainAccentFreq);
      case BeatType.sub:
        return (subRegularFreq, subAccentFreq);
      case BeatType.divider:
        return (dividerRegularFreq, dividerAccentFreq);
    }
  }

  /// Create a copy with modified fields
  MetronomeToneConfig copyWith({
    double? mainRegularFreq,
    double? mainAccentFreq,
    double? subRegularFreq,
    double? subAccentFreq,
    double? dividerRegularFreq,
    double? dividerAccentFreq,
    String? waveType,
    double? volume,
    double? clickDuration,
  }) {
    return MetronomeToneConfig(
      mainRegularFreq: mainRegularFreq ?? this.mainRegularFreq,
      mainAccentFreq: mainAccentFreq ?? this.mainAccentFreq,
      subRegularFreq: subRegularFreq ?? this.subRegularFreq,
      subAccentFreq: subAccentFreq ?? this.subAccentFreq,
      dividerRegularFreq: dividerRegularFreq ?? this.dividerRegularFreq,
      dividerAccentFreq: dividerAccentFreq ?? this.dividerAccentFreq,
      waveType: waveType ?? this.waveType,
      volume: volume ?? this.volume,
      clickDuration: clickDuration ?? this.clickDuration,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() => {
    'mainRegularFreq': mainRegularFreq,
    'mainAccentFreq': mainAccentFreq,
    'subRegularFreq': subRegularFreq,
    'subAccentFreq': subAccentFreq,
    'dividerRegularFreq': dividerRegularFreq,
    'dividerAccentFreq': dividerAccentFreq,
    'waveType': waveType,
    'volume': volume,
    'clickDuration': clickDuration,
  };

  /// Create from JSON
  factory MetronomeToneConfig.fromJson(Map<String, dynamic> json) {
    return MetronomeToneConfig(
      mainRegularFreq: json['mainRegularFreq'] as double? ?? 1600.0,
      mainAccentFreq: json['mainAccentFreq'] as double? ?? 2060.0,
      subRegularFreq: json['subRegularFreq'] as double? ?? 800.0,
      subAccentFreq: json['subAccentFreq'] as double? ?? 1030.0,
      dividerRegularFreq: json['dividerRegularFreq'] as double? ?? 1100.0,
      dividerAccentFreq: json['dividerAccentFreq'] as double? ?? 1400.0,
      waveType: json['waveType'] as String? ?? 'sine',
      volume: json['volume'] as double? ?? 0.75,
      clickDuration: json['clickDuration'] as double? ?? 0.04,
    );
  }

  /// Default preset: Classic (high-low contrast)
  static const classic = MetronomeToneConfig(
    mainRegularFreq: 1600.0,
    mainAccentFreq: 2060.0,
    subRegularFreq: 800.0,
    subAccentFreq: 1030.0,
    dividerRegularFreq: 1100.0,
    dividerAccentFreq: 1400.0,
  );

  /// Preset: Subtle (minimal frequency difference)
  static const subtle = MetronomeToneConfig(
    mainRegularFreq: 1200.0,
    mainAccentFreq: 1400.0,
    subRegularFreq: 1000.0,
    subAccentFreq: 1100.0,
    dividerRegularFreq: 1100.0,
    dividerAccentFreq: 1200.0,
  );

  /// Preset: Extreme (maximum contrast)
  static const extreme = MetronomeToneConfig(
    mainRegularFreq: 2000.0,
    mainAccentFreq: 3000.0,
    subRegularFreq: 500.0,
    subAccentFreq: 750.0,
    dividerRegularFreq: 1000.0,
    dividerAccentFreq: 1500.0,
  );

  /// Preset: Wood block (simulates wood block sound)
  static const woodBlock = MetronomeToneConfig(
    mainRegularFreq: 1800.0,
    mainAccentFreq: 2200.0,
    subRegularFreq: 900.0,
    subAccentFreq: 1200.0,
    waveType: 'square',
  );

  /// Preset: Electronic (synthetic sound)
  static const electronic = MetronomeToneConfig(
    mainRegularFreq: 1600.0,
    mainAccentFreq: 2060.0,
    subRegularFreq: 800.0,
    subAccentFreq: 1030.0,
    waveType: 'sawtooth',
  );
}
