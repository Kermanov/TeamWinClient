import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_game/constants/shared_preferences_constants.dart';
import 'package:sudoku_game/data_providers/api_data_provider.dart';
import 'package:sudoku_game/helpers/utils.dart';
import 'package:sudoku_game/models/solved_board_model.dart';

class SingleNonRatingGameRepository {
  final ApiDataProvider _apiDataProvider;
  final SharedPreferences sharedPreferences;

  SingleNonRatingGameRepository(
      {ApiDataProvider apiDataProvider, @required this.sharedPreferences})
      : _apiDataProvider = apiDataProvider ?? ApiDataProvider.instance;

  Future<List<SolvedBoardModel>> getNewPuzzle(GameMode gameMode) {
    return _apiDataProvider.getPuzzle(gameMode);
  }

  Future<void> saveTime(int time) async {
    await sharedPreferences.setInt(
        SharedPreferencesConstants.gameTimeKey, time);
  }

  Future<void> saveInitialPuzzle(List<SolvedBoardModel> boards) async {
    await sharedPreferences.setString(
        SharedPreferencesConstants.initialPuzzleKey, jsonEncode(boards));
  }

  Future<void> saveUserSolution(Map<int, List<int>> userSolution) async {
    await sharedPreferences.setString(
        SharedPreferencesConstants.userSolutionKey,
        jsonEncode(_mapToJson(userSolution)));
  }

  int loadTime() {
    return sharedPreferences.getInt(SharedPreferencesConstants.gameTimeKey);
  }

  List<SolvedBoardModel> loadInitialPuzzle() {
    return (jsonDecode(sharedPreferences
            .getString(SharedPreferencesConstants.initialPuzzleKey)) as List)
        .map((e) => SolvedBoardModel.fromJson(e))
        .toList();
  }

  Map<int, List<int>> loadUserSolution() {
    var str =
        sharedPreferences.getString(SharedPreferencesConstants.userSolutionKey);
    return (jsonDecode(str) as Map).map(
        (key, value) => MapEntry(int.parse(key), (value as List).cast<int>()));
  }

  Future<void> clearSavedData() async {
    var futures = [
      sharedPreferences.remove(SharedPreferencesConstants.gameTimeKey),
      sharedPreferences.remove(SharedPreferencesConstants.initialPuzzleKey),
      sharedPreferences.remove(SharedPreferencesConstants.userSolutionKey)
    ];
    await Future.wait(futures);
  }

  bool get isSaveAvailable {
    return sharedPreferences
            .containsKey(SharedPreferencesConstants.gameTimeKey) &&
        sharedPreferences
            .containsKey(SharedPreferencesConstants.initialPuzzleKey) &&
        sharedPreferences
            .containsKey(SharedPreferencesConstants.userSolutionKey);
  }

  Map<String, dynamic> _mapToJson(Map<dynamic, dynamic> map) {
    var jsonMap = <String, dynamic>{};
    for (var pair in map.entries) {
      jsonMap[pair.key.toString()] = pair.value;
    }
    return jsonMap;
  }
}
