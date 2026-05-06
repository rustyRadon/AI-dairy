import "package:flutter/material.dart";

import "../home/home_shell.dart";
import "../onboarding/widgets/onboarding_background.dart";
import "../onboarding/widgets/setup_colors.dart";
import "../shared/ui/glass_card.dart";
import "../shared/ui/ore_typography.dart";
import "../shared/widgets/pill_field.dart";

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _name = TextEditingController();
  final _pin = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _pin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Ọ̀rẹ́",
                                style: OreTypography.eyebrow().copyWith(
                                  fontSize: 12,
                                  letterSpacing: 0.9,
                                ),
                              ),
                              const SizedBox(width: 10),
                              _Dot(c: SetupColors.accentYellow),
                              const SizedBox(width: 6),
                              _Dot(c: SetupColors.accentGreen),
                              const SizedBox(width: 6),
                              _Dot(c: SetupColors.accentRed),
                            ],
                          ),
                          const SizedBox(height: 16),
                          GlassCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text("Sign in", textAlign: TextAlign.center, style: OreTypography.heroH2()),
                                const SizedBox(height: 10),
                                Text(
                                  "Welcome back. Pick up where you left off — voice, thread, and shadow calendar.",
                                  textAlign: TextAlign.center,
                                  style: OreTypography.body().copyWith(fontSize: 13.5),
                                ),
                                const SizedBox(height: 18),
                                PillField(
                                  controller: _name,
                                  hintText: "Name or nickname",
                                  fillColor: SetupColors.white.withValues(alpha: 0.12),
                                  hintColor: SetupColors.white.withValues(alpha: 0.45),
                                  textColor: SetupColors.white,
                                  borderColor: SetupColors.white.withValues(alpha: 0.16),
                                ),
                                const SizedBox(height: 12),
                                PillField(
                                  controller: _pin,
                                  hintText: "PIN",
                                  obscureText: true,
                                  fillColor: SetupColors.white.withValues(alpha: 0.12),
                                  hintColor: SetupColors.white.withValues(alpha: 0.45),
                                  textColor: SetupColors.white,
                                  borderColor: SetupColors.white.withValues(alpha: 0.16),
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  height: 54,
                                  child: FilledButton(
                                    style: FilledButton.styleFrom(
                                      backgroundColor: SetupColors.white,
                                      foregroundColor: SetupColors.ink,
                                      elevation: 0,
                                      shape: const StadiumBorder(),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute<void>(
                                          builder: (_) => HomeShell(userName: _name.text),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text("Continue", style: OreTypography.button(color: SetupColors.ink)),
                                        const SizedBox(width: 10),
                                        const Icon(Icons.arrow_forward_rounded, size: 20),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            "Structured voice · DNA context · Verified commitments",
                            textAlign: TextAlign.center,
                            style: OreTypography.eyebrow().copyWith(
                              fontSize: 10.5,
                              color: SetupColors.white.withValues(alpha: 0.55),
                            ),
                          ),
                        ],
                      ),
                    ),
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

class _Dot extends StatelessWidget {
  const _Dot({required this.c});
  final Color c;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: c,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: c.withValues(alpha: 0.35), blurRadius: 8, offset: const Offset(0, 3))],
      ),
    );
  }
}
