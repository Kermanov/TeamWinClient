import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_game/constants/shared_preferences_constants.dart';
import 'package:sudoku_game/helpers/utils.dart';

class RatingGamePageRepository {
  final SharedPreferences sharedPreferences;

  RatingGamePageRepository({@required this.sharedPreferences})
      : assert(sharedPreferences != null);

  Future<bool> saveSingleGameSettings(GameMode gameMode) {
    return sharedPreferences.setInt(
        SharedPreferencesConstants.singleGameSettingsKey, gameMode.index);
  }

  Future<bool> saveDuelGameSettings(GameMode gameMode) {
    return sharedPreferences.setInt(
        SharedPreferencesConstants.duelGameSettingsKey, gameMode.index);
  }

  GameMode loadSingleGameSettings() {
    if (sharedPreferences
        .containsKey(SharedPreferencesConstants.singleGameSettingsKey)) {
      return GameMode.values[sharedPreferences
          .getInt(SharedPreferencesConstants.singleGameSettingsKey)];
    }
    return GameMode.onePuzzleEasy;
  }

  GameMode loadDuelGameSettings() {
    if (sharedPreferences
        .containsKey(SharedPreferencesConstants.duelGameSettingsKey)) {
      return GameMode.values[sharedPreferences
          .getInt(SharedPreferencesConstants.duelGameSettingsKey)];
    }
    return GameMode.onePuzzleEasy;
  }
}
