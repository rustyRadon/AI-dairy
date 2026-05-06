import "package:flutter/material.dart";

import "../../onboarding/widgets/setup_colors.dart";

abstract final class OreGradients {
  static const heroWash = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0F0F12),
      Color(0xFF1A1324),
      Color(0xFF121217),
    ],
    stops: [0.0, 0.55, 1.0],
  );

  static LinearGradient accentGlow(double t) {
    final a = (0.35 + 0.25 * t).clamp(0.0, 1.0);
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        SetupColors.accentYellow.withValues(alpha: a),
        SetupColors.accentGreen.withValues(alpha: a),
        SetupColors.accentRed.withValues(alpha: a),
      ],
    );
  }

  static const glassStroke = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x66FFFFFF),
      Color(0x22FFFFFF),
      Color(0x55FFFFFF),
    ],
  );
}

