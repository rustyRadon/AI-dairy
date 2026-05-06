import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";

class ThemeController extends ChangeNotifier {
  ThemeController._(this._mode);

  static const _prefsKey = "theme_mode";

  ThemeMode _mode;
  ThemeMode get mode => _mode;

  bool get isLight => _mode == ThemeMode.light;

  static Future<ThemeController> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    final mode = switch (raw) {
      "light" => ThemeMode.light,
      "dark" => ThemeMode.dark,
      _ => ThemeMode.dark,
    };
    return ThemeController._(mode);
  }

  Future<void> setLight(bool light) async {
    final next = light ? ThemeMode.light : ThemeMode.dark;
    if (next == _mode) return;
    _mode = next;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, light ? "light" : "dark");
  }
}

class ThemeScope extends InheritedNotifier<ThemeController> {
  const ThemeScope({
    super.key,
    required ThemeController controller,
    required super.child,
  }) : super(notifier: controller);

  static ThemeController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ThemeScope>();
    assert(scope != null, "ThemeScope not found above in widget tree.");
    return scope!.notifier!;
  }
}

