import "package:flutter/material.dart";

/// Brand palette from landing: cream, black, white + yellow, green, red accents.
abstract final class SetupColors {
  static const Color cream = Color(0xFFF5EFE4);
  static const Color creamMuted = Color(0xFFEBE4D6);
  static const Color ink = Color(0xFF121212);
  static const Color white = Color(0xFFFFFFFF);

  // Backgrounds (dark-first for app, cream for paper surfaces)
  static const Color bgBlack = Color(0xFF07070B);
  static const Color bgBlackSoft = Color(0xFF0C0C12);

  static const Color accentYellow = Color(0xFFE4C56C);
  static const Color accentGreen = Color(0xFF3D6B54);
  static const Color accentRed = Color(0xFFC44B43);

  /// Calm “on/active” accent for toggles (replaces amber warning cue on switches).
  static const Color peaceTeal = Color(0xFF0D9488);

  /// Dark surfaces (fields, primary buttons on light bg).
  static const Color surfaceDark = Color(0xFF1C1C1C);
  static const Color nicknameFieldBg = surfaceDark;
  static const Color nicknameHint = Color(0xFF8E8E8E);

  /// Legacy name used across screens; maps to cream.
  static const Color cardBlue = cream;

  /// Legacy; warm highlight strip (PIN step accent, etc.).
  static const Color warmYellow = accentYellow;
}
