import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

import "context_links_screen.dart";
import "../shared/ui/glass_card.dart";
import "../shared/ui/ore_typography.dart";
import "widgets/onboarding_background.dart";
import "widgets/ore_avatar.dart";
import "widgets/setup_colors.dart";

class OnboardingEmailEntryScreen extends StatefulWidget {
  const OnboardingEmailEntryScreen({super.key, required this.nickname});
  final String nickname;

  @override
  State<OnboardingEmailEntryScreen> createState() => _OnboardingEmailEntryScreenState();
}

class _OnboardingEmailEntryScreenState extends State<OnboardingEmailEntryScreen> {
  final _email = TextEditingController();

  @override
  void initState() {
    super.initState();
    _email.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  void _continue() {
    final email = _email.text.trim();
    final ok = RegExp(r"^[^\s@]+@[^\s@]+\.[^\s@]+$").hasMatch(email);
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Enter a valid email address.",
            style: GoogleFonts.nunito(fontWeight: FontWeight.w700),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => OnboardingContextLinksScreen(nickname: widget.nickname, email: email),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ready = _email.text.trim().isNotEmpty;

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
                                    children: const [
                                      _StepPill(text: "Step 2/4"),
                                    ],
                                  ),
                                  const SizedBox(height: 14),
                                  Text(
                                    "Your email, please.",
                                    textAlign: TextAlign.center,
                                    style: OreTypography.heroH2(),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "This helps us secure your space and sync your handover across devices.",
                                    textAlign: TextAlign.center,
                                    style: OreTypography.body().copyWith(fontSize: 13.5),
                                  ),
                                  const SizedBox(height: 18),
                                  TextField(
                                    controller: _email,
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.emailAddress,
                                    autocorrect: false,
                                    style: GoogleFonts.nunito(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "name@domain.com",
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
                                      style: ready
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
                                        style: OreTypography.button(color: ready ? SetupColors.ink : SetupColors.white),
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

