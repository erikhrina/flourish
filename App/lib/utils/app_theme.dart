import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const kThemeModeKey = '__theme_mode__';
SharedPreferences? _prefs;

abstract class AppTheme {
  static Future initialize() async =>
      _prefs = await SharedPreferences.getInstance();

  static ThemeMode get themeMode {
    final darkMode = _prefs?.getBool(kThemeModeKey);
    if (darkMode == null) saveThemeMode(ThemeMode.light);
    return darkMode == null
        ? ThemeMode.light
        : darkMode
            ? ThemeMode.dark
            : ThemeMode.light;
  }

  static void saveThemeMode(ThemeMode mode) =>
      _prefs?.setBool(kThemeModeKey, mode == ThemeMode.dark);

  static AppTheme of(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? DarkModeTheme()
        : LightModeTheme();
  }

  late Color primary;
  late Color secondary;
  late Color alternate;
  late Color primaryText;
  late Color secondaryText;
  late Color primaryBackground;
  late Color secondaryBackground;

  TextStyle get titleLarge => typography.titleLarge;

  TextStyle get titleMedium => typography.titleMedium;

  TextStyle get titleSmall => typography.titleSmall;

  TextStyle get labelLarge => typography.labelLarge;

  TextStyle get labelMedium => typography.labelMedium;

  TextStyle get labelSmall => typography.labelSmall;

  TextStyle get primaryLarge => typography.primaryLarge;

  TextStyle get primaryMedium => typography.primaryMedium;

  TextStyle get primarySmall => typography.primarySmall;

  Typography get typography => ThemeTypography(this);
}

class LightModeTheme extends AppTheme {
  late Color primary = const Color(0xFF12B141);
  late Color secondary = const Color(0xFF0E9336);
  late Color primaryText = const Color(0xFF000000);
  late Color secondaryText = const Color(0xFF414141);
  late Color primaryBackground = const Color(0xFFF9F9F9);
  late Color secondaryBackground = const Color(0xFFF5F5F5);
}

abstract class Typography {
  TextStyle get titleLarge;

  TextStyle get titleMedium;

  TextStyle get titleSmall;

  TextStyle get labelLarge;

  TextStyle get labelMedium;

  TextStyle get labelSmall;

  TextStyle get primaryLarge;

  TextStyle get primaryMedium;

  TextStyle get primarySmall;
}

class ThemeTypography extends Typography {
  ThemeTypography(this.theme);

  final AppTheme theme;

  TextStyle get titleLarge => TextStyle(
        fontFamily: 'Inter',
        color: theme.primaryText,
        fontSize: 32,
        fontWeight: FontWeight.w400,
      );

  TextStyle get titleMedium => TextStyle(
        fontFamily: 'Inter',
        color: theme.primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 24.0,
      );

  TextStyle get titleSmall => TextStyle(
        fontFamily: 'Inter',
        color: theme.primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 14.0,
      );

  TextStyle get labelLarge => TextStyle(
        fontFamily: 'Inter',
        color: theme.primaryText,
        fontWeight: FontWeight.w500,
        fontSize: 32.0,
      );

  TextStyle get labelMedium => TextStyle(
        fontFamily: 'Inter',
        color: theme.primaryText,
        fontWeight: FontWeight.w500,
        fontSize: 18.0,
      );

  TextStyle get labelSmall => TextStyle(
        fontFamily: 'Inter',
        color: theme.primaryText,
        fontWeight: FontWeight.w400,
        fontSize: 14.0,
      );

  TextStyle get primaryLarge => TextStyle(
        fontFamily: 'Inter',
        color: theme.secondaryText,
        fontWeight: FontWeight.w500,
        fontSize: 16.0,
      );

  TextStyle get primaryMedium => TextStyle(
        fontFamily: 'Inter',
        color: theme.secondaryText,
        fontWeight: FontWeight.normal,
        fontSize: 12.0,
      );

  TextStyle get primarySmall => TextStyle(
        fontFamily: 'Inter',
        color: theme.secondaryText,
        fontWeight: FontWeight.w400,
        fontSize: 8.0,
      );
}

class DarkModeTheme extends AppTheme {
  late Color primary = const Color(0xFF12B141);
  late Color secondary = const Color(0xFF0E9336);
  late Color primaryText = const Color(0xFFFFFFFF);
  late Color secondaryText = const Color(0xFFC5C5C5);
  late Color primaryBackground = const Color(0xFF333333);
  late Color secondaryBackground = const Color(0xFF333333);
}
