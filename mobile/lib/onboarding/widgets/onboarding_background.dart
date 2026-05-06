import "package:flutter/material.dart";

import "../../shared/ui/ore_background.dart";

class OnboardingBackground extends StatelessWidget {
  const OnboardingBackground({super.key, required this.color, required this.child});
  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return OreBackground(baseColor: color, child: child);
  }
}
