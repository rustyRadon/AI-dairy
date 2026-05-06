import "package:flutter/material.dart";

import "../shared/widgets/screen_frame.dart";
import "../shared/widgets/white_card.dart";

/// Past voice sessions with Ọ̀rẹ́ — browse summaries (UI-only demo data for now).
class ConversationHistoryScreen extends StatelessWidget {
  const ConversationHistoryScreen({super.key, required this.userName});
  final String userName;

  static const _sessions = <_PastSession>[
    _PastSession(
      when: "Today · 9:14 AM",
      title: "Before the meeting",
      summary:
          "You said the week felt loud. We named one anchor task and left the rest for later.",
    ),
    _PastSession(
      when: "Yesterday · 6:40 PM",
      title: "Wind-down",
      summary:
          "Short check-in: sleep, boundaries, and one kind thing for tomorrow-you.",
    ),
    _PastSession(
      when: "Mon · 1:22 PM",
      title: "Scattered thoughts",
      summary:
          "Ideas were bouncing; we grouped them into “now” vs “later” without forcing a plan.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final onBg = cs.onSurface;
    final sub = onBg.withValues(alpha: 0.60);

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: ScreenFrame(
          title: "History",
          subtitle: "Past conversations with Ọ̀rẹ́ — calm summaries only.",
          leading: IconButton(
            tooltip: "Back",
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: onBg.withValues(alpha: 0.88)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          trailing: const SizedBox(width: 48),
          child: ListView(
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              Text(
                userName.trim().isEmpty
                    ? "Recent sessions"
                    : "Recent sessions · ${userName.trim()}",
                style: TextStyle(
                  color: sub,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 12),
              for (var i = 0; i < _sessions.length; i++) ...[
                if (i > 0) const SizedBox(height: 12),
                _HistoryEntryCard(session: _sessions[i], onBg: onBg, sub: sub),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _PastSession {
  const _PastSession({
    required this.when,
    required this.title,
    required this.summary,
  });
  final String when;
  final String title;
  final String summary;
}

class _HistoryEntryCard extends StatelessWidget {
  const _HistoryEntryCard({
    required this.session,
    required this.onBg,
    required this.sub,
  });

  final _PastSession session;
  final Color onBg;
  final Color sub;

  @override
  Widget build(BuildContext context) {
    return WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            session.when,
            style: TextStyle(
              color: sub,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            session.title,
            style: TextStyle(
              color: onBg.withValues(alpha: 0.92),
              fontWeight: FontWeight.w800,
              fontSize: 16,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            session.summary,
            style: TextStyle(
              color: onBg.withValues(alpha: 0.72),
              fontWeight: FontWeight.w600,
              height: 1.35,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
