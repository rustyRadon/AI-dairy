import "dart:async";

import "package:flutter/material.dart";
import "package:path_provider/path_provider.dart";
import "package:record/record.dart";

import "../shared/ui/glass_card.dart";
import "../shared/ui/ore_typography.dart";
import "onboarding_state.dart";
import "pin_entry_screen.dart";
import "widgets/onboarding_background.dart";
import "widgets/ore_avatar.dart";
import "widgets/setup_colors.dart";

class Phase5FirstDumpScreen extends StatefulWidget {
  const Phase5FirstDumpScreen({super.key, required this.state});

  final OnboardingState state;

  @override
  State<Phase5FirstDumpScreen> createState() => _Phase5FirstDumpScreenState();
}

class _Phase5FirstDumpScreenState extends State<Phase5FirstDumpScreen> {
  final _recorder = AudioRecorder();
  Timer? _timer;

  bool _recording = false;
  int _remaining = 30;
  String? _lastPath;

  Future<String> _makeTempPath() async {
    final dir = await getTemporaryDirectory();
    final ts = DateTime.now().millisecondsSinceEpoch;
    return "${dir.path}/ore_first_dump_$ts.m4a";
  }

  @override
  void dispose() {
    _timer?.cancel();
    _recorder.dispose();
    super.dispose();
  }

  Future<void> _toggle() async {
    if (_recording) {
      await _stop();
    } else {
      await _start();
    }
  }

  Future<void> _start() async {
    final ok = await _recorder.hasPermission();
    if (!ok) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Microphone permission is needed for the voice test.",
            style: OreTypography.body(color: SetupColors.white).copyWith(fontWeight: FontWeight.w800),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _recording = true;
      _remaining = 30;
      _lastPath = null;
    });

    final outPath = await _makeTempPath();
    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        sampleRate: 44100,
      ),
      path: outPath,
    );

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) async {
      if (!mounted) return;
      if (_remaining <= 1) {
        await _stop();
        return;
      }
      setState(() => _remaining -= 1);
    });
  }

  Future<void> _stop() async {
    _timer?.cancel();
    final path = await _recorder.stop();
    if (!mounted) return;
    setState(() {
      _recording = false;
      _lastPath = path;
    });
  }

  void _continue() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => OnboardingPinEntryScreen(
          nickname: widget.state.nickname,
          email: widget.state.email,
          website: widget.state.website,
          instagram: widget.state.instagram,
          xHandle: widget.state.xHandle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = "First dump";
    final prompt =
        "I’ve studied your website and I’m ready. You look like you have a lot on your mind right now.\n\nWant to give me 30 seconds of chaos? I’ll turn it into peace before you even finish your coffee.";

    return Scaffold(
      backgroundColor: SetupColors.bgBlack,
      body: OnboardingBackground(
        color: SetupColors.bgBlack,
        child: SafeArea(
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: EdgeInsets.fromLTRB(28, 0, 28, 24 + MediaQuery.of(context).padding.bottom),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back_ios_new_rounded, color: SetupColors.white.withValues(alpha: 0.82)),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          const Spacer(),
                          const _StepPill(text: "PHASE 5"),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Center(child: AvatarCircle(size: 86)),
                      const SizedBox(height: 18),
                      GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(title, textAlign: TextAlign.center, style: OreTypography.heroH2()),
                            const SizedBox(height: 10),
                            Text(prompt, textAlign: TextAlign.center, style: OreTypography.body().copyWith(fontSize: 14)),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                              decoration: BoxDecoration(
                                color: SetupColors.white.withValues(alpha: 0.10),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: SetupColors.white.withValues(alpha: 0.14)),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: _recording ? SetupColors.accentRed : SetupColors.accentGreen,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: (_recording ? SetupColors.accentRed : SetupColors.accentGreen).withValues(alpha: 0.35),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      _recording ? "Listening… ${_remaining}s" : "Tap to start a 30s voice test",
                                      style: OreTypography.body().copyWith(fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  FilledButton(
                                    style: FilledButton.styleFrom(
                                      backgroundColor: SetupColors.white,
                                      foregroundColor: SetupColors.ink,
                                      elevation: 0,
                                      shape: const StadiumBorder(),
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                    ),
                                    onPressed: _toggle,
                                    child: Text(
                                      _recording ? "Stop" : "Start",
                                      style: OreTypography.button(color: SetupColors.ink).copyWith(fontSize: 13.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (_lastPath != null) ...[
                              const SizedBox(height: 12),
                              Text(
                                "Captured. I’m ready to turn it into peace.",
                                textAlign: TextAlign.center,
                                style: OreTypography.body(color: SetupColors.white.withValues(alpha: 0.78)).copyWith(fontSize: 13.5),
                              ),
                            ],
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 52,
                              child: FilledButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor: SetupColors.white,
                                  foregroundColor: SetupColors.ink,
                                  elevation: 0,
                                  shape: const StadiumBorder(),
                                ),
                                onPressed: _continue,
                                child: Text("Continue", style: OreTypography.button(color: SetupColors.ink)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepPill extends StatelessWidget {
  const _StepPill({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: SetupColors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: SetupColors.white.withValues(alpha: 0.16)),
      ),
      child: Text(text, style: OreTypography.eyebrow().copyWith(fontSize: 10.5)),
    );
  }
}

