import "package:flutter/material.dart";

import "../home/home_shell.dart";
import "../shared/ui/glass_card.dart";
import "../shared/ui/ore_buttons.dart";
import "../shared/ui/ore_typography.dart";
import "widgets/onboarding_background.dart";
import "widgets/ore_avatar.dart";
import "widgets/setup_colors.dart";

class OnboardingChatNowScreen extends StatelessWidget {
  const OnboardingChatNowScreen({
    super.key,
    required this.nickname,
    required this.email,
  });
  final String nickname;
  final String email;

  @override
  Widget build(BuildContext context) {
    final name = nickname.trim().isEmpty ? "friend" : nickname.trim();

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
                  28,
                  8,
                  28,
                  24 + MediaQuery.of(context).padding.bottom,
                ),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 12),
                      const Center(child: AvatarCircle(size: 92, useAlternateArtwork: true)),
                      const SizedBox(height: 22),
                      GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                _WelcomePill(text: "Welcome"),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "I'm so excited to have\nyou as a friend, $name!",
                              textAlign: TextAlign.center,
                              style: OreTypography.heroH2(),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "You're ready to begin — quiet moments with Ọ̀rẹ́, your reflections, "
                              "and a calmer thread through your days.",
                              textAlign: TextAlign.center,
                              style: OreTypography.body().copyWith(fontSize: 13.5),
                            ),
                            const SizedBox(height: 22),
                            OrePrimaryButton(
                              label: "Enter Ọ̀rẹ́",
                              icon: Icons.arrow_forward_rounded,
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute<void>(
                                    builder: (_) => HomeShell(userName: name),
                                  ),
                                );
                              },
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

class _WelcomePill extends StatelessWidget {
  const _WelcomePill({required this.text});
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
      child: Text(
        text.toUpperCase(),
        style: OreTypography.eyebrow().copyWith(fontSize: 10.5),
      ),
    );
  }
}
