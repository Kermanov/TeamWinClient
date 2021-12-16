import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_game/constants/shared_preferences_constants.dart';
import 'package:sudoku_game/themes/theme.dart';

part 'theme_mode_state.dart';

class ThemeModeCubit extends Cubit<ThemeModeState> {
  ThemeModeCubit({
    @required ThemeMode themeMode,
  }) : super(ThemeModeState(themeMode: themeMode));

  void _setSystemUIOverlayStyle(ThemeMode themeMode) {
    AppTheme.setSystemUIOverlayStyle(_getBrightness(themeMode));
  }

  Brightness _getBrightness(ThemeMode themeMode) {
    return themeMode == ThemeMode.dark ? Brightness.dark : Brightness.light;
  }

  Future<void> _saveTheme(ThemeMode themeMode) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setInt(SharedPreferencesConstants.themeModeKey, themeMode.index);
  }

  void saveTheme(ThemeMode themeMode) {
    emit(ThemeModeState(themeMode: themeMode));
    _setSystemUIOverlayStyle(themeMode);
    _saveTheme(themeMode);
  }

  void setPlatformBrightness(Brightness platformBrightness) {
    if (state.themeMode == ThemeMode.system) {
      var themeMode = platformBrightness == Brightness.dark
          ? ThemeMode.dark
          : ThemeMode.light;
      emit(ThemeModeState(themeMode: themeMode));
    }
    _setSystemUIOverlayStyle(state.themeMode);
  }
}
