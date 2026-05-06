import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

import "../../onboarding/widgets/setup_colors.dart";

abstract final class OreTypography {
  static TextStyle heroH1({Color? color}) => GoogleFonts.fraunces(
        fontSize: 42,
        fontWeight: FontWeight.w600,
        height: 1.03,
        color: color ?? SetupColors.white,
      );

  static TextStyle heroH2({Color? color}) => GoogleFonts.fraunces(
        fontSize: 30,
        fontWeight: FontWeight.w600,
        height: 1.08,
        color: color ?? SetupColors.white,
      );

  static TextStyle eyebrow({Color? color}) => GoogleFonts.nunito(
        fontSize: 11,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.7,
        color: color ?? SetupColors.white.withValues(alpha: 0.7),
      );

  static TextStyle body({Color? color}) => GoogleFonts.nunito(
        fontSize: 15.5,
        fontWeight: FontWeight.w600,
        height: 1.45,
        color: color ?? SetupColors.white.withValues(alpha: 0.78),
      );

  static TextStyle button({Color? color}) => GoogleFonts.nunito(
        fontSize: 15.5,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.6,
        color: color ?? SetupColors.white,
      );
}

