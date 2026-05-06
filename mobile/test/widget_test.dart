import "package:flutter_test/flutter_test.dart";

import "package:ai_diary_mobile/main.dart";
import "package:ai_diary_mobile/app/theme_controller.dart";

void main() {
  testWidgets("Onboarding welcome shows oré greeting", (tester) async {
    final theme = await ThemeController.load();
    await tester.pumpWidget(AiDiaryApp(themeController: theme));
    await tester.pumpAndSettle();
    expect(find.textContaining("oré"), findsWidgets);
    expect(find.text("HI, ORÉ"), findsOneWidget);
  });
}
