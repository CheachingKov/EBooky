import 'package:flutter_test/flutter_test.dart';

import 'package:ebooky/model/theme_preference.dart';
import 'package:ebooky/service/preference_service.dart';

void main() {
  late PreferenceService preferenceService;

  setUp(() {
    preferenceService = PreferenceService();
  });

  group('PreferenceService', () {
    test('defaults to system theme', () {
      expect(preferenceService.themePreference, equals(ThemePreference.system));
      expect(preferenceService.isSystem, isTrue);
      expect(preferenceService.isLight, isFalse);
      expect(preferenceService.isDark, isFalse);
    });

    test('accepts custom initial theme in constructor', () {
      final customService = PreferenceService(
        initialTheme: ThemePreference.dark,
      );

      expect(customService.themePreference, equals(ThemePreference.dark));
      expect(customService.isDark, isTrue);
    });

    group('selectLightTheme (F30)', () {
      test('sets theme preference to light', () {
        preferenceService.selectLightTheme();

        expect(preferenceService.themePreference, equals(ThemePreference.light));
        expect(preferenceService.isLight, isTrue);
        expect(preferenceService.isDark, isFalse);
        expect(preferenceService.isSystem, isFalse);
      });

      test('isDarkMode returns false regardless of device theme', () {
        preferenceService.selectLightTheme();

        expect(preferenceService.isDarkMode(isDeviceDark: false), isFalse);
        expect(preferenceService.isDarkMode(isDeviceDark: true), isFalse);
      });

      test('resolveEffectiveTheme returns light regardless of device theme', () {
        preferenceService.selectLightTheme();

        expect(
          preferenceService.resolveEffectiveTheme(isDeviceDark: false),
          equals(ThemePreference.light),
        );
        expect(
          preferenceService.resolveEffectiveTheme(isDeviceDark: true),
          equals(ThemePreference.light),
        );
      });
    });

    group('selectDarkTheme (F31)', () {
      test('sets theme preference to dark', () {
        preferenceService.selectDarkTheme();

        expect(preferenceService.themePreference, equals(ThemePreference.dark));
        expect(preferenceService.isDark, isTrue);
        expect(preferenceService.isLight, isFalse);
        expect(preferenceService.isSystem, isFalse);
      });

      test('isDarkMode returns true regardless of device theme', () {
        preferenceService.selectDarkTheme();

        expect(preferenceService.isDarkMode(isDeviceDark: false), isTrue);
        expect(preferenceService.isDarkMode(isDeviceDark: true), isTrue);
      });

      test('resolveEffectiveTheme returns dark regardless of device theme', () {
        preferenceService.selectDarkTheme();

        expect(
          preferenceService.resolveEffectiveTheme(isDeviceDark: false),
          equals(ThemePreference.dark),
        );
        expect(
          preferenceService.resolveEffectiveTheme(isDeviceDark: true),
          equals(ThemePreference.dark),
        );
      });
    });

    group('followSystemTheme (F32)', () {
      test('sets theme preference to system', () {
        preferenceService.selectDarkTheme();
        preferenceService.followSystemTheme();

        expect(preferenceService.themePreference, equals(ThemePreference.system));
        expect(preferenceService.isSystem, isTrue);
      });

      test('follows device theme when system mode is selected', () {
        preferenceService.followSystemTheme();

        // When device is light
        expect(preferenceService.isDarkMode(isDeviceDark: false), isFalse);
        expect(
          preferenceService.resolveEffectiveTheme(isDeviceDark: false),
          equals(ThemePreference.light),
        );

        // When device is dark
        expect(preferenceService.isDarkMode(isDeviceDark: true), isTrue);
        expect(
          preferenceService.resolveEffectiveTheme(isDeviceDark: true),
          equals(ThemePreference.dark),
        );
      });
    });

    group('setThemePreference and resetToDefault', () {
      test('sets theme using setThemePreference', () {
        preferenceService.setThemePreference(ThemePreference.light);
        expect(preferenceService.isLight, isTrue);

        preferenceService.setThemePreference(ThemePreference.dark);
        expect(preferenceService.isDark, isTrue);

        preferenceService.setThemePreference(ThemePreference.system);
        expect(preferenceService.isSystem, isTrue);
      });

      test('resets theme to system default', () {
        preferenceService.selectDarkTheme();
        preferenceService.resetToDefault();

        expect(preferenceService.themePreference, equals(ThemePreference.system));
        expect(preferenceService.isSystem, isTrue);
      });
    });
  });
}
