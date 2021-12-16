import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension CustomColorScheme on ColorScheme {
  Color get selectedCell =>
      _colorByBrightness(Color(0xffc6ed4e), Color(0xff7c9432));
  Color get relatedCell =>
      _colorByBrightness(Colors.grey[200], Colors.grey[800]);
  Color get cellWithSameValue =>
      _colorByBrightness(Colors.grey[300], Colors.grey[700]);
  Color get errorCell => _colorByBrightness(Colors.red[100], Color(0xff4a000e));
  Color get errorValue => _colorByBrightness(Colors.red[400]);
  Color get selectedValue =>
      _colorByBrightness(Color(0xff83a80f), Color(0xff485c09));
  Color get accent => _colorByBrightness(Color(0xffa0cf10));

  Color _colorByBrightness(Color light, [Color dark]) {
    return brightness == Brightness.light ? light : (dark ?? light);
  }
}

class AppTheme {
  static ColorScheme get _lightColorScheme {
    return ColorScheme(
      primary: Colors.grey[900],
      primaryVariant: Colors.black,
      secondary: Colors.grey,
      secondaryVariant: Colors.grey[700],
      surface: Colors.white,
      background: Colors.grey[200],
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.black,
      onBackground: Colors.black,
      onError: Colors.white,
      brightness: Brightness.light,
    );
  }

  static ColorScheme get _darkColorScheme {
    return ColorScheme(
      primary: Colors.grey[800],
      primaryVariant: Colors.grey[800],
      secondary: Colors.grey,
      secondaryVariant: Colors.grey[700],
      surface: Colors.grey[850],
      background: Colors.grey[900],
      error: Colors.red,
      onPrimary: Colors.grey[300],
      onSecondary: Colors.black,
      onSurface: Colors.grey[400],
      onBackground: Colors.grey[300],
      onError: Colors.black,
      brightness: Brightness.dark,
    );
  }

  static ThemeData get lightTheme {
    return _getThemeData(_lightColorScheme);
  }

  static ThemeData get darkTheme {
    return _getThemeData(_darkColorScheme);
  }

  static void setSystemUIOverlayStyle(Brightness brightness) {
    if (brightness == Brightness.dark) {
      _setSystemUIOverlayStyleByColorScheme(_darkColorScheme);
    } else {
      _setSystemUIOverlayStyleByColorScheme(_lightColorScheme);
    }
  }

  static void _setSystemUIOverlayStyleByColorScheme(ColorScheme colorScheme) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: colorScheme.background,
      statusBarIconBrightness: _getOppositeBrightness(colorScheme.brightness),
      systemNavigationBarIconBrightness:
          _getOppositeBrightness(colorScheme.brightness),
      systemNavigationBarColor: colorScheme.background,
      systemNavigationBarDividerColor: colorScheme.background,
    ));
  }

  static ThemeData _getThemeData(ColorScheme colorScheme) {
    return ThemeData(
      colorScheme: colorScheme,
      primaryColor: colorScheme.primary,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(16),
              ),
            ),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(colorScheme.onBackground),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(16),
              ),
            ),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(colorScheme.onBackground),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(16),
              ),
            ),
          ),
        ),
      ),
      scaffoldBackgroundColor: colorScheme.background,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        unselectedItemColor: colorScheme.secondaryVariant,
        selectedItemColor: colorScheme.onBackground,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      splashColor: colorScheme.secondary,
      highlightColor: colorScheme.secondaryVariant,
      accentColor: colorScheme.accent,
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16),
          ),
        ),
      ),
      textTheme: TextTheme(
        bodyText2: TextStyle(),
      ).apply(bodyColor: colorScheme.onBackground),
      iconTheme: IconThemeData(
        color: colorScheme.onBackground,
      ),
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(
            color: colorScheme.secondary,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(
            color: colorScheme.onBackground,
          ),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelStyle: TextStyle(color: colorScheme.onBackground),
      ),
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: colorScheme.accent,
        cursorColor: colorScheme.onBackground,
      ),
    );
  }

  static Brightness _getOppositeBrightness(Brightness brightness) {
    if (brightness == Brightness.dark) {
      return Brightness.light;
    }
    return Brightness.dark;
  }
}
