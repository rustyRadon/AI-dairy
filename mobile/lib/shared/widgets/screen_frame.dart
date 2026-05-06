import "package:flutter/material.dart";

import "../../onboarding/widgets/ore_avatar.dart";

class ScreenFrame extends StatelessWidget {
  const ScreenFrame({
    super.key,
    required this.title,
    required this.trailing,
    required this.child,
    this.subtitle,
    this.leading,
    this.padding = const EdgeInsets.fromLTRB(16, 12, 16, 0),
  });

  final String title;
  final String? subtitle;
  final Widget trailing;
  final Widget child;
  final Widget? leading;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final onBg = cs.onSurface;
    return Padding(
      padding: padding,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              leading ?? _DefaultLeading(onBg: onBg),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: onBg,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: onBg.withValues(alpha: 0.62),
                          fontWeight: FontWeight.w600,
                          height: 1.2,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              trailing,
            ],
          ),
          const SizedBox(height: 12),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _DefaultLeading extends StatelessWidget {
  const _DefaultLeading({required this.onBg});
  final Color onBg;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 34,
      height: 34,
      child: ClipOval(
        child: ColoredBox(
          color: onBg.withValues(alpha: 0.10),
          child: const Center(child: OreMascot(height: 24)),
        ),
      ),
    );
  }
}

