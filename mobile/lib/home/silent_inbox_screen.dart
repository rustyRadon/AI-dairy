import "package:flutter/material.dart";

import "../shared/widgets/composer.dart";
import "../shared/widgets/screen_frame.dart";
import "../shared/widgets/white_card.dart";

class SilentInboxScreen extends StatefulWidget {
  const SilentInboxScreen({super.key, required this.userName});
  final String userName;

  @override
  State<SilentInboxScreen> createState() => _SilentInboxScreenState();
}

class _SilentInboxScreenState extends State<SilentInboxScreen> {
  final _msg = TextEditingController();
  final List<_Line> _lines = [
    _Line(isUser: false, text: "I’m here. Write anything. I’ll hold it."),
  ];

  @override
  void dispose() {
    _msg.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: ScreenFrame(
          title: "Silent Inbox",
          subtitle: "Write quietly. No talking — just your words, kept safe.",
          trailing: IconButton(
            tooltip: "Close",
            icon: Icon(Icons.close, color: cs.onSurface),
            onPressed: () => Navigator.of(context).pop(),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: _lines.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final l = _lines[i];
                    return Align(
                      alignment: l.isUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 360),
                        child: WhiteCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                l.isUser ? widget.userName : "Ọ̀rẹ́",
                                style: TextStyle(
                                  color: cs.onSurface.withValues(alpha: 0.60),
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                l.text,
                                style: TextStyle(
                                  color: cs.onSurface.withValues(alpha: 0.92),
                                  fontWeight: FontWeight.w600,
                                  height: 1.35,
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
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
                child: Composer(
                  controller: _msg,
                  hintText: "Write here…",
                  onAttach: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text("Attachments (coming soon)."),
                        duration: const Duration(milliseconds: 900),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: cs.onSurface.withValues(alpha: 0.12),
                        elevation: 0,
                      ),
                    );
                  },
                  onVoiceNote: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text("Voice notes (coming soon)."),
                        duration: const Duration(milliseconds: 900),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: cs.onSurface.withValues(alpha: 0.12),
                        elevation: 0,
                      ),
                    );
                  },
                  onSend: () {
                    final text = _msg.text.trim();
                    if (text.isEmpty) return;
                    setState(() {
                      _lines.add(_Line(isUser: true, text: text));
                      _lines.add(
                        _Line(
                          isUser: false,
                          text: "Got it. I’ll hold it for later.",
                        ),
                      );
                    });
                    _msg.clear();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Line {
  _Line({required this.isUser, required this.text});
  final bool isUser;
  final String text;
}

