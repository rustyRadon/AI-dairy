import "package:flutter/material.dart";

import "../shared/ui/glass_card.dart";
import "../shared/ui/ore_typography.dart";
import "onboarding_state.dart";
import "phase3_interruption_level_screen.dart";
import "widgets/onboarding_background.dart";
import "widgets/ore_avatar.dart";
import "widgets/setup_colors.dart";

class Phase3ConversationStyleScreen extends StatefulWidget {
  const Phase3ConversationStyleScreen({super.key, required this.state});

  final OnboardingState state;

  @override
  State<Phase3ConversationStyleScreen> createState() => _Phase3ConversationStyleScreenState();
}

class _Phase3ConversationStyleScreenState extends State<Phase3ConversationStyleScreen> {
  ConversationStyle? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.state.conversationStyle;
  }

  void _continue() async {
    final sel = _selected;
    if (sel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Pick a style — you can change this later.",
            style: OreTypography.body(color: SetupColors.white).copyWith(fontWeight: FontWeight.w800),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final next = widget.state.copyWith(conversationStyle: sel);
    await OnboardingPrefs.save(next);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => Phase3InterruptionLevelScreen(state: next),
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
                          const _StepPill(text: "PHASE 3 · 1/2"),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Center(child: AvatarCircle(size: 86)),
                      const SizedBox(height: 18),
                      GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text("Pal calibration", textAlign: TextAlign.center, style: OreTypography.heroH2()),
                            const SizedBox(height: 10),
                            Text("How should we talk?", textAlign: TextAlign.center, style: OreTypography.body().copyWith(fontSize: 14)),
                            const SizedBox(height: 16),
                            _StyleCard(
                              title: "The Stoic",
                              body: "Direct, logical — focus on tasks.",
                              selected: _selected == ConversationStyle.stoic,
                              accent: SetupColors.accentYellow,
                              onTap: () => setState(() => _selected = ConversationStyle.stoic),
                            ),
                            const SizedBox(height: 10),
                            _StyleCard(
                              title: "The Muse",
                              body: "Creative, questioning — focus on ideas.",
                              selected: _selected == ConversationStyle.muse,
                              accent: SetupColors.accentGreen,
                              onTap: () => setState(() => _selected = ConversationStyle.muse),
                            ),
                            const SizedBox(height: 10),
                            _StyleCard(
                              title: "The Hype‑Man",
                              body: "Encouraging, high‑energy — focus on wins.",
                              selected: _selected == ConversationStyle.hypeMan,
                              accent: SetupColors.accentRed,
                              onTap: () => setState(() => _selected = ConversationStyle.hypeMan),
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

class _StyleCard extends StatelessWidget {
  const _StyleCard({
    required this.title,
    required this.body,
    required this.selected,
    required this.accent,
    required this.onTap,
  });

  final String title;
  final String body;
  final bool selected;
  final Color accent;
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: accent,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: accent.withValues(alpha: 0.35), blurRadius: 10, offset: const Offset(0, 4))],
                ),
              ),
              const SizedBox(width: 12),
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
              const SizedBox(width: 10),
              Icon(
                selected ? Icons.check_circle_rounded : Icons.circle_outlined,
                color: selected ? SetupColors.white : SetupColors.white.withValues(alpha: 0.5),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

