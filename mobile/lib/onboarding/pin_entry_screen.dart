import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

import "chat_now_screen.dart";
import "../shared/ui/glass_card.dart";
import "../shared/ui/ore_typography.dart";
import "widgets/onboarding_background.dart";
import "widgets/ore_avatar.dart";
import "widgets/setup_colors.dart";

class OnboardingPinEntryScreen extends StatefulWidget {
  const OnboardingPinEntryScreen({
    super.key,
    required this.nickname,
    required this.email,
    this.website,
    this.instagram,
    this.xHandle,
  });

  final String nickname;
  final String email;
  final String? website;
  final String? instagram;
  final String? xHandle;

  @override
  State<OnboardingPinEntryScreen> createState() => _OnboardingPinEntryScreenState();
}

class _OnboardingPinEntryScreenState extends State<OnboardingPinEntryScreen> {
  final _pin = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pin.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _pin.dispose();
    super.dispose();
  }

  void _continue() {
    final pin = _pin.text.trim();
    final ok = RegExp(r"^\d{4}$").hasMatch(pin);
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "PIN must be 4 digits.",
            style: GoogleFonts.nunito(fontWeight: FontWeight.w700),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => OnboardingChatNowScreen(
          nickname: widget.nickname,
          email: widget.email,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ready = _pin.text.trim().isNotEmpty;

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
                                      _StepPill(text: "Step 4/4"),
                                    ],
                                  ),
                                  const SizedBox(height: 14),
                                  Text(
                                    "Set a PIN.",
                                    textAlign: TextAlign.center,
                                    style: OreTypography.heroH2(),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "A tiny lock for your reflections and commitments.",
                                    textAlign: TextAlign.center,
                                    style: OreTypography.body().copyWith(fontSize: 13.5),
                                  ),
                                  const SizedBox(height: 18),
                                  TextField(
                                    controller: _pin,
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    maxLength: 4,
                                    obscureText: true,
                                    style: GoogleFonts.nunito(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 18,
                                      color: Colors.white.withValues(alpha: 0.92),
                                      letterSpacing: 6,
                                    ),
                                    decoration: InputDecoration(
                                      counterText: "",
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

