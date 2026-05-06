import "dart:ui";

import "package:flutter/material.dart";

import "../../onboarding/widgets/setup_colors.dart";
import "ore_gradients.dart";

class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.borderRadius = const BorderRadius.all(Radius.circular(22)),
    this.blurSigma = 18,
    this.tint,
    this.strokeGradient,
  });

  final Widget child;
  final EdgeInsets padding;
  final BorderRadius borderRadius;
  final double blurSigma;
  final Color? tint;
  final Gradient? strokeGradient;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isLight = Theme.of(context).brightness == Brightness.light;

    final baseTint = tint ?? (isLight ? cs.surfaceContainerHighest : SetupColors.white);
    final bg = baseTint.withValues(alpha: isLight ? 0.72 : 0.10);
    final border = cs.onSurface.withValues(alpha: isLight ? 0.10 : 0.12);
    final stroke = strokeGradient ?? (isLight ? null : OreGradients.glassStroke);

    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: borderRadius,
            border: Border.all(color: border),
          ),
          child: stroke == null
              ? Padding(padding: padding, child: child)
              : CustomPaint(
                  painter: _GlassStrokePainter(
                    borderRadius: borderRadius,
                    gradient: stroke,
                  ),
                  child: Padding(padding: padding, child: child),
                ),
        ),
      ),
    );
  }
}

class _GlassStrokePainter extends CustomPainter {
  _GlassStrokePainter({required this.borderRadius, required this.gradient});

  final BorderRadius borderRadius;
  final Gradient gradient;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = borderRadius.toRRect(rect);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..shader = gradient.createShader(rect);
    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant _GlassStrokePainter oldDelegate) => false;
}

