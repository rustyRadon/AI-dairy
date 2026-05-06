import "package:device_calendar/device_calendar.dart";
import "package:flutter/material.dart";
import "package:permission_handler/permission_handler.dart";

import "../shared/ui/glass_card.dart";
import "../shared/ui/ore_typography.dart";
import "onboarding_state.dart";
import "phase5_first_dump_screen.dart";
import "widgets/onboarding_background.dart";
import "widgets/ore_avatar.dart";
import "widgets/setup_colors.dart";

class Phase4PermissionsScreen extends StatefulWidget {
  const Phase4PermissionsScreen({super.key, required this.state});

  final OnboardingState state;

  @override
  State<Phase4PermissionsScreen> createState() => _Phase4PermissionsScreenState();
}

class _Phase4PermissionsScreenState extends State<Phase4PermissionsScreen> {
  bool _zkEnabled = true;
  bool _calendarGranted = false;
  bool _micGranted = false;
  bool _busy = false;

  final _calendar = DeviceCalendarPlugin();

  @override
  void initState() {
    super.initState();
    _zkEnabled = widget.state.zkEnabled;
    _calendarGranted = widget.state.calendarGranted;
    _micGranted = widget.state.microphoneGranted;
  }

  Future<void> _requestCalendar() async {
    setState(() => _busy = true);
    try {
      final r = await _calendar.hasPermissions();
      if (r.isSuccess && r.data == true) {
        setState(() => _calendarGranted = true);
        return;
      }
      final req = await _calendar.requestPermissions();
      setState(() => _calendarGranted = req.isSuccess && req.data == true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _requestMic() async {
    setState(() => _busy = true);
    try {
      final status = await Permission.microphone.request();
      setState(() => _micGranted = status.isGranted);
      if (status.isPermanentlyDenied) {
        await openAppSettings();
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _continue() async {
    final next = widget.state.copyWith(
      zkEnabled: _zkEnabled,
      calendarGranted: _calendarGranted,
      microphoneGranted: _micGranted,
    );
    await OnboardingPrefs.save(next);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => Phase5FirstDumpScreen(state: next),
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
                          const _StepPill(text: "PHASE 4"),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Center(child: AvatarCircle(size: 86)),
                      const SizedBox(height: 18),
                      GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text("Bodyguard setup", textAlign: TextAlign.center, style: OreTypography.heroH2()),
                            const SizedBox(height: 10),
                            Text(
                              "This is where I get the keys — to protect your focus, not clutter it.",
                              textAlign: TextAlign.center,
                              style: OreTypography.body().copyWith(fontSize: 14),
                            ),
                            const SizedBox(height: 16),
                            _PermissionTile(
                              title: "Calendar sync",
                              body: "Can I see your schedule? I promise to protect it, not clutter it.",
                              granted: _calendarGranted,
                              busy: _busy,
                              onPressed: _requestCalendar,
                            ),
                            const SizedBox(height: 12),
                            _PermissionTile(
                              title: "Microphone access",
                              body: "I’m a pal who listens. May I have permission to hear you?",
                              granted: _micGranted,
                              busy: _busy,
                              onPressed: _requestMic,
                            ),
                            const SizedBox(height: 14),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              decoration: BoxDecoration(
                                color: SetupColors.white.withValues(alpha: 0.10),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: SetupColors.white.withValues(alpha: 0.14)),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Secret Vault (Zero‑Knowledge)", style: OreTypography.body().copyWith(fontWeight: FontWeight.w900)),
                                        const SizedBox(height: 4),
                                        Text(
                                          "Even the creators of Ọ̀rẹ́ can’t read your notes.",
                                          style: OreTypography.body().copyWith(fontSize: 13.5, color: SetupColors.white.withValues(alpha: 0.72)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Switch(
                                    value: _zkEnabled,
                                    onChanged: (v) => setState(() => _zkEnabled = v),
                                    activeThumbColor: SetupColors.accentGreen,
                                  ),
                                ],
                              ),
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
                                onPressed: _busy ? null : _continue,
                                child: Text("Continue", style: OreTypography.button(color: SetupColors.ink)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "You can change these later in Settings.",
                        textAlign: TextAlign.center,
                        style: OreTypography.body(color: SetupColors.white.withValues(alpha: 0.55)).copyWith(fontSize: 13),
                      ),
                      const SizedBox(height: 10),
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

class _PermissionTile extends StatelessWidget {
  const _PermissionTile({
    required this.title,
    required this.body,
    required this.granted,
    required this.busy,
    required this.onPressed,
  });

  final String title;
  final String body;
  final bool granted;
  final bool busy;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: SetupColors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: SetupColors.white.withValues(alpha: 0.14)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            granted ? Icons.verified_rounded : Icons.shield_moon_outlined,
            color: granted ? SetupColors.accentGreen : SetupColors.white.withValues(alpha: 0.65),
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
          const SizedBox(width: 12),
          TextButton(
            onPressed: busy ? null : onPressed,
            child: Text(granted ? "Connected" : "Connect", style: OreTypography.body().copyWith(fontWeight: FontWeight.w900)),
          ),
        ],
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

