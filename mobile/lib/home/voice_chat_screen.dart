import "package:flutter/material.dart";

import "../onboarding/welcome_screen.dart";
import "../shared/widgets/screen_frame.dart";
import "../shared/widgets/status_row.dart";
import "../shared/widgets/white_card.dart";
import "text_chat_screen.dart";

class VoiceChatScreen extends StatefulWidget {
  const VoiceChatScreen({super.key, required this.userName});
  final String userName;

  @override
  State<VoiceChatScreen> createState() => _VoiceChatScreenState();
}

class _VoiceChatScreenState extends State<VoiceChatScreen> {
  bool _listening = true;
  bool _speaking = false;

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(
      title: "Hello ${widget.userName}",
      subtitle: "Talk out loud. Ọ̀rẹ́ listens and answers back.",
      trailing: IconButton(
        icon: const Icon(Icons.close, color: Colors.white),
        onPressed: () => Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const OnboardingWelcomeScreen()),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          StatusRow(
            label: "Listening",
            active: _listening,
            icon: Icons.hearing,
          ),
          const SizedBox(height: 10),
          StatusRow(
            label: "Speaking",
            active: _speaking,
            icon: Icons.volume_up,
          ),
          const SizedBox(height: 14),
          WhiteCard(
            height: 210,
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Transcribing…",
                style: TextStyle(
                  color: Colors.black.withValues(alpha: 0.55),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFFFF4FA3),
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    setState(() {
                      _listening = !_listening;
                      _speaking = false;
                    });
                  },
                  child: Text(_listening ? "Stop" : "Listen"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFFF4FA3),
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    setState(() {
                      _speaking = !_speaking;
                      _listening = false;
                    });
                  },
                  child: Text(_speaking ? "Mute" : "Speak"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: BorderSide(color: Colors.white.withValues(alpha: 0.8)),
              shape: const StadiumBorder(),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => TextChatScreen(userName: widget.userName),
                ),
              );
            },
            child: const Text("Open text chat"),
          ),
          const SizedBox(height: 18),
        ],
      ),
    );
  }
}

