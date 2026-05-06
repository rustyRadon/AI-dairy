import "package:flutter/material.dart";

import "../shared/widgets/composer.dart";
import "../shared/widgets/screen_frame.dart";
import "../shared/widgets/white_card.dart";

class TextChatScreen extends StatefulWidget {
  const TextChatScreen({super.key, required this.userName});
  final String userName;

  @override
  State<TextChatScreen> createState() => _TextChatScreenState();
}

class _TextChatScreenState extends State<TextChatScreen> {
  final _msg = TextEditingController();
  final List<_Bubble> _bubbles = [
    _Bubble(isUser: false, text: "How was your day?"),
  ];

  @override
  void dispose() {
    _msg.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: ScreenFrame(
          title: "Hello ${widget.userName}",
          subtitle: "Type to Ọ̀rẹ́ like a text chat. Ọ̀rẹ́ writes back.",
          trailing: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemCount: _bubbles.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final b = _bubbles[i];
                    return Align(
                      alignment:
                          b.isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 280),
                        child: WhiteCard(
                          child: Text(
                            b.text,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Composer(
                controller: _msg,
                onSend: () {
                  final text = _msg.text.trim();
                  if (text.isEmpty) return;
                  setState(() {
                    _bubbles.add(_Bubble(isUser: true, text: text));
                    _bubbles.add(
                      _Bubble(isUser: false, text: "Tell me more about that."),
                    );
                  });
                  _msg.clear();
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class _Bubble {
  _Bubble({required this.isUser, required this.text});
  final bool isUser;
  final String text;
}

