import "package:flutter/material.dart";

import "../../onboarding/widgets/setup_colors.dart";
import "ore_typography.dart";

class OrePrimaryButton extends StatelessWidget {
  const OrePrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: SetupColors.white,
          foregroundColor: SetupColors.ink,
          elevation: 0,
          shape: const StadiumBorder(),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: OreTypography.button(color: SetupColors.ink)),
            if (icon != null) ...[
              const SizedBox(width: 10),
              Icon(icon, size: 20),
            ],
          ],
        ),
      ),
    );
  }
}

class OreSecondaryButton extends StatelessWidget {
  const OreSecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: SetupColors.white,
          side: BorderSide(color: SetupColors.white.withValues(alpha: 0.35)),
          backgroundColor: SetupColors.white.withValues(alpha: 0.08),
          shape: const StadiumBorder(),
        ),
        onPressed: onPressed,
        child: Text(label, style: OreTypography.button(color: SetupColors.white.withValues(alpha: 0.92))),
      ),
    );
  }
}

