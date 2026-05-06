import "dart:math";

import "package:flutter/material.dart";

import "../onboarding/widgets/ore_avatar.dart";
import "../shared/widgets/screen_frame.dart";
import "conversation_history_screen.dart";
import "ore_space_screen.dart";
import "silent_inbox_screen.dart";

class PresenceScreen extends StatefulWidget {
  const PresenceScreen({super.key, required this.userName});
  final String userName;

  @override
  State<PresenceScreen> createState() => _PresenceScreenState();
}

class _PresenceScreenState extends State<PresenceScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _float = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 4200),
  )..repeat();

  @override
  void dispose() {
    _float.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final onBg = cs.onSurface;

    return ScreenFrame(
      title: "Presence",
      subtitle: "Take a calm breath. This is your home with your Pal.",
      trailing: IconButton(
        tooltip: "Conversation history",
        icon: Icon(
          Icons.history_rounded,
          color: onBg.withValues(alpha: 0.88),
        ),
        onPressed: () {
          Navigator.of(context).push<void>(
            MaterialPageRoute<void>(
              builder: (_) => ConversationHistoryScreen(
                userName: widget.userName,
              ),
            ),
          );
        },
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: AnimatedBuilder(
              animation: _float,
              builder: (context, _) {
                final t = _float.value;
                final dy = sin(t * pi * 2) * 8;
                return Center(
                  child: Transform.translate(
                    offset: Offset(0, dy),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 460),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Good morning, ${widget.userName}. Ready to find some peace?",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: onBg.withValues(alpha: 0.88),
                              fontWeight: FontWeight.w700,
                              height: 1.35,
                            ),
                          ),
                          const SizedBox(height: 18),
                          const OreMascot(height: 160),
                          const SizedBox(height: 18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _StartListeningOrb(
                                glow: cs.tertiary,
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                      builder: (_) => OreSpaceScreen(
                                        userName: widget.userName,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(width: 14),
                              _TextPalPill(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                      builder: (_) => SilentInboxScreen(
                                        userName: widget.userName,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Start listening",
                            style: TextStyle(
                              color: onBg.withValues(alpha: 0.86),
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StartListeningOrb extends StatelessWidget {
  const _StartListeningOrb({required this.onPressed, required this.glow});
  final VoidCallback onPressed;
  final Color glow;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      label: "Start Listening",
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onPressed,
        child: Container(
          width: 86,
          height: 86,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: cs.onSurface.withValues(alpha: 0.10),
            boxShadow: [
              BoxShadow(
                color: glow.withValues(alpha: 0.22),
                blurRadius: 26,
                spreadRadius: 6,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
            border: Border.all(
              color: cs.onSurface.withValues(alpha: 0.18),
              width: 1,
            ),
          ),
          child: const Center(
            child: Icon(Icons.mic_none_rounded, size: 30),
          ),
        ),
      ),
    );
  }
}

class _TextPalPill extends StatelessWidget {
  const _TextPalPill({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      label: "Silent Inbox",
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: cs.onSurface.withValues(alpha: 0.86),
          side: BorderSide(color: cs.onSurface.withValues(alpha: 0.18)),
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              color: cs.onSurface.withValues(alpha: 0.80),
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              "Silent Inbox",
              style: TextStyle(
                color: cs.onSurface.withValues(alpha: 0.86),
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

