import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

import "email_entry_screen.dart";
import "../shared/ui/glass_card.dart";
import "../shared/ui/ore_typography.dart";
import "widgets/onboarding_background.dart";
import "widgets/ore_avatar.dart";
import "widgets/setup_colors.dart";

class OnboardingNicknameEntryScreen extends StatefulWidget {
  const OnboardingNicknameEntryScreen({super.key});

  @override
  State<OnboardingNicknameEntryScreen> createState() => _OnboardingNicknameEntryScreenState();
}

class _OnboardingNicknameEntryScreenState extends State<OnboardingNicknameEntryScreen> {
  final _nickname = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nickname.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nickname.dispose();
    super.dispose();
  }

  void _continue() {
    final name = _nickname.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Pick a nickname so oré knows what to call you.",
            style: GoogleFonts.nunito(fontWeight: FontWeight.w600),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => OnboardingEmailEntryScreen(nickname: name),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nicknameReady = _nickname.text.trim().isNotEmpty;
    final promptStyle = OreTypography.heroH2();
    final bodyStyle = OreTypography.body();

    return Scaffold(
      backgroundColor: SetupColors.bgBlack,
      body: OnboardingBackground(
        color: SetupColors.bgBlack,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: SetupColors.white.withValues(alpha: 0.82),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              Expanded(
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: true,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(28, 0, 28, 24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 8),
                            const AvatarCircle(size: 92, useAlternateArtwork: true),
                            const SizedBox(height: 18),
                            GlassCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _StepPill(text: "Step 1/4"),
                                    ],
                                  ),
                                  const SizedBox(height: 14),
                                  Text(
                                    "So nice to meet you.\nWhat should I call you?",
                                    textAlign: TextAlign.center,
                                    style: promptStyle,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "This becomes your inside name across voice, thread, and calendar.",
                                    textAlign: TextAlign.center,
                                    style: bodyStyle.copyWith(fontSize: 13.5),
                                  ),
                                  const SizedBox(height: 18),
                                  TextField(
                                    controller: _nickname,
                                    textAlign: TextAlign.center,
                                    textCapitalization: TextCapitalization.words,
                                    style: GoogleFonts.nunito(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                      color: SetupColors.white,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Your nickname…",
                                      hintStyle: GoogleFonts.nunito(
                                        color: SetupColors.white.withValues(alpha: 0.45),
                                        fontWeight: FontWeight.w700,
                                      ),
                                      filled: true,
                                      fillColor: SetupColors.surfaceDark.withValues(alpha: 0.55),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(999),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    onSubmitted: (_) => _continue(),
                                  ),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    height: 52,
                                    child: FilledButton(
                                      style: nicknameReady
                                          ? FilledButton.styleFrom(
                                              backgroundColor: SetupColors.white,
                                              foregroundColor: SetupColors.ink,
                                              elevation: 0,
                                              shape: const StadiumBorder(),
                                            )
                                          : FilledButton.styleFrom(
                                              backgroundColor: SetupColors.white.withValues(alpha: 0.18),
                                              foregroundColor: SetupColors.white.withValues(alpha: 0.55),
                                              elevation: 0,
                                              shape: const StadiumBorder(),
                                              side: BorderSide(color: SetupColors.white.withValues(alpha: 0.22)),
                                            ),
                                      onPressed: _continue,
                                      child: Text(
                                        "Continue",
                                        style: OreTypography.button(color: nicknameReady ? SetupColors.ink : SetupColors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
      child: Text(
        text.toUpperCase(),
        style: OreTypography.eyebrow().copyWith(fontSize: 10.5),
      ),
    );
  }
}

