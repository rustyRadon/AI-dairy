import "package:flutter/material.dart";

import "../auth/login_screen.dart";
import "../shared/ui/glass_card.dart";
import "../shared/ui/ore_buttons.dart";
import "../shared/ui/ore_typography.dart";
import "nickname_entry_screen.dart";
import "widgets/onboarding_background.dart";
import "widgets/ore_avatar.dart";
import "widgets/setup_colors.dart";

class OnboardingWelcomeScreen extends StatelessWidget {
  const OnboardingWelcomeScreen({super.key});

  static const _horizontalPad = 28.0;

  void _startSignup(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const OnboardingNicknameEntryScreen(),
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
                padding: EdgeInsets.fromLTRB(
                  _horizontalPad,
                  20,
                  _horizontalPad,
                  24 + MediaQuery.of(context).padding.bottom,
                ),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            "Ọ̀rẹ́",
                            style: OreTypography.eyebrow(color: SetupColors.white.withValues(alpha: 0.9)).copyWith(
                              fontSize: 12,
                              letterSpacing: 0.9,
                            ),
                          ),
                          const SizedBox(width: 10),
                          _AccentDot(color: SetupColors.accentYellow),
                          const SizedBox(width: 6),
                          _AccentDot(color: SetupColors.accentGreen),
                          const SizedBox(width: 6),
                          _AccentDot(color: SetupColors.accentRed),
                          const Spacer(),
                          _TopPill(label: "Login", onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const LoginScreen()))),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Center(child: OreMascot(height: 108, useAlternateArtwork: true)),
                      const SizedBox(height: 18),
                      Text(
                        "One brain,\nevery thought.",
                        textAlign: TextAlign.left,
                        style: OreTypography.heroH1(),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Capture ideas in text or voice. Ọ̀rẹ́ learns your context and turns nightly decompression into a verified plan on your shadow calendar.",
                        textAlign: TextAlign.left,
                        style: OreTypography.body(),
                      ),
                      const SizedBox(height: 18),
                      // Keep app copy focused on onboarding (no web waitlist CTAs).
                      OrePrimaryButton(
                        label: "Continue with email",
                        icon: Icons.arrow_forward_rounded,
                        onPressed: () => _startSignup(context),
                      ),
                      const SizedBox(height: 18),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final wide = constraints.maxWidth >= 520;
                          final children = const [
                            _PillarCard(
                              title: "Deep context",
                              body: "Onboarding that learns your voice, projects, and goals.",
                            ),
                            _PillarCard(
                              title: "Hybrid capture",
                              body: "Text threads + low‑latency voice for real decompression.",
                            ),
                            _PillarCard(
                              title: "Shadow calendar",
                              body: "Turns intentions into verified, scheduled commitments.",
                            ),
                          ];
                          if (wide) {
                            return Row(
                              children: [
                                Expanded(child: children[0]),
                                const SizedBox(width: 12),
                                Expanded(child: children[1]),
                                const SizedBox(width: 12),
                                Expanded(child: children[2]),
                              ],
                            );
                          }
                          return Column(
                            children: [
                              children[0],
                              const SizedBox(height: 12),
                              children[1],
                              const SizedBox(height: 12),
                              children[2],
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 22),
                      _TrialCtaCard(onPressed: () => _startSignup(context)),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const LoginScreen()));
                        },
                        child: Text(
                          "Already have an account? Sign in",
                          style: OreTypography.body(color: SetupColors.white.withValues(alpha: 0.8)).copyWith(
                            fontWeight: FontWeight.w800,
                            decoration: TextDecoration.underline,
                            decorationColor: SetupColors.white.withValues(alpha: 0.35),
                          ),
                        ),
                      ),
                      // Extra breathing room on short windows to avoid tiny overflows.
                      const SizedBox(height: 12),
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

class _AccentDot extends StatelessWidget {
  const _AccentDot({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.35),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }
}

class _TrialCtaCard extends StatelessWidget {
  const _TrialCtaCard({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          decoration: BoxDecoration(
            color: SetupColors.white.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 32,
                offset: const Offset(0, 18),
              ),
            ],
            border: Border.all(
              color: SetupColors.white.withValues(alpha: 0.16),
              width: 1.2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 36,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            SetupColors.accentYellow,
                            SetupColors.accentGreen,
                            SetupColors.accentRed,
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Start 7-day free trial",
                            style: OreTypography.heroH2(),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "No card required.",
                            style: OreTypography.body().copyWith(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: SetupColors.accentYellow,
                      size: 26,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TopPill extends StatelessWidget {
  const _TopPill({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: SetupColors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: SetupColors.white.withValues(alpha: 0.14)),
          ),
          child: Text(
            label,
            style: OreTypography.eyebrow().copyWith(letterSpacing: 1.1, fontSize: 10.5),
          ),
        ),
      ),
    );
  }
}

class _PillarCard extends StatelessWidget {
  const _PillarCard({required this.title, required this.body});
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: OreTypography.eyebrow(color: SetupColors.white.withValues(alpha: 0.85))),
          const SizedBox(height: 8),
          Text(body, style: OreTypography.body().copyWith(fontSize: 13.5)),
        ],
      ),
    );
  }
}
