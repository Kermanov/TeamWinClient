import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cure/signalr.dart';
import 'package:flutter/material.dart';
import 'package:sudoku_game/widgets/modal_selector.dart';
import 'package:easy_localization/easy_localization.dart';

class CellPosition extends Equatable {
  final int col;
  final int row;
  final int size;

  const CellPosition(this.col, this.row, [this.size = 9]);
  const CellPosition.fromIndex(int index, [this.size = 9])
      : col = index % size,
        row = index ~/ size;

  @override
  List<Object> get props => [col, row];

  int get index => row * size + col;
}

HubConnection createHubConnection(String hubUrl) {
  var builder = HubConnectionBuilder();
  builder.withURL(hubUrl);
  builder.httpConnectionOptions.accessTokenFactory =
      () => FirebaseAuth.instance.currentUser?.getIdToken();
  return builder.build();
}

enum GameType { duel, single, free }

enum GameMode {
  none,
  onePuzzleEasy,
  onePuzzleMedium,
  onePuzzleHard,
  threePuzzles
}

enum RatingType { duel, solving }

enum GameResultType {
  none,
  victory,
  defeat,
  victoryByCompletionPercent,
  defeatByCompletionPercent,
  draw
}

String getGameResultTypeName(GameResultType gameResultType) {
  var dict = {
    GameResultType.none: "none".tr(),
    GameResultType.defeat: "game_result.defeat".tr(),
    GameResultType.defeatByCompletionPercent: "game_result.defeat".tr(),
    GameResultType.draw: "game_result.draw".tr(),
    GameResultType.victory: "game_result.victory".tr(),
    GameResultType.victoryByCompletionPercent: "game_result.victory".tr()
  };
  return dict[gameResultType];
}

String getGameModeName(GameMode gameMode) {
  var dict = {
    GameMode.none: "none".tr(),
    GameMode.onePuzzleEasy: "game_mode.easy".tr(),
    GameMode.onePuzzleMedium: "game_mode.medium".tr(),
    GameMode.onePuzzleHard: "game_mode.hard".tr(),
    GameMode.threePuzzles: "game_mode.expert".tr(),
  };
  return dict[gameMode];
}

String getGameTypeName(GameType gameType) {
  var dict = {
    GameType.duel: "game_type.duel".tr(),
    GameType.single: "game_type.single".tr(),
    GameType.free: "game_type.free".tr()
  };
  return dict[gameType];
}

List<ModalSelectorItem<GameMode>> getGameModeOptions() {
  return GameMode.values
      .sublist(1)
      .map((e) => ModalSelectorItem(
            child: Text(
              getGameModeName(e),
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            value: e,
          ))
      .toList();
}

String formatTime(int milliseconds) {
  var dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds).toUtc();
  var formattedString = addLeadingZeroes(dateTime.minute, 2) +
      ":" +
      addLeadingZeroes(dateTime.second, 2);
  if (dateTime.hour > 0) {
    formattedString = dateTime.hour.toString() + ":" + formattedString;
  }
  return formattedString;
}

String addLeadingZeroes(int number, int digitsNumber) {
  return number.toString().padLeft(digitsNumber, "0");
}

String getFlagEmoji(String countryCode) {
  return String.fromCharCodes(
      countryCode.codeUnits.map((e) => e - 0x41 + 0x1F1E6));
}

String ratingValueToString(int value, RatingType ratingType) {
  if (ratingType == RatingType.duel) {
    return value.toString();
  } else if (ratingType == RatingType.solving) {
    return formatTime(value);
  } else {
    return "";
  }
}

extension RandomExtension on Random {
  double nextDoubleFromInterval(double start, double end) {
    return start + this.nextDouble() * (end - start);
  }

  int nextIntFromInterval(int start, int end) {
    return start + this.nextInt(end - start);
  }
}

String getPlaceString(int place) {
  return _getEmodjiByPlace(place) ?? " $place";
}

String _getEmodjiByPlace(int place) {
  var emoji = {1: "🥇", 2: "🥈", 3: "🥉"};
  return emoji[place];
}
