import '../model/theme_preference.dart';

class PreferenceService {
  ThemePreference _themePreference;

  PreferenceService({
    ThemePreference initialTheme = ThemePreference.system,
  }) : _themePreference = initialTheme;

  ThemePreference get themePreference => _themePreference;

  bool get isLight => _themePreference == ThemePreference.light;
  bool get isDark => _themePreference == ThemePreference.dark;
  bool get isSystem => _themePreference == ThemePreference.system;

  void setThemePreference(ThemePreference preference) {
    _themePreference = preference;
  }

  void selectLightTheme() {
    _themePreference = ThemePreference.light;
  }

  void selectDarkTheme() {
    _themePreference = ThemePreference.dark;
  }

  void followSystemTheme() {
    _themePreference = ThemePreference.system;
  }

  bool isDarkMode({required bool isDeviceDark}) {
    if (_themePreference == ThemePreference.dark) {
      return true;
    }
    if (_themePreference == ThemePreference.light) {
      return false;
    }
    return isDeviceDark;
  }

  ThemePreference resolveEffectiveTheme({required bool isDeviceDark}) {
    if (_themePreference == ThemePreference.system) {
      return isDeviceDark ? ThemePreference.dark : ThemePreference.light;
    }
    return _themePreference;
  }

  void resetToDefault() {
    _themePreference = ThemePreference.system;
  }
}
