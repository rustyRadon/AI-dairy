import "package:flutter/material.dart";

class OreMascot extends StatelessWidget {
  const OreMascot({
    super.key,
    this.height = 118,
    this.useAlternateArtwork = false,
  });
  final double height;

  /// When true, uses the opposite mascot variant for the current brightness
  /// (e.g. sign-up hero uses the “other” look while keeping the rest of the app unchanged).
  final bool useAlternateArtwork;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final asset = useAlternateArtwork
        ? (isDark ? "assets/images/4.png" : "assets/images/2.png")
        : (isDark ? "assets/images/2.png" : "assets/images/4.png");
    return Image.asset(
      asset,
      height: height,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      semanticLabel: "Ọ̀rẹ́ mascot",
    );
  }
}

class AvatarCircle extends StatelessWidget {
  const AvatarCircle({super.key, this.size = 110, this.useAlternateArtwork = false});
  final double size;
  final bool useAlternateArtwork;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: ClipOval(
        child: ColoredBox(
          color: Colors.white,
          child: OreMascot(
            height: size * 0.78,
            useAlternateArtwork: useAlternateArtwork,
          ),
        ),
      ),
    );
  }
}

