import "package:shared_preferences/shared_preferences.dart";

/// Persisted Ọ̀rẹ́ / settings state (theme lives in [ThemeController]).
class SettingsSnapshot {
  const SettingsSnapshot({
    required this.nickname,
    required this.voiceIndex,
    required this.conversationalStyle,
    required this.echoMemoryEnabled,
    required this.biometricLock,
    required this.incognitoNextSession,
    required this.dataRetentionDays,
    required this.calendarGoogleEnabled,
    required this.calendarOutlookEnabled,
    required this.dndEnabled,
    required this.dndStartMinutes,
    required this.dndEndMinutes,
    required this.hapticStrength,
    required this.soundEnabled,
    required this.motionEnabled,
  });

  final String nickname;
  final int voiceIndex;
  /// 0 listener, 1 balanced, 2 coach.
  final int conversationalStyle;
  final bool echoMemoryEnabled;
  final bool biometricLock;
  final bool incognitoNextSession;
  /// -1 = keep forever; else days e.g. 7, 30, 90.
  final int dataRetentionDays;
  final bool calendarGoogleEnabled;
  final bool calendarOutlookEnabled;
  final bool dndEnabled;
  final int dndStartMinutes;
  final int dndEndMinutes;
  /// 0 = off … 1 = strongest in UI.
  final double hapticStrength;
  final bool soundEnabled;
  final bool motionEnabled;

  static const defaults = SettingsSnapshot(
    nickname: "",
    voiceIndex: 0,
    conversationalStyle: 1,
    echoMemoryEnabled: true,
    biometricLock: false,
    incognitoNextSession: false,
    dataRetentionDays: 30,
    calendarGoogleEnabled: false,
    calendarOutlookEnabled: false,
    dndEnabled: true,
    dndStartMinutes: 22 * 60,
    dndEndMinutes: 8 * 60,
    hapticStrength: 0.55,
    soundEnabled: true,
    motionEnabled: true,
  );

  SettingsSnapshot copyWith({
    String? nickname,
    int? voiceIndex,
    int? conversationalStyle,
    bool? echoMemoryEnabled,
    bool? biometricLock,
    bool? incognitoNextSession,
    int? dataRetentionDays,
    bool? calendarGoogleEnabled,
    bool? calendarOutlookEnabled,
    bool? dndEnabled,
    int? dndStartMinutes,
    int? dndEndMinutes,
    double? hapticStrength,
    bool? soundEnabled,
    bool? motionEnabled,
  }) {
    return SettingsSnapshot(
      nickname: nickname ?? this.nickname,
      voiceIndex: voiceIndex ?? this.voiceIndex,
      conversationalStyle: conversationalStyle ?? this.conversationalStyle,
      echoMemoryEnabled: echoMemoryEnabled ?? this.echoMemoryEnabled,
      biometricLock: biometricLock ?? this.biometricLock,
      incognitoNextSession: incognitoNextSession ?? this.incognitoNextSession,
      dataRetentionDays: dataRetentionDays ?? this.dataRetentionDays,
      calendarGoogleEnabled: calendarGoogleEnabled ?? this.calendarGoogleEnabled,
      calendarOutlookEnabled: calendarOutlookEnabled ?? this.calendarOutlookEnabled,
      dndEnabled: dndEnabled ?? this.dndEnabled,
      dndStartMinutes: dndStartMinutes ?? this.dndStartMinutes,
      dndEndMinutes: dndEndMinutes ?? this.dndEndMinutes,
      hapticStrength: hapticStrength ?? this.hapticStrength,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      motionEnabled: motionEnabled ?? this.motionEnabled,
    );
  }
}

abstract final class SettingsPrefs {
  static const _nickname = "settings_nickname";
  static const _voiceIndex = "settings_voice_index";
  static const _convStyle = "settings_conv_style";
  static const _echoMemory = "settings_echo_memory";
  static const _biometric = "settings_biometric";
  static const _incognito = "settings_incognito_next";
  static const _retention = "settings_data_retention_days";
  static const _calGoogle = "settings_cal_google";
  static const _calOutlook = "settings_cal_outlook";
  static const _dnd = "settings_dnd_enabled";
  static const _dndStart = "settings_dnd_start_min";
  static const _dndEnd = "settings_dnd_end_min";
  static const _haptic = "settings_haptic_strength";
  static const _sound = "settings_sound";
  static const _motion = "settings_motion";

  static Future<SettingsSnapshot> load() async {
    final p = await SharedPreferences.getInstance();
    return SettingsSnapshot(
      nickname: p.getString(_nickname) ?? SettingsSnapshot.defaults.nickname,
      voiceIndex: p.getInt(_voiceIndex) ?? SettingsSnapshot.defaults.voiceIndex,
      conversationalStyle:
          p.getInt(_convStyle) ?? SettingsSnapshot.defaults.conversationalStyle,
      echoMemoryEnabled:
          p.getBool(_echoMemory) ?? SettingsSnapshot.defaults.echoMemoryEnabled,
      biometricLock: p.getBool(_biometric) ?? SettingsSnapshot.defaults.biometricLock,
      incognitoNextSession:
          p.getBool(_incognito) ?? SettingsSnapshot.defaults.incognitoNextSession,
      dataRetentionDays:
          p.getInt(_retention) ?? SettingsSnapshot.defaults.dataRetentionDays,
      calendarGoogleEnabled:
          p.getBool(_calGoogle) ?? SettingsSnapshot.defaults.calendarGoogleEnabled,
      calendarOutlookEnabled:
          p.getBool(_calOutlook) ?? SettingsSnapshot.defaults.calendarOutlookEnabled,
      dndEnabled: p.getBool(_dnd) ?? SettingsSnapshot.defaults.dndEnabled,
      dndStartMinutes:
          p.getInt(_dndStart) ?? SettingsSnapshot.defaults.dndStartMinutes,
      dndEndMinutes: p.getInt(_dndEnd) ?? SettingsSnapshot.defaults.dndEndMinutes,
      hapticStrength:
          p.getDouble(_haptic) ?? SettingsSnapshot.defaults.hapticStrength,
      soundEnabled: p.getBool(_sound) ?? SettingsSnapshot.defaults.soundEnabled,
      motionEnabled: p.getBool(_motion) ?? SettingsSnapshot.defaults.motionEnabled,
    );
  }

  static Future<void> save(SettingsSnapshot s) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_nickname, s.nickname);
    await p.setInt(_voiceIndex, s.voiceIndex);
    await p.setInt(_convStyle, s.conversationalStyle);
    await p.setBool(_echoMemory, s.echoMemoryEnabled);
    await p.setBool(_biometric, s.biometricLock);
    await p.setBool(_incognito, s.incognitoNextSession);
    await p.setInt(_retention, s.dataRetentionDays);
    await p.setBool(_calGoogle, s.calendarGoogleEnabled);
    await p.setBool(_calOutlook, s.calendarOutlookEnabled);
    await p.setBool(_dnd, s.dndEnabled);
    await p.setInt(_dndStart, s.dndStartMinutes);
    await p.setInt(_dndEnd, s.dndEndMinutes);
    await p.setDouble(_haptic, s.hapticStrength);
    await p.setBool(_sound, s.soundEnabled);
    await p.setBool(_motion, s.motionEnabled);
  }

  /// Clears Ọ̀rẹ́-related prefs. Does **not** clear theme (see [ThemeController]).
  static Future<void> wipeOreState() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(_nickname);
    await p.remove(_voiceIndex);
    await p.remove(_convStyle);
    await p.remove(_echoMemory);
    await p.remove(_biometric);
    await p.remove(_incognito);
    await p.remove(_retention);
    await p.remove(_calGoogle);
    await p.remove(_calOutlook);
    await p.remove(_dnd);
    await p.remove(_dndStart);
    await p.remove(_dndEnd);
    await p.remove(_haptic);
    await p.remove(_sound);
    await p.remove(_motion);
  }
}
