import 'package:sudoku_game/models/rating_model.dart';

class LeaderboardModel {
  final List<RatingModel> ratings;
  final RatingModel currentPlace;
  final int calibrationGamesLeft;

  LeaderboardModel(this.ratings, this.currentPlace, this.calibrationGamesLeft);

  factory LeaderboardModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardModel(
        (json["ratings"] as List<dynamic>)
            .map((rating) => RatingModel.fromJson(rating))
            .toList(),
        json["currentPlace"] != null
            ? RatingModel.fromJson(json["currentPlace"])
            : null,
        json["calibrationGamesLeft"]);
  }
}
