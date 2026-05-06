import "dart:math";
import "dart:ui";

import "package:flutter/material.dart";

import "../../onboarding/widgets/setup_colors.dart";
import "ore_gradients.dart";

class OreBackground extends StatefulWidget {
  const OreBackground({
    super.key,
    required this.child,
    this.baseColor = SetupColors.bgBlack,
    this.enableMotion = true,
  });

  final Widget child;
  final Color baseColor;
  final bool enableMotion;

  @override
  State<OreBackground> createState() => _OreBackgroundState();
}

class _OreBackgroundState extends State<OreBackground> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 5200),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations || !widget.enableMotion;
    if (reduceMotion) {
      return _StaticOreBackground(baseColor: widget.baseColor, child: widget.child);
    }

    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final t = _c.value;
        return _StaticOreBackground(
          baseColor: widget.baseColor,
          blobPhase: t,
          child: widget.child,
        );
      },
    );
  }
}

class _StaticOreBackground extends StatelessWidget {
  const _StaticOreBackground({
    required this.baseColor,
    required this.child,
    this.blobPhase,
  });

  final Color baseColor;
  final Widget child;
  final double? blobPhase;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: baseColor),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Dark hero wash (landing-like)
          Opacity(
            opacity: 0.55,
            child: DecoratedBox(
              decoration: const BoxDecoration(gradient: OreGradients.heroWash),
            ),
          ),

          // Blurred accent blobs.
          CustomPaint(
            painter: _BlobPainter(t: blobPhase ?? 0),
          ),

          // Subtle dot/grain overlay.
          IgnorePointer(
            child: CustomPaint(
              painter: const _TexturePainter(),
            ),
          ),

          child,
        ],
      ),
    );
  }
}

class _BlobPainter extends CustomPainter {
  _BlobPainter({required this.t});
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final r = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.saveLayer(r, Paint());

    final p = Paint()..blendMode = BlendMode.screen;

    void blob({
      required Color color,
      required double cx,
      required double cy,
      required double radius,
      required double alpha,
    }) {
      final center = Offset(cx, cy);
      p.shader = RadialGradient(
        colors: [
          color.withValues(alpha: alpha),
          color.withValues(alpha: 0),
        ],
        stops: const [0, 1],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
      canvas.drawCircle(center, radius, p);
    }

    final w = size.width;
    final h = size.height;
    final wobble = (sin(t * 2 * pi) * 0.5 + 0.5);
    final wobble2 = (cos((t * 2 * pi) + 1.3) * 0.5 + 0.5);

    blob(
      color: SetupColors.accentYellow,
      cx: w * (0.15 + 0.12 * wobble),
      cy: h * (0.18 + 0.10 * wobble2),
      radius: min(w, h) * (0.55 + 0.08 * wobble2),
      alpha: 0.24,
    );
    blob(
      color: SetupColors.accentGreen,
      cx: w * (0.78 - 0.10 * wobble2),
      cy: h * (0.32 + 0.12 * wobble),
      radius: min(w, h) * (0.58 + 0.10 * wobble),
      alpha: 0.20,
    );
    blob(
      color: SetupColors.accentRed,
      cx: w * (0.62 + 0.10 * wobble),
      cy: h * (0.86 - 0.12 * wobble2),
      radius: min(w, h) * (0.62 + 0.08 * wobble2),
      alpha: 0.17,
    );

    // Blur the blobs for that dreamy glow.
    canvas.saveLayer(r, Paint()..imageFilter = ImageFilter.blur(sigmaX: 44, sigmaY: 44));
    canvas.restore();

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _BlobPainter oldDelegate) => oldDelegate.t != t;
}

class _TexturePainter extends CustomPainter {
  const _TexturePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final dot = Paint()..color = SetupColors.white.withValues(alpha: 0.07);
    const step = 22.0;
    for (var y = 0.0; y < size.height; y += step) {
      for (var x = 0.0; x < size.width; x += step) {
        canvas.drawCircle(Offset(x + 6, y + 6), 1.1, dot);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

