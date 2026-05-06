import "package:flutter/material.dart";

import "app/theme.dart";
import "app/theme_controller.dart";
import "onboarding/welcome_screen.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeController = await ThemeController.load();
  runApp(AiDiaryApp(themeController: themeController));
}

/// Kept in `main.dart` so tests can import `package:ai_diary_mobile/main.dart`.
class AiDiaryApp extends StatelessWidget {
  const AiDiaryApp({super.key, required this.themeController});
  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    return ThemeScope(
      controller: themeController,
      child: AnimatedBuilder(
        animation: themeController,
        builder: (context, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Ọ̀rẹ́",
            theme: buildLightTheme(),
            darkTheme: buildDarkTheme(),
            themeMode: themeController.mode,
            home: const OnboardingWelcomeScreen(),
          );
        },
      ),
    );
  }
}

