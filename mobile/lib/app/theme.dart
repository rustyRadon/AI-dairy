import "package:flutter/material.dart";

import "../onboarding/widgets/setup_colors.dart";

ThemeData buildLightTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: SetupColors.ink,
    brightness: Brightness.light,
    // Keep content black-on-white, use brand accents for action.
    primary: SetupColors.ink,
    onPrimary: SetupColors.white,
    // Accent hierarchy for light mode:
    // - primary accent: yellow (highlights)
    // - secondary accent: green (supporting)
    secondary: SetupColors.accentYellow,
    onSecondary: SetupColors.ink,
    tertiary: SetupColors.accentGreen,
    onTertiary: SetupColors.white,
    error: SetupColors.accentRed,
    surface: SetupColors.white,
    onSurface: SetupColors.ink,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: SetupColors.cream,
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: SetupColors.accentYellow,
        foregroundColor: SetupColors.ink,
        shape: const StadiumBorder(),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: SetupColors.ink,
        side: BorderSide(color: SetupColors.ink.withValues(alpha: 0.14)),
        shape: const StadiumBorder(),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return SetupColors.white;
        return SetupColors.ink.withValues(alpha: 0.40);
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return SetupColors.peaceTeal;
        return SetupColors.ink.withValues(alpha: 0.20);
      }),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: SetupColors.white,
      indicatorColor: SetupColors.ink.withValues(alpha: 0.08),
      iconTheme: WidgetStatePropertyAll(
        IconThemeData(color: SetupColors.ink.withValues(alpha: 0.85)),
      ),
    ),
    textTheme: const TextTheme(
      headlineSmall: TextStyle(fontWeight: FontWeight.w700),
      bodyMedium: TextStyle(),
    ).apply(bodyColor: SetupColors.ink, displayColor: SetupColors.ink),
  );
}

ThemeData buildDarkTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: SetupColors.ink,
    brightness: Brightness.dark,
    primary: SetupColors.bgBlack,
    onPrimary: SetupColors.white,
    secondary: SetupColors.accentGreen,
    tertiary: SetupColors.accentYellow,
    error: SetupColors.accentRed,
    surface: SetupColors.bgBlack,
    onSurface: SetupColors.white,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: SetupColors.bgBlack,
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return SetupColors.white;
        return SetupColors.white.withValues(alpha: 0.45);
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return SetupColors.peaceTeal.withValues(alpha: 0.85);
        }
        return SetupColors.white.withValues(alpha: 0.22);
      }),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: SetupColors.bgBlack,
      indicatorColor: SetupColors.white.withValues(alpha: 0.16),
      iconTheme: WidgetStatePropertyAll(
        IconThemeData(color: SetupColors.white.withValues(alpha: 0.92)),
      ),
    ),
    textTheme: const TextTheme(
      headlineSmall: TextStyle(fontWeight: FontWeight.w700),
      bodyMedium: TextStyle(),
    ).apply(bodyColor: SetupColors.white, displayColor: SetupColors.white),
  );
}
