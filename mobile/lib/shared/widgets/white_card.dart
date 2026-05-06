import "package:flutter/material.dart";

class WhiteCard extends StatelessWidget {
  const WhiteCard({super.key, this.height, this.child});
  final double? height;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Container(
      height: height,
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
        border: isLight
            ? Border.all(color: cs.onSurface.withValues(alpha: 0.08))
            : null,
      ),
      child: DefaultTextStyle.merge(
        style: TextStyle(color: cs.onSurface),
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}

