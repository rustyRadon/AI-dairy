import "package:shared_preferences/shared_preferences.dart";

enum NoiseFilter {
  unfinishedTasks,
  scatteredIdeas,
  fearOfForgetting,
  lackOfAPlan,
}

enum EnergyMap {
  earlyMorning,
  lateNight,
  afterAWalk,
}

enum ConversationStyle {
  stoic,
  muse,
  hypeMan,
}

enum InterruptionLevel {
  justListen,
  interruptAndChallenge,
}

class OnboardingState {
  OnboardingState({
    required this.nickname,
    required this.email,
    this.website,
    this.instagram,
    this.xHandle,
    Set<NoiseFilter>? noiseFilters,
    Set<EnergyMap>? energyMaps,
    this.conversationStyle,
    this.interruptionLevel,
    this.zkEnabled = true,
    this.calendarGranted = false,
    this.microphoneGranted = false,
  })  : noiseFilters = noiseFilters ?? {},
        energyMaps = energyMaps ?? {};

  final String nickname;
  final String email;

  final String? website;
  final String? instagram;
  final String? xHandle;

  final Set<NoiseFilter> noiseFilters;
  final Set<EnergyMap> energyMaps;

  final ConversationStyle? conversationStyle;
  final InterruptionLevel? interruptionLevel;

  final bool zkEnabled;
  final bool calendarGranted;
  final bool microphoneGranted;

  OnboardingState copyWith({
    String? nickname,
    String? email,
    String? website,
    String? instagram,
    String? xHandle,
    Set<NoiseFilter>? noiseFilters,
    Set<EnergyMap>? energyMaps,
    ConversationStyle? conversationStyle,
    InterruptionLevel? interruptionLevel,
    bool? zkEnabled,
    bool? calendarGranted,
    bool? microphoneGranted,
  }) {
    return OnboardingState(
      nickname: nickname ?? this.nickname,
      email: email ?? this.email,
      website: website ?? this.website,
      instagram: instagram ?? this.instagram,
      xHandle: xHandle ?? this.xHandle,
      noiseFilters: noiseFilters ?? this.noiseFilters,
      energyMaps: energyMaps ?? this.energyMaps,
      conversationStyle: conversationStyle ?? this.conversationStyle,
      interruptionLevel: interruptionLevel ?? this.interruptionLevel,
      zkEnabled: zkEnabled ?? this.zkEnabled,
      calendarGranted: calendarGranted ?? this.calendarGranted,
      microphoneGranted: microphoneGranted ?? this.microphoneGranted,
    );
  }
}

class OnboardingPrefs {
  static const _kNoiseList = "onboarding.noiseFilters";
  static const _kEnergyList = "onboarding.energyMaps";
  static const _kStyle = "onboarding.conversationStyle";
  static const _kInterrupt = "onboarding.interruptionLevel";
  static const _kZk = "onboarding.zkEnabled";
  static const _kCalGranted = "onboarding.calendarGranted";
  static const _kMicGranted = "onboarding.microphoneGranted";

  static Future<void> save(OnboardingState s) async {
    final p = await SharedPreferences.getInstance();
    await p.setStringList(_kNoiseList, s.noiseFilters.map((e) => e.name).toList());
    await p.setStringList(_kEnergyList, s.energyMaps.map((e) => e.name).toList());
    if (s.conversationStyle != null) await p.setString(_kStyle, s.conversationStyle!.name);
    if (s.interruptionLevel != null) await p.setString(_kInterrupt, s.interruptionLevel!.name);
    await p.setBool(_kZk, s.zkEnabled);
    await p.setBool(_kCalGranted, s.calendarGranted);
    await p.setBool(_kMicGranted, s.microphoneGranted);
  }
}

