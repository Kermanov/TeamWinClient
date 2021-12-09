import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cure/signalr.dart';
import 'package:flutter/material.dart';
import 'package:sudoku_game/widgets/modal_selector.dart';

class CellPosition extends Equatable {
  final int col;
  final int row;

  const CellPosition(this.col, this.row);

  @override
  List<Object> get props => [col, row];

  int get index => row * 9 + col;
}

HubConnection createHubConnection(String hubUrl) {
  // return HubConnectionBuilder()
  //     .withUrl(
  //         hubUrl,
  //         HttpConnectionOptions(
  //             client: HttpClientFactory.getClient(),
  //             //logging: (level, message) => debugPrint(message),
  //             accessTokenFactory:
  //                 FirebaseAuth.instance.currentUser?.getIdToken))
  //     .build();

  var builder = HubConnectionBuilder();
  builder.withURL(hubUrl);
  builder.httpConnectionOptions.accessTokenFactory =
      () => FirebaseAuth.instance.currentUser?.getIdToken();
  return builder.build();
}

enum GameType { duel, single }

enum GameMode {
  none,
  onePuzzleEasy,
  onePuzzleMedium,
  onePuzzleHard,
  threePuzzles
}

enum RatingType { duel, solving }

String getGameModeName(GameMode gameMode) {
  var dict = {
    GameMode.none: "None",
    GameMode.onePuzzleEasy: "Easy",
    GameMode.onePuzzleMedium: "Medium",
    GameMode.onePuzzleHard: "Hard",
    GameMode.threePuzzles: "Expert",
  };
  return dict[gameMode];
}

List<ModalSelectorItem<GameMode>> getGameModeOptions() {
  return GameMode.values
      .sublist(1)
      .map((e) => ModalSelectorItem(
            child: Text(getGameModeName(e)),
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
