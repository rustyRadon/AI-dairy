import "dart:io";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_tts/flutter_tts.dart";
import "package:local_auth/local_auth.dart";
import "package:package_info_plus/package_info_plus.dart";
import "package:path_provider/path_provider.dart";
import "package:share_plus/share_plus.dart";

import "../app/settings_prefs.dart";
import "../app/theme_controller.dart";
import "../shared/widgets/screen_frame.dart";
import "settings_widgets.dart";

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
    required this.userName,
    this.onOpenKnowledgeBubbles,
  });

  final String userName;
  final VoidCallback? onOpenKnowledgeBubbles;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _nicknameCtrl = TextEditingController();
  SettingsSnapshot _s = SettingsSnapshot.defaults;
  String _version = "";
  final _tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final snap = await SettingsPrefs.load();
    final info = await PackageInfo.fromPlatform();
    if (!mounted) return;
    setState(() {
      _s = snap;
      _nicknameCtrl.text = snap.nickname;
      _version = info.version;
    });
  }

  @override
  void dispose() {
    _nicknameCtrl.dispose();
    super.dispose();
  }

  Future<void> _persist(SettingsSnapshot next) async {
    setState(() => _s = next);
    await SettingsPrefs.save(next);
  }

  void _hapticToggle() {
    final h = _s.hapticStrength;
    if (h < 0.08) return;
    if (h < 0.35) {
      HapticFeedback.selectionClick();
    } else if (h < 0.65) {
      HapticFeedback.lightImpact();
    } else {
      HapticFeedback.mediumImpact();
    }
  }

  Future<void> _setBiometric(bool enable) async {
    if (enable) {
      final auth = LocalAuthentication();
      final okDevice = await auth.isDeviceSupported();
      final canBio = await auth.canCheckBiometrics;
      if (!okDevice && !canBio) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Biometrics aren’t available on this device.")),
        );
        return;
      }
      try {
        final ok = await auth.authenticate(
          localizedReason: "Enable Face ID or fingerprint to lock Ọ̀rẹ́.",
        );
        if (!ok) return;
      } catch (_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Couldn’t verify biometrics.")),
        );
        return;
      }
    }
    _hapticToggle();
    await _persist(_s.copyWith(biometricLock: enable));
  }

  Future<void> _exportMind() async {
    final nickname = _s.nickname.trim().isEmpty ? widget.userName : _s.nickname.trim();
    final retentionLabel = switch (_s.dataRetentionDays) {
      -1 => "Keep indefinitely",
      7 => "7 days",
      30 => "30 days",
      90 => "90 days",
      _ => "${_s.dataRetentionDays} days",
    };
    final styleLabel = switch (_s.conversationalStyle) {
      0 => "Listener",
      2 => "Coach",
      _ => "Balanced",
    };
    final buf = StringBuffer()
      ..writeln("# Ọ̀rẹ́ — Download My Mind")
      ..writeln()
      ..writeln("Generated: ${DateTime.now().toUtc().toIso8601String()}")
      ..writeln()
      ..writeln("## You")
      ..writeln("- Name / nickname: $nickname")
      ..writeln("- Voice preset: ${_voiceTitle(_s.voiceIndex)}")
      ..writeln("- Style: $styleLabel")
      ..writeln("- Personal context (Ọ̀rẹ́ memory): ${_s.echoMemoryEnabled ? "on" : "off"}")
      ..writeln("- Incognito next session: ${_s.incognitoNextSession ? "on" : "off"}")
      ..writeln("- Data retention: $retentionLabel")
      ..writeln()
      ..writeln("## Reflections")
      ..writeln(
        "_Here is where exported journal entries and timeline cards would stream in. "
        "This build includes your settings snapshot so the file is still meaningful._",
      )
      ..writeln()
      ..writeln("— With care, Ọ̀rẹ́");

    final dir = await getTemporaryDirectory();
    final file = File("${dir.path}/ore_mind_export.md");
    await file.writeAsString(buf.toString());
    if (!mounted) return;
    await Share.shareXFiles(
      [XFile(file.path)],
      subject: "Ọ̀rẹ́ — Download My Mind",
    );
  }

  Future<void> _confirmReset() async {
    final cs = Theme.of(context).colorScheme;
    final on = cs.onSurface;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(
            "Reset Ọ̀rẹ́?",
            style: TextStyle(color: on, fontWeight: FontWeight.w800),
          ),
          content: Text(
            "This will wipe everything Ọ̀rẹ́ has learned about you in this app, including "
            "personality, privacy choices, calendar stubs, and session preferences. "
            "You’ll start from day one. Your light/dark theme will stay as it is.\n\n"
            "Are you sure?",
            style: TextStyle(
              color: on.withValues(alpha: 0.78),
              height: 1.35,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text("Cancel"),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: cs.error,
                foregroundColor: cs.onError,
              ),
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text("Reset everything"),
            ),
          ],
        );
      },
    );
    if (ok != true || !mounted) return;
    await SettingsPrefs.wipeOreState();
    if (!mounted) return;
    _nicknameCtrl.text = "";
    setState(() => _s = SettingsSnapshot.defaults);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Ọ̀rẹ́ has been reset. You’re on day one.")),
    );
  }

  String _voiceTitle(int i) {
    if (i < 0 || i >= _voiceTitles.length) return _voiceTitles.first;
    return _voiceTitles[i];
  }

  Future<void> _openVoicePicker() async {
    await _tts.stop();
    await _tts.setLanguage("en-US");
    await _tts.setSpeechRate(0.42);

    if (!mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: StatefulBuilder(
              builder: (context, setModal) {
                return RadioGroup<int>(
                  groupValue: _s.voiceIndex,
                  onChanged: (v) async {
                    _hapticToggle();
                    await _persist(_s.copyWith(voiceIndex: v));
                    if (ctx.mounted) setModal(() {});
                  },
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Text(
                        "Voice tone",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 12),
                      for (var i = 0; i < _voiceTitles.length; i++) ...[
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            _voiceTitles[i],
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                          subtitle: Text(
                            _voiceBlurbs[i],
                            style: settingsSubtextStyle(context),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                tooltip: "Play sample",
                                onPressed: () async {
                                  await _tts.stop();
                                  await _tts.speak(_voiceSamples[i]);
                                },
                                icon: const Icon(Icons.play_circle_outline_rounded),
                              ),
                              Radio<int>(value: i),
                            ],
                          ),
                          onTap: () async {
                            _hapticToggle();
                            await _persist(_s.copyWith(voiceIndex: i));
                            if (ctx.mounted) setModal(() {});
                          },
                        ),
                        if (i != _voiceTitles.length - 1) const Divider(height: 1),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  String _fmtTime(BuildContext context, int minutes) {
    final h = (minutes ~/ 60) % 24;
    final m = minutes % 60;
    return TimeOfDay(hour: h, minute: m).format(context);
  }

  Future<void> _pickDndStart() async {
    final initial = TimeOfDay(
      hour: (_s.dndStartMinutes ~/ 60) % 24,
      minute: _s.dndStartMinutes % 60,
    );
    final t = await showTimePicker(context: context, initialTime: initial);
    if (t == null || !mounted) return;
    final min = t.hour * 60 + t.minute;
    await _persist(_s.copyWith(dndStartMinutes: min));
  }

  Future<void> _pickDndEnd() async {
    final initial = TimeOfDay(
      hour: (_s.dndEndMinutes ~/ 60) % 24,
      minute: _s.dndEndMinutes % 60,
    );
    final t = await showTimePicker(context: context, initialTime: initial);
    if (t == null || !mounted) return;
    final min = t.hour * 60 + t.minute;
    await _persist(_s.copyWith(dndEndMinutes: min));
  }

  Future<void> _openEmailReflections() async {
    if (!mounted) return;
    final on = Theme.of(context).colorScheme.onSurface;
    await showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text("Email & reflections", style: TextStyle(color: on, fontWeight: FontWeight.w800)),
          content: Text(
            "Weekly mirrors and reflection digests by email are coming soon. "
            "You’ll choose frequency and tone here.",
            style: TextStyle(
              color: on.withValues(alpha: 0.72),
              height: 1.35,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeScope.of(context);
    final cs = Theme.of(context).colorScheme;
    final on = cs.onSurface;
    final letter = widget.userName.trim().isEmpty
        ? "?"
        : widget.userName.trim().characters.first.toUpperCase();

    return ScreenFrame(
      title: "Settings",
      subtitle: "Change how Ọ̀rẹ́ sounds, stays private, and fits your day.",
      leading: CircleAvatar(
        backgroundColor: on.withValues(alpha: 0.1),
        foregroundColor: on,
        child: Text(letter, style: const TextStyle(fontWeight: FontWeight.w800)),
      ),
      trailing: const SizedBox(width: 48),
      child: ListView(
        padding: const EdgeInsets.only(bottom: 28),
        children: [
          const SizedBox(height: 4),
          Text(
            widget.userName.trim().isEmpty ? "Friend" : widget.userName.trim(),
            style: TextStyle(
              color: on.withValues(alpha: 0.88),
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
          const SettingsSectionHeader(title: "THE PAL"),
          SettingsSoftCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SettingsTileNav(
                  title: "Voice tone",
                  subtitle: _voiceTitle(_s.voiceIndex),
                  onTap: _openVoicePicker,
                ),
                const SizedBox(height: 14),
                Text("Interaction style", style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(
                  "How Ọ̀rẹ́ joins the conversation.",
                  style: settingsSubtextStyle(context),
                ),
                const SizedBox(height: 10),
                SegmentedButton<int>(
                  showSelectedIcon: false,
                  style: SegmentedButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                  ),
                  segments: const [
                    ButtonSegment<int>(
                      value: 0,
                      label: Text("Listen", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                      tooltip: "Ọ̀rẹ́ never interrupts",
                    ),
                    ButtonSegment<int>(
                      value: 1,
                      label: Text("Balance", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                      tooltip: "Clarifying questions",
                    ),
                    ButtonSegment<int>(
                      value: 2,
                      label: Text("Coach", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                      tooltip: "Gentle challenges",
                    ),
                  ],
                  selected: {_s.conversationalStyle},
                  onSelectionChanged: (next) async {
                    final v = next.first;
                    _hapticToggle();
                    await _persist(_s.copyWith(conversationalStyle: v));
                  },
                ),
                const SizedBox(height: 6),
                Text(
                  switch (_s.conversationalStyle) {
                    0 => "Ọ̀rẹ́ holds space — minimal interruptions.",
                    1 => "Ọ̀rẹ́ asks short, caring clarifiers.",
                    _ => "Ọ̀rẹ́ reflects and probes with kindness.",
                  },
                  style: settingsSubtextStyle(context),
                ),
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 12),
                Text("Nickname", style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text(
                  "What Ọ̀rẹ́ calls you in-session.",
                  style: settingsSubtextStyle(context),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _nicknameCtrl,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    hintText: "e.g. \"Alex\" or \"friend\"",
                    filled: true,
                    fillColor: cs.surface.withValues(alpha: 0.5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: on.withValues(alpha: 0.12)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: on.withValues(alpha: 0.12)),
                    ),
                  ),
                  onSubmitted: (v) async {
                    _hapticToggle();
                    await _persist(_s.copyWith(nickname: v.trim()));
                  },
                ),
                const SizedBox(height: 16),
                SettingsTileSwitch(
                  title: "Ọ̀rẹ́’s memory",
                  subtitle:
                      "Personal context — birthdays, names, little details you’ve shared.",
                  value: _s.echoMemoryEnabled,
                  onChanged: (v) async {
                    _hapticToggle();
                    await _persist(_s.copyWith(echoMemoryEnabled: v));
                  },
                ),
              ],
            ),
          ),
          const SettingsSectionHeader(title: "THE VAULT"),
          SettingsVaultPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SettingsTileSwitch(
                  title: "Biometric lock",
                  subtitle: "Face ID / fingerprint before opening Ọ̀rẹ́.",
                  value: _s.biometricLock,
                  onChanged: _setBiometric,
                ),
                const SizedBox(height: 14),
                SettingsTileSwitch(
                  title: "Incognito next session",
                  subtitle:
                      "Ghost mode — the next live session won’t feed Business DNA or the timeline.",
                  value: _s.incognitoNextSession,
                  onChanged: (v) async {
                    _hapticToggle();
                    await _persist(_s.copyWith(incognitoNextSession: v));
                  },
                ),
                const SizedBox(height: 14),
                Text("Data retention", style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text(
                  "How long raw session captures stay on device before purging.",
                  style: settingsSubtextStyle(context),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: cs.surface.withValues(alpha: 0.35),
                      border: Border.all(color: on.withValues(alpha: 0.12)),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: DropdownButton<int>(
                        value: _retentionValues.contains(_s.dataRetentionDays)
                            ? _s.dataRetentionDays
                            : 30,
                        isExpanded: true,
                        underline: const SizedBox.shrink(),
                        borderRadius: BorderRadius.circular(16),
                        items: const [
                          DropdownMenuItem(value: 7, child: Text("7 days")),
                          DropdownMenuItem(value: 30, child: Text("30 days")),
                          DropdownMenuItem(value: 90, child: Text("90 days")),
                          DropdownMenuItem(value: -1, child: Text("Keep until I delete")),
                        ],
                        onChanged: (v) async {
                          if (v == null) return;
                          _hapticToggle();
                          await _persist(_s.copyWith(dataRetentionDays: v));
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SettingsTileNav(
                  title: "Memory & knowledge bubbles",
                  subtitle: "Open Business DNA on the knowledge you’ve shared.",
                  onTap: () {
                    _hapticToggle();
                    widget.onOpenKnowledgeBubbles?.call();
                  },
                ),
                const SizedBox(height: 12),
                SettingsTileNav(
                  title: "Download My Mind",
                  subtitle: "Export reflections as a Markdown file you can share or archive.",
                  onTap: () async {
                    _hapticToggle();
                    await _exportMind();
                  },
                ),
              ],
            ),
          ),
          const SettingsSectionHeader(title: "CONNECTION"),
          SettingsSoftCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("Calendar hub", style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text(
                  "Sync events so Ọ̀rẹ́ can respect your real schedule.",
                  style: settingsSubtextStyle(context),
                ),
                const SizedBox(height: 12),
                SettingsTileSwitch(
                  title: "Google Calendar",
                  subtitle: _s.calendarGoogleEnabled ? "Connected (demo)" : "Not connected",
                  value: _s.calendarGoogleEnabled,
                  onChanged: (v) async {
                    _hapticToggle();
                    await _persist(_s.copyWith(calendarGoogleEnabled: v));
                  },
                ),
                const SizedBox(height: 6),
                SettingsTileSwitch(
                  title: "Outlook",
                  subtitle: _s.calendarOutlookEnabled ? "Connected (demo)" : "Not connected",
                  value: _s.calendarOutlookEnabled,
                  onChanged: (v) async {
                    _hapticToggle();
                    await _persist(_s.copyWith(calendarOutlookEnabled: v));
                  },
                ),
                const SizedBox(height: 14),
                const Divider(height: 1),
                const SizedBox(height: 12),
                SettingsTileNav(
                  title: "Email & reflections",
                  subtitle: "Choose how mirrors reach your inbox (coming soon).",
                  onTap: () {
                    _hapticToggle();
                    _openEmailReflections();
                  },
                ),
                const SizedBox(height: 14),
                SettingsTileSwitch(
                  title: "Reflection quiet hours",
                  subtitle:
                      "${_fmtTime(context, _s.dndStartMinutes)} – ${_fmtTime(context, _s.dndEndMinutes)}",
                  value: _s.dndEnabled,
                  onChanged: (v) async {
                    _hapticToggle();
                    await _persist(_s.copyWith(dndEnabled: v));
                  },
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _pickDndStart,
                        child: const Text("Start time"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _pickDndEnd,
                        child: const Text("End time"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text("Haptics during sessions", style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text(
                  "Light taps when Ọ̀rẹ́ reacts — also applies to these settings switches.",
                  style: settingsSubtextStyle(context),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        value: _s.hapticStrength.clamp(0.0, 1.0),
                        onChanged: (v) => setState(() => _s = _s.copyWith(hapticStrength: v)),
                        onChangeEnd: (v) async {
                          HapticFeedback.selectionClick();
                          await _persist(_s.copyWith(hapticStrength: v));
                        },
                      ),
                    ),
                    Text(
                      _s.hapticStrength < 0.15 ? "Off" : "On",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: on.withValues(alpha: 0.55),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SettingsSectionHeader(title: "APPEARANCE"),
          SettingsSoftCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            "Light mode",
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "White background. Dark text.",
                            style: settingsSubtextStyle(context),
                          ),
                        ],
                      ),
                    ),
                    AnimatedBuilder(
                      animation: theme,
                      builder: (context, _) {
                        return Switch.adaptive(
                          value: theme.isLight,
                          onChanged: (v) async {
                            _hapticToggle();
                            await theme.setLight(v);
                          },
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 12),
                SettingsTileSwitch(
                  title: "Sound",
                  subtitle: "Soft taps and gentle chimes (UI-only).",
                  value: _s.soundEnabled,
                  onChanged: (v) async {
                    _hapticToggle();
                    await _persist(_s.copyWith(soundEnabled: v));
                  },
                ),
                const SizedBox(height: 6),
                SettingsTileSwitch(
                  title: "Motion",
                  subtitle: "Smooth fades (about 0.2s).",
                  value: _s.motionEnabled,
                  onChanged: (v) async {
                    _hapticToggle();
                    await _persist(_s.copyWith(motionEnabled: v));
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Center(
            child: Text(
              _version.isEmpty ? "Ọ̀rẹ́" : "Version $_version",
              style: settingsSubtextStyle(context),
            ),
          ),
          const SizedBox(height: 12),
          SettingsSoftCard(
            child: SettingsTileNav(
              title: "Reset Ọ̀rẹ́",
              subtitle: "Erase learned context and start from day one. Theme is kept.",
              onTap: _confirmReset,
            ),
          ),
        ],
      ),
    );
  }
}

const _retentionValues = [7, 30, 90, -1];

const _voiceTitles = [
  "Warm alto",
  "Calm tenor",
  "Bright guide",
];

const _voiceBlurbs = [
  "Steady, gentle companion.",
  "Soft and unhurried.",
  "Clear and encouraging.",
];

const _voiceSamples = [
  "Hi — I’m Ọ̀rẹ́. I’m right here, and I’m not in a rush.",
  "Let’s breathe once together. Then say whatever comes.",
  "You’ve got this. What feels most true, right now?",
];
