import 'package:sudoku_game/helpers/utils.dart';

class UserStatsItem {
  final int solvingTime;
  final int duelRating;
  final int totalGamesStarted;
  final int singleGamesStarted;
  final int duelGamesStarted;
  final int duelGamesWon;
  final int duelGameWinsPercent;

  UserStatsItem(
      this.solvingTime,
      this.duelRating,
      this.totalGamesStarted,
      this.singleGamesStarted,
      this.duelGamesStarted,
      this.duelGamesWon,
      this.duelGameWinsPercent);

  factory UserStatsItem.fromJson(Map<String, dynamic> json) {
    return UserStatsItem(
        json["solvingTime"],
        json["duelRating"],
        json["totalGamesStarted"],
        json["singleGamesStarted"],
        json["duelGamesStarted"],
        json["duelGamesWon"],
        json["duelGameWinsPercent"]);
  }
}

Map<GameMode, UserStatsItem> userStatsFromJson(Map<String, dynamic> json) {
  var userStats = <GameMode, UserStatsItem>{};
  for (var entry in json.entries) {
    userStats[GameMode.values[int.parse(entry.key)]] =
        UserStatsItem.fromJson(entry.value);
  }
  return userStats;
}
