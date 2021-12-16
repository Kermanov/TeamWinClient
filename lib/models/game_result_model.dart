import 'package:equatable/equatable.dart';
import 'package:sudoku_game/helpers/utils.dart';

class GameResult extends Equatable {
  final GameResultType gameResultType;
  final int time;
  final int bestTime;
  final int newRating;
  final int oldRating;
  final GameMode gameMode;
  final bool isNewBestTime;
  final int completionPercent;

  GameResult(
      {this.gameResultType,
      this.time,
      this.bestTime,
      this.newRating,
      this.oldRating,
      this.gameMode,
      this.isNewBestTime,
      this.completionPercent});

  int get ratingDelta {
    return newRating - oldRating;
  }

  @override
  List<Object> get props => [
        gameResultType,
        time,
        bestTime,
        newRating,
        oldRating,
        gameMode,
        isNewBestTime,
        completionPercent
      ];

  factory GameResult.fromJson(Map<String, dynamic> json) {
    return GameResult(
      gameResultType: GameResultType.values[json["gameResultType"]],
      time: json["time"],
      bestTime: json["bestTime"],
      newRating: json["newDuelRating"],
      oldRating: json["oldDuelRating"],
      isNewBestTime: json["isNewBestTime"],
      gameMode: GameMode.values[json["gameMode"]],
      completionPercent: json["completionPercent"],
    );
  }
}
