import "dart:math";
import "dart:async";
import "dart:ui" show lerpDouble;

import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

import "../onboarding/widgets/ore_avatar.dart";

class OreSpaceScreen extends StatefulWidget {
  const OreSpaceScreen({super.key, required this.userName});
  final String userName;

  @override
  State<OreSpaceScreen> createState() => _OreSpaceScreenState();
}

class _OreSpaceScreenState extends State<OreSpaceScreen>
    with TickerProviderStateMixin {
  late final AnimationController _breath = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 5200),
  )..repeat(reverse: true);

  late final AnimationController _ring = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  )..repeat();

  Timer? _loop;
  double _volume = 0.18; // UI-only (0..1)
  String _transcription = "Listening…";
  int _txTick = 0;
  static const _txPool = <String>[
    "today",
    "I’m",
    "trying",
    "to",
    "stay",
    "calm",
    "but",
    "there’s",
    "a",
    "lot",
    "on",
    "my",
    "mind",
    "work",
    "feels",
    "heavy",
    "I",
    "need",
    "one",
    "small",
    "step",
    "meeting",
    "call",
    "idea",
    "deadline",
  ];
  bool _taskIntentSeen = false;
  int _taskIntentCount = 0;
  bool _sparkIntentSeen = false;
  int _sparkIntentCount = 0;
  DateTime? _taskIntentCooldownUntil;
  DateTime? _sparkIntentCooldownUntil;
  static final _taskKeywordRe = RegExp(
    r"\b(meeting|meetings|appointment|appointments|deadline|deadlines|schedule|scheduled|calendar|call)\b",
    caseSensitive: false,
  );
  static final _sparkKeywordRe = RegExp(
    r"\b(idea|ideas|spark|wonder|dream|maybe|what if)\b",
    caseSensitive: false,
  );

  @override
  void initState() {
    super.initState();
    _loop = Timer.periodic(const Duration(milliseconds: 260), (_) {
      if (!mounted) return;
      // Gentle fake volume drift (feels "alive" even without mic).
      final target = 0.12 + (sin((_txTick / 10) * pi) * 0.18).abs();
      setState(() {
        _volume = (_volume * 0.72) + (target * 0.28);
      });

      // Subtle transcription: last ~5 words.
      if (_txTick % 2 == 0) {
        final w = _txPool[_txTick % _txPool.length];
        final prev = _transcription == "Listening…" ? "" : _transcription;
        final words = (prev.isEmpty ? <String>[] : prev.split(" "))
          ..add(w);
        final last = words.length <= 5 ? words : words.sublist(words.length - 5);
        final line = last.join(" ");
        setState(() {
          _transcription = line;
        });
        _scanTranscriptionForIntents(line);
      }

      _txTick++;
    });
  }

  void _tryFireTaskIntent() {
    final now = DateTime.now();
    if (_taskIntentCooldownUntil != null &&
        now.isBefore(_taskIntentCooldownUntil!)) {
      return;
    }
    _taskIntentCooldownUntil = now.add(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() {
      _taskIntentSeen = true;
      _taskIntentCount++;
    });
  }

  void _tryFireSparkIntent() {
    final now = DateTime.now();
    if (_sparkIntentCooldownUntil != null &&
        now.isBefore(_sparkIntentCooldownUntil!)) {
      return;
    }
    _sparkIntentCooldownUntil = now.add(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() {
      _sparkIntentSeen = true;
      _sparkIntentCount++;
    });
  }

  void _scanTranscriptionForIntents(String text) {
    if (_taskKeywordRe.hasMatch(text)) _tryFireTaskIntent();
    if (_sparkKeywordRe.hasMatch(text)) _tryFireSparkIntent();
  }

  @override
  void dispose() {
    _loop?.cancel();
    _breath.dispose();
    _ring.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final onBg = cs.onSurface;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: AnimatedBuilder(
                animation: Listenable.merge([_breath, _ring]),
                builder: (context, _) {
                  final t = _breath.value;
                  final scale = 0.96 + (t * 0.06);
                  final soft = onBg.withValues(alpha: 0.06 + t * 0.04);
                  return Transform.scale(
                    scale: scale,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Outer "alive" ring (waveform-like).
                        CustomPaint(
                          size: const Size(300, 300),
                          painter: _WaveRingPainter(
                            phase: _ring.value,
                            volume: _volume,
                            base: onBg,
                            accent: cs.tertiary,
                          ),
                        ),
                        // Soft core circle.
                        Container(
                          width: 280,
                          height: 280,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: soft,
                            boxShadow: [
                              BoxShadow(
                                color: cs.tertiary.withValues(
                                  alpha: 0.06 + (_volume * 0.12),
                                ),
                                blurRadius: 34 + (_volume * 28),
                                spreadRadius: 4 + (_volume * 4),
                              ),
                            ],
                            border: Border.all(
                              color: onBg.withValues(alpha: 0.10),
                            ),
                          ),
                          child: const Center(child: OreMascot(height: 150)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            Positioned(
              top: 6,
              left: 6,
              child: IconButton(
                tooltip: "Back",
                icon: Icon(Icons.arrow_back_rounded, color: onBg),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            Positioned(
              top: 8,
              left: 52,
              right: 56,
              child: IgnorePointer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Ọ̀rẹ́ Space",
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: onBg,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Talk with Ọ̀rẹ́ out loud — Ọ̀rẹ́ listens, talks back, and helps you think.",
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: onBg.withValues(alpha: 0.62),
                        fontWeight: FontWeight.w600,
                        fontSize: 12.5,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 6,
              right: 6,
              child: TextButton(
                onPressed: () => _showWrapUp(context),
                style: TextButton.styleFrom(
                  foregroundColor: onBg,
                ),
                child: const Text(
                  "Wrap up",
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),

            if (_taskIntentSeen || _sparkIntentSeen)
              Positioned(
                left: 0,
                right: 0,
                bottom: 128,
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_taskIntentSeen)
                        _IntentPopChip(
                          icon: Icons.check_rounded,
                          label: "Task intent",
                          triggerCount: _taskIntentCount,
                          pulseColor: const Color(0xFF14B8A6),
                        ),
                      if (_taskIntentSeen && _sparkIntentSeen)
                        const SizedBox(width: 12),
                      if (_sparkIntentSeen)
                        _IntentPopChip(
                          icon: Icons.star_rounded,
                          label: "Spark",
                          triggerCount: _sparkIntentCount,
                          pulseColor: const Color(0xFFF59E0B),
                        ),
                    ],
                  ),
                ),
              ),

            Positioned(
              left: 12,
              right: 12,
              bottom: 52,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _FadingTranscript(text: _transcription),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showWrapUp(BuildContext context) async {
    final cs = Theme.of(context).colorScheme;
    final onBg = cs.onSurface;
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
                const SizedBox(height: 6),
                Text(
                  "Session summary",
                  style: TextStyle(
                    color: onBg,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "You named what’s loud. We softened it without forcing a fix. Next, we’ll choose one small step that feels doable.",
                  style: TextStyle(
                    color: onBg.withValues(alpha: 0.82),
                    height: 1.35,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 14),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: onBg,
                    foregroundColor: cs.surface,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(this.context).pop();
                  },
                  child: const Text(
                    "Close session",
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _IntentPopChip extends StatefulWidget {
  const _IntentPopChip({
    required this.icon,
    required this.label,
    required this.triggerCount,
    required this.pulseColor,
  });

  final IconData icon;
  final String label;
  final int triggerCount;
  final Color pulseColor;

  @override
  State<_IntentPopChip> createState() => _IntentPopChipState();
}

class _IntentPopChipState extends State<_IntentPopChip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  );

  /// First frame after first trigger: full pop-in + pulse. Later: pulse only.
  bool _playIntro = false;

  @override
  void initState() {
    super.initState();
    if (widget.triggerCount > 0) {
      _playIntro = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _c.forward(from: 0);
      });
    }
  }

  @override
  void didUpdateWidget(covariant _IntentPopChip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.triggerCount > oldWidget.triggerCount) {
      _playIntro = oldWidget.triggerCount == 0;
      _c.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  /// Returns scale, content opacity (0..1), teal pulse 0..1 for glow/border.
  (double, double, double) _phase(double t) {
    double cin(double x) => x.clamp(0.0, 1.0);

    if (_playIntro) {
      if (t < 0.22) {
        final u = Curves.easeOutBack.transform(cin(t / 0.22));
        final o = Curves.easeOut.transform(cin(t / 0.22));
        return (u, o, 0);
      }
      if (t < 0.42) {
        final u = lerpDouble(1, 1.12, Curves.easeOut.transform(cin((t - 0.22) / 0.2)))!;
        final glow = Curves.easeOut.transform(cin((t - 0.22) / 0.2));
        return (u, 1.0, glow);
      }
      if (t < 0.58) {
        final u = lerpDouble(1.12, 1, Curves.easeInOut.transform(cin((t - 0.42) / 0.16)))!;
        final glow = lerpDouble(1, 0, Curves.easeInOut.transform(cin((t - 0.42) / 0.16)))!;
        return (u, 1.0, glow);
      }
      const u = 1.0;
      final o = lerpDouble(1, 0.5, Curves.easeOut.transform(cin((t - 0.58) / 0.42)))!;
      return (u, o, 0);
    }

    if (t < 0.32) {
      final u = lerpDouble(1, 1.14, Curves.easeOut.transform(cin(t / 0.32)))!;
      final o = lerpDouble(0.5, 1, Curves.easeOut.transform(cin(t / 0.32)))!;
      final glow = Curves.easeOut.transform(cin(t / 0.32));
      return (u, o, glow);
    }
    if (t < 0.52) {
      final u = lerpDouble(1.14, 1, Curves.easeInOut.transform(cin((t - 0.32) / 0.2)))!;
      final glow = lerpDouble(1, 0, Curves.easeInOut.transform(cin((t - 0.32) / 0.2)))!;
      return (u, 1.0, glow);
    }
    final o = lerpDouble(1, 0.5, Curves.easeOut.transform(cin((t - 0.52) / 0.48)))!;
    return (1.0, o, 0);
  }

  @override
  Widget build(BuildContext context) {
    final onBg = Theme.of(context).colorScheme.onSurface;
    return ListenableBuilder(
      listenable: _c,
      builder: (context, _) {
        final t = _c.value.clamp(0.0, 1.0);
        final (scale, contentOpacity, glowT) = _phase(t);

        final fillBase = onBg.withValues(alpha: 0.06 + 0.08 * glowT);
        final fillPulse = widget.pulseColor.withValues(alpha: 0.14 * glowT);
        final borderNorm = onBg.withValues(alpha: 0.12 + 0.14 * glowT);
        final borderPulse =
            Color.alphaBlend(widget.pulseColor.withValues(alpha: 0.55 * glowT), borderNorm);

        final iconMix = (0.38 + 0.42 * glowT).clamp(0.0, 1.0);
        final iconColor = Color.lerp(
          onBg,
          widget.pulseColor,
          iconMix,
        )!;

        return Tooltip(
          message: widget.label,
          child: Semantics(
            label: widget.label,
            child: Opacity(
              opacity: contentOpacity.clamp(0.0, 1.0),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.alphaBlend(fillPulse, fillBase),
                    border: Border.all(color: borderPulse),
                    boxShadow: [
                      if (glowT > 0.04)
                        BoxShadow(
                          color: widget.pulseColor.withValues(alpha: 0.22 * glowT),
                          blurRadius: 18 + 14 * glowT,
                          spreadRadius: 2 * glowT,
                        ),
                    ],
                  ),
                  child: Icon(widget.icon, color: iconColor, size: 22),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _FadingTranscript extends StatefulWidget {
  const _FadingTranscript({required this.text});
  final String text;

  @override
  State<_FadingTranscript> createState() => _FadingTranscriptState();
}

class _FadingTranscriptState extends State<_FadingTranscript>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 850),
  )..forward();

  @override
  void didUpdateWidget(covariant _FadingTranscript oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _c
        ..stop()
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final onBg = Theme.of(context).colorScheme.onSurface;
    final baseStyle = GoogleFonts.lora(
      color: onBg.withValues(alpha: 0.62),
      fontSize: 19,
      fontWeight: FontWeight.w600,
      height: 1.3,
    );
    return FadeTransition(
      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _c, curve: Curves.easeOut),
      ),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 850),
        opacity: 1,
        child: ShaderMask(
          blendMode: BlendMode.dstIn,
          shaderCallback: (bounds) {
            return const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0x00FFFFFF),
                Color(0xFFFFFFFF),
                Color(0xFFFFFFFF),
                Color(0x00FFFFFF),
              ],
              stops: [0.0, 0.16, 0.84, 1.0],
            ).createShader(bounds);
          },
          child: Text(
            widget.text,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: baseStyle,
          ),
        ),
      ),
    );
  }
}

class _WaveRingPainter extends CustomPainter {
  _WaveRingPainter({
    required this.phase,
    required this.volume,
    required this.base,
    required this.accent,
  });

  final double phase; // 0..1
  final double volume; // 0..1
  final Color base;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final r = min(size.width, size.height) / 2 - 6;

    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;

    // Subtle ring.
    p.color = base.withValues(alpha: 0.10 + (volume * 0.12));
    canvas.drawCircle(center, r, p);

    // Wave border: small radial wobble around the ring.
    final wave = Path();
    final n = 80;
    for (var i = 0; i <= n; i++) {
      final a = (i / n) * pi * 2;
      final wobble = sin(a * 6 + (phase * pi * 2)) * (3 + (volume * 9));
      final rr = r + wobble;
      final pt = center + Offset(cos(a) * rr, sin(a) * rr);
      if (i == 0) {
        wave.moveTo(pt.dx, pt.dy);
      } else {
        wave.lineTo(pt.dx, pt.dy);
      }
    }
    wave.close();

    p
      ..color = accent.withValues(alpha: 0.20 + (volume * 0.25))
      ..strokeWidth = 2.6;
    canvas.drawPath(wave, p);

    // Gentle glow.
    final glow = Paint()
      ..color = accent.withValues(alpha: 0.10 + (volume * 0.10))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);
    canvas.drawCircle(center, r + 2, glow);
  }

  @override
  bool shouldRepaint(covariant _WaveRingPainter oldDelegate) {
    return oldDelegate.phase != phase ||
        oldDelegate.volume != volume ||
        oldDelegate.base != base ||
        oldDelegate.accent != accent;
  }
}

