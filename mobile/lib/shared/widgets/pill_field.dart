import "package:flutter/material.dart";

class PillField extends StatelessWidget {
  const PillField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.fillColor = Colors.white,
    this.hintColor,
    this.textColor = Colors.black87,
    this.borderColor,
  });

  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Color fillColor;
  final Color? hintColor;
  final Color textColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: hintColor ?? textColor.withValues(alpha: 0.45),
          fontWeight: FontWeight.w600,
        ),
        filled: true,
        fillColor: fillColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        border: OutlineInputBorder(
          borderSide: borderColor != null ? BorderSide(color: borderColor!) : BorderSide.none,
          borderRadius: BorderRadius.circular(999),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: borderColor != null ? BorderSide(color: borderColor!) : BorderSide.none,
          borderRadius: BorderRadius.circular(999),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: borderColor ?? Theme.of(context).colorScheme.primary,
            width: borderColor != null ? 1.5 : 2,
          ),
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }
}
