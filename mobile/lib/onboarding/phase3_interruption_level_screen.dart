import "package:flutter/material.dart";

import "../shared/ui/glass_card.dart";
import "../shared/ui/ore_typography.dart";
import "onboarding_state.dart";
import "phase4_permissions_screen.dart";
import "widgets/onboarding_background.dart";
import "widgets/ore_avatar.dart";
import "widgets/setup_colors.dart";

class Phase3InterruptionLevelScreen extends StatefulWidget {
  const Phase3InterruptionLevelScreen({super.key, required this.state});

  final OnboardingState state;

  @override
  State<Phase3InterruptionLevelScreen> createState() => _Phase3InterruptionLevelScreenState();
}

class _Phase3InterruptionLevelScreenState extends State<Phase3InterruptionLevelScreen> {
  InterruptionLevel? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.state.interruptionLevel;
  }

  void _continue() async {
    final sel = _selected;
    if (sel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Pick one — you can change this later.",
            style: OreTypography.body(color: SetupColors.white).copyWith(fontWeight: FontWeight.w800),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final next = widget.state.copyWith(interruptionLevel: sel);
    await OnboardingPrefs.save(next);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => Phase4PermissionsScreen(state: next),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                          const _StepPill(text: "PHASE 3 · 2/2"),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Center(child: AvatarCircle(size: 86)),
                      const SizedBox(height: 18),
                      GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text("Voice sessions", textAlign: TextAlign.center, style: OreTypography.heroH2()),
                            const SizedBox(height: 10),
                            Text(
                              "During our voice sessions, do you want me to…",
                              textAlign: TextAlign.center,
                              style: OreTypography.body().copyWith(fontSize: 14),
                            ),
                            const SizedBox(height: 16),
                            _Option(
                              title: "Just listen",
                              body: "I’ll wait until you’re done.",
                              selected: _selected == InterruptionLevel.justListen,
                              onTap: () => setState(() => _selected = InterruptionLevel.justListen),
                            ),
                            const SizedBox(height: 10),
                            _Option(
                              title: "Interrupt to challenge",
                              body: "I’ll ask for details or challenge ideas.",
                              selected: _selected == InterruptionLevel.interruptAndChallenge,
                              onTap: () => setState(() => _selected = InterruptionLevel.interruptAndChallenge),
                            ),
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

class _Option extends StatelessWidget {
  const _Option({required this.title, required this.body, required this.selected, required this.onTap});

  final String title;
  final String body;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
          decoration: BoxDecoration(
            color: SetupColors.white.withValues(alpha: selected ? 0.16 : 0.10),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: SetupColors.white.withValues(alpha: selected ? 0.30 : 0.14)),
          ),
          child: Row(
            children: [
              Icon(
                selected ? Icons.check_circle_rounded : Icons.circle_outlined,
                color: selected ? SetupColors.accentGreen : SetupColors.white.withValues(alpha: 0.55),
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: OreTypography.body().copyWith(fontWeight: FontWeight.w900)),
                    const SizedBox(height: 4),
                    Text(body, style: OreTypography.body().copyWith(fontSize: 13.5, color: SetupColors.white.withValues(alpha: 0.72))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

