import "package:flutter/material.dart";

import "../shared/widgets/screen_frame.dart";
import "../shared/widgets/tiny_toggle.dart";
import "../shared/widgets/white_card.dart";

class JournalScreen extends StatelessWidget {
  const JournalScreen({super.key, required this.userName});
  final String userName;

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(
      title: "Hello $userName",
      subtitle: "Your little notebook for thoughts you don’t want to forget.",
      trailing: const SizedBox(width: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const Text(
            "Journal",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 10),
          WhiteCard(
            height: 12,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: 0.35,
                backgroundColor: Colors.black.withValues(alpha: 0.06),
                valueColor: const AlwaysStoppedAnimation(Color(0xFFFF4FA3)),
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            "Pinned",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          const WhiteCard(height: 150),
          const SizedBox(height: 14),
          const Text(
            "Yesterday",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          const WhiteCard(height: 150),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              TinyToggle(on: true),
              SizedBox(width: 14),
              TinyToggle(on: false),
            ],
          ),
          const SizedBox(height: 14),
        ],
      ),
    );
  }
}

