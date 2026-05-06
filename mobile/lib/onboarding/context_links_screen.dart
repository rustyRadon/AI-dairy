import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";

import "onboarding_state.dart";
import "phase2_noise_filter_screen.dart";
import "../shared/ui/glass_card.dart";
import "../shared/ui/ore_typography.dart";
import "widgets/onboarding_background.dart";
import "widgets/ore_avatar.dart";
import "widgets/setup_colors.dart";

class OnboardingContextLinksScreen extends StatefulWidget {
  const OnboardingContextLinksScreen({
    super.key,
    required this.nickname,
    required this.email,
  });

  final String nickname;
  final String email;

  @override
  State<OnboardingContextLinksScreen> createState() => _OnboardingContextLinksScreenState();
}

class _OnboardingContextLinksScreenState extends State<OnboardingContextLinksScreen> {
  final _website = TextEditingController();
  final _instagram = TextEditingController();
  final _x = TextEditingController();

  OnboardingState get _baseState => OnboardingState(nickname: widget.nickname, email: widget.email);

  @override
  void initState() {
    super.initState();
    _website.addListener(() => setState(() {}));
    _instagram.addListener(() => setState(() {}));
    _x.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _website.dispose();
    _instagram.dispose();
    _x.dispose();
    super.dispose();
  }

  bool get _hasAnyInput =>
      _website.text.trim().isNotEmpty || _instagram.text.trim().isNotEmpty || _x.text.trim().isNotEmpty;

  String? _normalizeHandleOrUrl(String raw) {
    final v = raw.trim();
    if (v.isEmpty) return null;
    return v;
  }

  Future<void> _continueWithAnalysis() async {
    if (!_hasAnyInput) {
      _goNext(_baseState);
      return;
    }

    final website = _normalizeHandleOrUrl(_website.text);
    final instagram = _normalizeHandleOrUrl(_instagram.text);
    final xHandle = _normalizeHandleOrUrl(_x.text);

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _AnalyzingDialog(),
    );

    if (!mounted) return;
    _goNext(
      _baseState.copyWith(
        website: website,
        instagram: instagram,
        xHandle: xHandle,
      ),
    );
  }

  void _goNext(OnboardingState s) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => Phase2NoiseFilterScreen(state: s),
      ),
    );
  }

  void _skip() {
    _goNext(_baseState);
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = OreTypography.heroH2();
    final bodyStyle = OreTypography.body();

    return Scaffold(
      backgroundColor: SetupColors.bgBlack,
      body: OnboardingBackground(
        color: SetupColors.bgBlack,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: SetupColors.white.withValues(alpha: 0.82),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: _skip,
                    child: Text(
                      "Skip",
                      style: OreTypography.body(color: SetupColors.white.withValues(alpha: 0.8)).copyWith(
                        fontWeight: FontWeight.w800,
                        decoration: TextDecoration.underline,
                        decorationColor: SetupColors.white.withValues(alpha: 0.35),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              Expanded(
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(
                        28,
                        0,
                        28,
                        24 + MediaQuery.of(context).padding.bottom,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: Column(
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
                                      _StepPill(text: "Step 3/4"),
                                    ],
                                  ),
                                  const SizedBox(height: 14),
                                  Text(
                                    "Drop your links —\nlet’s learn your vibe.",
                                    textAlign: TextAlign.center,
                                    style: titleStyle,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Optional. We use your public context to shape your tone and prompts  not to post anything.",
                                    textAlign: TextAlign.center,
                                    style: bodyStyle.copyWith(fontSize: 13.5),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Paste your website + socials below.",
                                    textAlign: TextAlign.center,
                                    style: OreTypography.body(color: SetupColors.white.withValues(alpha: 0.62))
                                        .copyWith(fontSize: 13),
                                  ),
                                  const SizedBox(height: 18),
                                  _PillInput(
                                    controller: _website,
                                    label: "Website",
                                    hint: "Paste website URL (e.g. https://ore.so)",
                                    leading: _svgLogo("assets/images/browser-safari-svgrepo-com.svg"),
                                  ),
                                  const SizedBox(height: 12),
                                  _PillInput(
                                    controller: _instagram,
                                    label: "Instagram",
                                    hint: "Paste IG handle (e.g. @ore)",
                                    leading: _svgLogo("assets/images/instagram-2-1-logo-svgrepo-com.svg"),
                                  ),
                                  const SizedBox(height: 12),
                                  _PillInput(
                                    controller: _x,
                                    label: "X",
                                    hint: "Paste X handle (e.g. @ore)",
                                    leading: _svgLogo("assets/images/twitter-logo-svgrepo-com.svg"),
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
                                      onPressed: _continueWithAnalysis,
                                      child: Text(
                                        _hasAnyInput ? "Analyze my vibe" : "Continue",
                                        style: OreTypography.button(color: SetupColors.ink),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  Wrap(
                                    alignment: WrapAlignment.center,
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      _chip("Private"),
                                      _chip("Optional"),
                                      _chip("You control it"),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
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

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
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

  Widget _svgLogo(String assetPath) {
    return SizedBox(
      width: 22,
      height: 22,
      child: SvgPicture.asset(
        assetPath,
        fit: BoxFit.contain,
        placeholderBuilder: (_) => Center(
          child: SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: SetupColors.white.withValues(alpha: 0.55),
            ),
          ),
        ),
        // If the SVG has an unsupported feature, show a safe fallback.
        errorBuilder: (_, __, ___) => Icon(
          Icons.broken_image_rounded,
          size: 18,
          color: SetupColors.white.withValues(alpha: 0.7),
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

class _PillInput extends StatelessWidget {
  const _PillInput({
    required this.controller,
    required this.label,
    required this.hint,
    required this.leading,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final Widget leading;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: SetupColors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: SetupColors.white.withValues(alpha: 0.16)),
      ),
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
      child: Row(
        children: [
          leading,
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label.toUpperCase(),
                  style: OreTypography.eyebrow().copyWith(letterSpacing: 1.0, fontSize: 10.5),
                ),
                TextField(
                  controller: controller,
                  style: OreTypography.body().copyWith(
                    fontWeight: FontWeight.w800,
                    color: SetupColors.white,
                    height: 1.2,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    hintText: hint,
                    hintStyle: OreTypography.body(color: SetupColors.white.withValues(alpha: 0.45))
                        .copyWith(fontSize: 14),
                    contentPadding: const EdgeInsets.only(top: 4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AnalyzingDialog extends StatefulWidget {
  const _AnalyzingDialog();

  @override
  State<_AnalyzingDialog> createState() => _AnalyzingDialogState();
}

class _AnalyzingDialogState extends State<_AnalyzingDialog> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 2400), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: SingleChildScrollView(
          child: GlassCard(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
            borderRadius: BorderRadius.circular(26),
            blurSigma: 22,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    _dot(SetupColors.accentRed),
                    const SizedBox(width: 8),
                    _dot(SetupColors.accentYellow),
                    const SizedBox(width: 8),
                    _dot(SetupColors.accentGreen),
                    const Spacer(),
                    Text("AI", style: OreTypography.eyebrow()),
                  ],
                ),
                const SizedBox(height: 16),
                Text("Analyzing your vibe…", textAlign: TextAlign.center, style: OreTypography.heroH2()),
                const SizedBox(height: 10),
                Text(
                  "Reading public context · matching tone · building your prompts",
                  textAlign: TextAlign.center,
                  style: OreTypography.body().copyWith(fontSize: 13.5),
                ),
                const SizedBox(height: 18),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: SizedBox(
                    height: 10,
                    width: double.infinity,
                    child: LinearProgressIndicator(
                      value: null,
                      minHeight: 10,
                      backgroundColor: SetupColors.white.withValues(alpha: 0.12),
                      color: SetupColors.accentYellow,
                      semanticsLabel: "Analyzing",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dot(Color c) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: c,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: c.withValues(alpha: 0.35), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
    );
  }
}

