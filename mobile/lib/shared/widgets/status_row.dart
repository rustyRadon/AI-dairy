import "package:flutter/material.dart";

class StatusRow extends StatelessWidget {
  const StatusRow({
    super.key,
    required this.label,
    required this.active,
    required this.icon,
  });

  final String label;
  final bool active;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: active ? 1 : 0.65),
            fontWeight: FontWeight.w800,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 6),
        Icon(icon, color: Colors.white.withValues(alpha: active ? 1 : 0.65), size: 18),
      ],
    );
  }
}

