import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_game/constants/shared_preferences_constants.dart';
import 'package:sudoku_game/helpers/utils.dart';

class RatingPageRepository {
  final SharedPreferences sharedPreferences;

  RatingPageRepository({@required this.sharedPreferences})
      : assert(sharedPreferences != null);

  Future<bool> saveGameModeSettings(GameMode gameMode) {
    return sharedPreferences.setInt(
        SharedPreferencesConstants.ratingGameModeSettingsKey, gameMode.index);
  }

  Future<bool> saveRatingTypeSettings(RatingType ratingType) {
    return sharedPreferences.setInt(
        SharedPreferencesConstants.ratingRatingTypeSettingsKey,
        ratingType.index);
  }

  GameMode loadGameModeSettings() {
    if (sharedPreferences
        .containsKey(SharedPreferencesConstants.ratingGameModeSettingsKey)) {
      return GameMode.values[sharedPreferences
          .getInt(SharedPreferencesConstants.ratingGameModeSettingsKey)];
    }
    return GameMode.onePuzzleEasy;
  }

  RatingType loadRatingTypeSettings() {
    if (sharedPreferences
        .containsKey(SharedPreferencesConstants.ratingRatingTypeSettingsKey)) {
      return RatingType.values[sharedPreferences
          .getInt(SharedPreferencesConstants.ratingRatingTypeSettingsKey)];
    }
    return RatingType.duel;
  }
}
