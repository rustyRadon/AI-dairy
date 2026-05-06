import "package:flutter/material.dart";

import "../shared/ui/glass_card.dart";
import "../shared/ui/ore_typography.dart";
import "onboarding_state.dart";
import "phase2_energy_map_screen.dart";
import "widgets/onboarding_background.dart";
import "widgets/ore_avatar.dart";
import "widgets/setup_colors.dart";

class Phase2NoiseFilterScreen extends StatefulWidget {
  const Phase2NoiseFilterScreen({super.key, required this.state});

  final OnboardingState state;

  @override
  State<Phase2NoiseFilterScreen> createState() => _Phase2NoiseFilterScreenState();
}

class _Phase2NoiseFilterScreenState extends State<Phase2NoiseFilterScreen> {
  late Set<NoiseFilter> _selected;

  @override
  void initState() {
    super.initState();
    _selected = Set<NoiseFilter>.from(widget.state.noiseFilters);
  }

  void _toggle(NoiseFilter f) {
    setState(() {
      if (_selected.contains(f)) {
        _selected.remove(f);
      } else {
        _selected.add(f);
      }
    });
  }

  void _continue() async {
    if (_selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Pick at least one — we’ll prioritize around what you choose.",
            style: OreTypography.body(color: SetupColors.white).copyWith(fontWeight: FontWeight.w800),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final next = widget.state.copyWith(noiseFilters: Set<NoiseFilter>.from(_selected));
    await OnboardingPrefs.save(next);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => Phase2EnergyMapScreen(state: next),
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
                          const _StepPill(text: "PHASE 2 · 1/2"),
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
                              "The Noise filter",
                              textAlign: TextAlign.center,
                              style: OreTypography.heroH2(),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "What keeps you up at 3 AM?",
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
                              label: "Unfinished tasks",
                              selected: _selected.contains(NoiseFilter.unfinishedTasks),
                              onTap: () => _toggle(NoiseFilter.unfinishedTasks),
                            ),
                            const SizedBox(height: 10),
                            _Option(
                              label: "Scattered ideas",
                              selected: _selected.contains(NoiseFilter.scatteredIdeas),
                              onTap: () => _toggle(NoiseFilter.scatteredIdeas),
                            ),
                            const SizedBox(height: 10),
                            _Option(
                              label: "Fear of forgetting",
                              selected: _selected.contains(NoiseFilter.fearOfForgetting),
                              onTap: () => _toggle(NoiseFilter.fearOfForgetting),
                            ),
                            const SizedBox(height: 10),
                            _Option(
                              label: "Lack of a plan",
                              selected: _selected.contains(NoiseFilter.lackOfAPlan),
                              onTap: () => _toggle(NoiseFilter.lackOfAPlan),
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
                color: selected ? SetupColors.accentYellow : SetupColors.white.withValues(alpha: 0.55),
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

