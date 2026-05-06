import "package:flutter/material.dart";

import "../shared/ui/glass_card.dart";
import "../shared/ui/ore_typography.dart";
import "onboarding_state.dart";
import "phase3_conversation_style_screen.dart";
import "widgets/onboarding_background.dart";
import "widgets/ore_avatar.dart";
import "widgets/setup_colors.dart";

class Phase2EnergyMapScreen extends StatefulWidget {
  const Phase2EnergyMapScreen({super.key, required this.state});

  final OnboardingState state;

  @override
  State<Phase2EnergyMapScreen> createState() => _Phase2EnergyMapScreenState();
}

class _Phase2EnergyMapScreenState extends State<Phase2EnergyMapScreen> {
  late Set<EnergyMap> _selected;

  @override
  void initState() {
    super.initState();
    _selected = Set<EnergyMap>.from(widget.state.energyMaps);
  }

  void _toggle(EnergyMap e) {
    setState(() {
      if (_selected.contains(e)) {
        _selected.remove(e);
      } else {
        _selected.add(e);
      }
    });
  }

  void _continue() async {
    if (_selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Pick at least one — this shapes Morning Mirror / Evening Decompression timing.",
            style: OreTypography.body(color: SetupColors.white).copyWith(fontWeight: FontWeight.w800),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final next = widget.state.copyWith(energyMaps: Set<EnergyMap>.from(_selected));
    await OnboardingPrefs.save(next);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => Phase3ConversationStyleScreen(state: next),
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
                          const _StepPill(text: "PHASE 2 · 2/2"),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Center(child: AvatarCircle(size: 86)),
                      const SizedBox(height: 18),
                      GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              "The Energy map",
                              textAlign: TextAlign.center,
                              style: OreTypography.heroH2(),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "When does your brain feel most “at peace”?",
                              textAlign: TextAlign.center,
                              style: OreTypography.body().copyWith(fontSize: 14),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Select all that apply.",
                              textAlign: TextAlign.center,
                              style: OreTypography.eyebrow().copyWith(fontSize: 11.5),
                            ),
                            const SizedBox(height: 16),
                            _Option(
                              label: "Early morning",
                              selected: _selected.contains(EnergyMap.earlyMorning),
                              onTap: () => _toggle(EnergyMap.earlyMorning),
                            ),
                            const SizedBox(height: 10),
                            _Option(
                              label: "Late night",
                              selected: _selected.contains(EnergyMap.lateNight),
                              onTap: () => _toggle(EnergyMap.lateNight),
                            ),
                            const SizedBox(height: 10),
                            _Option(
                              label: "After a walk",
                              selected: _selected.contains(EnergyMap.afterAWalk),
                              onTap: () => _toggle(EnergyMap.afterAWalk),
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
  const _Option({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: selected ? SetupColors.white.withValues(alpha: 0.16) : SetupColors.white.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(16),
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
                child: Text(
                  label,
                  style: OreTypography.body().copyWith(fontWeight: FontWeight.w800, height: 1.2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

