import "package:flutter/material.dart";

import "../onboarding/widgets/setup_colors.dart";
import "../shared/ui/glass_card.dart";

/// Sub-labels at 60% opacity (peace hierarchy).
TextStyle settingsSubtextStyle(BuildContext context) {
  return TextStyle(
    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
    fontWeight: FontWeight.w600,
    height: 1.3,
  );
}

class SettingsSectionHeader extends StatelessWidget {
  const SettingsSectionHeader({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final on = Theme.of(context).colorScheme.onSurface;
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 20, 4, 8),
      child: Text(
        title,
        style: TextStyle(
          color: on.withValues(alpha: 0.55),
          fontWeight: FontWeight.w800,
          fontSize: 13,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

/// Standard settings surface — soft 28px radius.
class SettingsSoftCard extends StatelessWidget {
  const SettingsSoftCard({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(28),
        border: isLight
            ? Border.all(color: cs.onSurface.withValues(alpha: 0.08))
            : Border.all(color: cs.onSurface.withValues(alpha: 0.1)),
      ),
      child: DefaultTextStyle.merge(
        style: TextStyle(color: cs.onSurface),
        child: child,
      ),
    );
  }
}

/// Vault: stronger frost + slightly deeper tint vs preferences.
class SettingsVaultPanel extends StatelessWidget {
  const SettingsVaultPanel({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return GlassCard(
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(28),
      blurSigma: 22,
      tint: isLight ? SetupColors.creamMuted : SetupColors.bgBlackSoft,
      child: child,
    );
  }
}

class SettingsTileNav extends StatelessWidget {
  const SettingsTileNav({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final on = Theme.of(context).colorScheme.onSurface;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 6),
                    Text(subtitle, style: settingsSubtextStyle(context)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: on.withValues(alpha: 0.38)),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsTileSwitch extends StatelessWidget {
  const SettingsTileSwitch({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              Text(subtitle, style: settingsSubtextStyle(context)),
            ],
          ),
        ),
        Switch.adaptive(value: value, onChanged: onChanged),
      ],
    );
  }
}
