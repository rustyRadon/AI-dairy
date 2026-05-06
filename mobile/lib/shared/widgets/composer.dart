import "package:flutter/material.dart";

class Composer extends StatelessWidget {
  const Composer({
    super.key,
    required this.controller,
    required this.onSend,
    this.onAttach,
    this.onVoiceNote,
    this.hintText = "Message",
  });
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback? onAttach;
  final VoidCallback? onVoiceNote;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        IconButton(
          tooltip: "Add",
          onPressed: onAttach,
          icon: Icon(
            Icons.add_rounded,
            color: cs.onSurface.withValues(alpha: 0.75),
          ),
        ),
        if (onVoiceNote != null)
          IconButton(
            tooltip: "Voice note",
            onPressed: onVoiceNote,
            icon: Icon(
              Icons.mic_none_rounded,
              color: cs.onSurface.withValues(alpha: 0.75),
            ),
          ),
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: cs.onSurface.withValues(alpha: 0.10)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.center,
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                isDense: true,
              ),
              style: TextStyle(
                color: cs.onSurface.withValues(alpha: 0.92),
                fontWeight: FontWeight.w600,
              ),
              onSubmitted: (_) => onSend(),
            ),
          ),
        ),
        const SizedBox(width: 10),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: cs.onSurface.withValues(alpha: 0.12),
            foregroundColor: cs.onSurface.withValues(alpha: 0.90),
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          onPressed: onSend,
          child: const Icon(Icons.send, size: 18),
        ),
      ],
    );
  }
}

