import "dart:math";
import "dart:ui";

import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

import "../shared/ui/glass_card.dart";
import "../shared/widgets/screen_frame.dart";
import "../onboarding/widgets/ore_avatar.dart";

class WeeklyMirrorScreen extends StatefulWidget {
  const WeeklyMirrorScreen({super.key, required this.userName});
  final String userName;

  @override
  State<WeeklyMirrorScreen> createState() => _WeeklyMirrorScreenState();
}

class _WeeklyMirrorScreenState extends State<WeeklyMirrorScreen> {
  _WaveFocus _focus = _WaveFocus.peace;

  // UI-only week model (0..1 where >0.5 is "peace").
  final List<_DayPoint> _week = const [
    _DayPoint(day: "Mon", score: 0.62),
    _DayPoint(day: "Tue", score: 0.44),
    _DayPoint(day: "Wed", score: 0.70),
    _DayPoint(day: "Thu", score: 0.38),
    _DayPoint(day: "Fri", score: 0.58),
    _DayPoint(day: "Sat", score: 0.74),
    _DayPoint(day: "Sun", score: 0.55),
  ];

  final List<String> _milestones = const [
    "Completed a 4‑hour deep work block",
    "Said no to one low‑value commitment",
    "Closed the week with a calm plan",
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ScreenFrame(
      title: "The Reflection",
      subtitle: "Look back at your week the kind way — no scary grades, just truth.",
      trailing: const SizedBox(width: 48),
      child: Stack(
        children: [
          const Positioned.fill(child: _FloatingOrbsBackground()),
          ListView(
            padding: const EdgeInsets.only(bottom: 16),
            children: [
              Text(
                "Peace vs. Chaos",
                style: TextStyle(
                  color: cs.onSurface.withValues(alpha: 0.90),
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 10),
              GlassCard(
                blurSigma: 14,
                padding: const EdgeInsets.all(0),
                child: SizedBox(
                  height: 176,
                  child: CustomPaint(
                    painter: _ReflectionWavePainter(
                      points: _week,
                      focus: _focus,
                      baseline: 0.5,
                      ink: cs.onSurface,
                      peace: cs.secondary,
                      chaos: cs.error,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  _StatPill(
                                    label: "Peace",
                                    value: "62%",
                                    selected: _focus == _WaveFocus.peace,
                                    onTap: () =>
                                        setState(() => _focus = _WaveFocus.peace),
                                  ),
                                  _StatPill(
                                    label: "Chaos",
                                    value: "38%",
                                    selected: _focus == _WaveFocus.chaos,
                                    onTap: () =>
                                        setState(() => _focus = _WaveFocus.chaos),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: _week
                                .map(
                                  (d) => Text(
                                    d.day,
                                    style: TextStyle(
                                      color: cs.onSurface.withValues(alpha: 0.78),
                                      fontWeight: FontWeight.w800,
                                      fontSize: 11,
                                    ),
                                  ),
                                )
                                .toList(growable: false),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                "Pal’s observation",
                style: TextStyle(
                  color: cs.onSurface.withValues(alpha: 0.90),
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 10),
              _ObservationLetter(
                text:
                    "I noticed you move faster after you name the one thing you’ve been carrying. When you say it, your next step becomes simple. This week, we’ll keep the first step small and gentle.",
              ),
              const SizedBox(height: 18),
              Text(
                "Weekly totals",
                style: TextStyle(
                  color: cs.onSurface.withValues(alpha: 0.90),
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 10),
              GlassCard(
                blurSigma: 14,
                child: Row(
                  children: [
                    Expanded(
                      child: _InlineStat(
                        label: "Time saved",
                        value: "1h 20m",
                        onInfo: () => _showHow(context),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 44,
                      color: cs.onSurface.withValues(alpha: 0.10),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: _InlineStat(
                        label: "Weights lifted",
                        value: "14",
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              GlassCard(
                blurSigma: 14,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Peace milestones",
                            style: TextStyle(
                              color: cs.onSurface.withValues(alpha: 0.70),
                              fontWeight: FontWeight.w700,
                              fontSize: 12.5,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _MilestoneStars(
                            count: _milestones.length,
                            onTap: () => _showMilestones(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showHow(BuildContext context) async {
    final cs = Theme.of(context).colorScheme;
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: cs.surface,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "How time saved is estimated",
                  style: TextStyle(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Based on actions Ọ̀rẹ́ handled for you this week — e.g., automated 14 calendar entries and quick summaries.",
                  style: TextStyle(
                    color: cs.onSurface.withValues(alpha: 0.78),
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showMilestones(BuildContext context) async {
    final cs = Theme.of(context).colorScheme;
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: cs.surface,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Peace milestones",
                  style: TextStyle(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                for (final m in _milestones) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.star_rounded,
                          color: cs.secondary.withValues(alpha: 0.85), size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          m,
                          style: TextStyle(
                            color: cs.onSurface.withValues(alpha: 0.80),
                            fontWeight: FontWeight.w600,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.label,
    required this.value,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final String value;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? cs.onSurface.withValues(alpha: 0.10)
              : cs.onSurface.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: cs.onSurface.withValues(alpha: selected ? 0.18 : 0.12),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: cs.onSurface.withValues(alpha: 0.72),
                fontWeight: FontWeight.w700,
                fontSize: 12.5,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              value,
              style: TextStyle(
                color: cs.onSurface.withValues(alpha: 0.92),
                fontWeight: FontWeight.w900,
                fontSize: 12.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InlineStat extends StatelessWidget {
  const _InlineStat({required this.label, required this.value, this.onInfo});
  final String label;
  final String value;
  final VoidCallback? onInfo;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                color: cs.onSurface.withValues(alpha: 0.70),
                fontWeight: FontWeight.w700,
                fontSize: 12.5,
              ),
            ),
            if (onInfo != null) ...[
              const SizedBox(width: 6),
              InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: onInfo,
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Icon(
                    Icons.info_outline_rounded,
                    size: 16,
                    color: cs.onSurface.withValues(alpha: 0.60),
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: cs.onSurface,
            fontWeight: FontWeight.w900,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}

class _MilestoneStars extends StatelessWidget {
  const _MilestoneStars({required this.count, required this.onTap});
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Row(
        children: List.generate(count, (i) {
          return Padding(
            padding: EdgeInsets.only(right: i == count - 1 ? 0 : 8),
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: cs.secondary.withValues(alpha: 0.14),
                border: Border.all(color: cs.secondary.withValues(alpha: 0.22)),
                boxShadow: [
                  BoxShadow(
                    color: cs.secondary.withValues(alpha: 0.18),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                Icons.star_rounded,
                color: cs.secondary.withValues(alpha: 0.90),
                size: 18,
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _ObservationLetter extends StatelessWidget {
  const _ObservationLetter({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final onBg = cs.onSurface;

    return GlassCard(
      blurSigma: 16,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: ClipOval(
              child: ColoredBox(
                color: onBg.withValues(alpha: 0.06),
                child: const Padding(
                  padding: EdgeInsets.all(6),
                  child: OreMascot(height: 18),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, right: 38),
            child: Text(
              text,
              style: GoogleFonts.lora(
                textStyle: TextStyle(
                  color: onBg.withValues(alpha: 0.86),
                  fontWeight: FontWeight.w500,
                  height: 1.45,
                  fontSize: 14.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingOrbsBackground extends StatelessWidget {
  const _FloatingOrbsBackground();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    // Orbs stay behind as you scroll (luxury depth).
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            left: -120,
            top: 110,
            child: _Orb(
              color: cs.tertiary,
              size: 260,
              alpha: 0.10,
            ),
          ),
          Positioned(
            right: -120,
            top: 170,
            child: _Orb(
              color: cs.secondary,
              size: 300,
              alpha: 0.10,
            ),
          ),
        ],
      ),
    );
  }
}

class _Orb extends StatelessWidget {
  const _Orb({required this.color, required this.size, required this.alpha});
  final Color color;
  final double size;
  final double alpha;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 48, sigmaY: 48),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withValues(alpha: alpha),
              color.withValues(alpha: 0),
            ],
          ),
        ),
      ),
    );
  }
}

enum _WaveFocus { peace, chaos }

class _DayPoint {
  const _DayPoint({required this.day, required this.score});
  final String day;
  final double score; // 0..1
}

class _ReflectionWavePainter extends CustomPainter {
  const _ReflectionWavePainter({
    required this.points,
    required this.focus,
    required this.baseline,
    required this.ink,
    required this.peace,
    required this.chaos,
  });

  final List<_DayPoint> points;
  final _WaveFocus focus;
  final double baseline;
  final Color ink;
  final Color peace;
  final Color chaos;

  @override
  void paint(Canvas canvas, Size size) {
    // Subtle background wash.
    final bg = Paint()..color = ink.withValues(alpha: 0.04);
    canvas.drawRect(Offset.zero & size, bg);

    final h = size.height;
    final w = size.width;
    final topPad = 12.0;
    final bottomPad = 28.0;
    final usable = h - topPad - bottomPad;

    Offset mapPoint(int i) {
      final x = (w * (i / (points.length - 1)));
      final s = points[i].score.clamp(0.0, 1.0);
      // 1.0 -> top (peace), 0.0 -> bottom (chaos).
      final y = topPad + ((1 - s) * usable);
      return Offset(x, y);
    }

    final pts = List.generate(points.length, mapPoint);

    // Baseline dotted line.
    final baseY = topPad + ((1 - baseline) * usable);

    // Two calm "zones": above baseline = faint sage, below = faint dusty rose.
    const sage = Color(0xFF9FB7A7);
    const rose = Color(0xFFC8A0A8);
    canvas.drawRect(
      Rect.fromLTWH(0, topPad, w, max(0, baseY - topPad)),
      Paint()..color = sage.withValues(alpha: 0.06),
    );
    canvas.drawRect(
      Rect.fromLTWH(0, baseY, w, max(0, (topPad + usable) - baseY)),
      Paint()..color = rose.withValues(alpha: 0.06),
    );

    final dot = Paint()
      ..color = ink.withValues(alpha: 0.22)
      ..strokeWidth = 1.2;
    const step = 8.0;
    for (var x = 0.0; x < w; x += step) {
      canvas.drawLine(Offset(x, baseY), Offset(x + 3.5, baseY), dot);
    }

    // Highlight stressed days when focusing chaos.
    if (focus == _WaveFocus.chaos) {
      final hi = Paint()..color = chaos.withValues(alpha: 0.10);
      for (var i = 0; i < points.length; i++) {
        if (points[i].score < baseline) {
          final x = pts[i].dx;
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(max(0, x - 18), topPad, 36, usable),
              const Radius.circular(10),
            ),
            hi,
          );
        }
      }
    }

    // Wave path.
    final path = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (var i = 1; i < pts.length; i++) {
      final prev = pts[i - 1];
      final cur = pts[i];
      final mid = Offset((prev.dx + cur.dx) / 2, (prev.dy + cur.dy) / 2);
      path.quadraticBezierTo(prev.dx, prev.dy, mid.dx, mid.dy);
    }
    path.lineTo(pts.last.dx, pts.last.dy);

    // Area fill under wave with glowing gradient + blur.
    final fillPath = Path.from(path)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();

    final focusColor = focus == _WaveFocus.peace ? peace : chaos;
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          focusColor.withValues(alpha: 0.22),
          focusColor.withValues(alpha: 0.00),
        ],
        stops: const [0.0, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, w, h))
      ..style = PaintingStyle.fill;

    canvas.saveLayer(Offset.zero & size, Paint());
    canvas.drawPath(fillPath, fillPaint);
    canvas.restore();

    // Blurred glow overlay (soft luxury).
    final glowPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0, -0.2),
        radius: 1.2,
        colors: [
          focusColor.withValues(alpha: 0.14),
          focusColor.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);
    canvas.drawPath(fillPath, glowPaint);

    // Wave line.
    final line = Paint()
      ..color = ink.withValues(alpha: 0.78)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2;
    canvas.drawPath(path, line);
  }

  @override
  bool shouldRepaint(covariant _ReflectionWavePainter oldDelegate) {
    return oldDelegate.focus != focus || oldDelegate.points != points;
  }
}

