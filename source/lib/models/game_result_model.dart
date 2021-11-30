import 'package:equatable/equatable.dart';

class GameResult extends Equatable {
  final bool isVictory;
  final int time;
  final int newRating;
  final int oldRating;
  final String message;

  const GameResult(
      {this.isVictory,
      this.time,
      this.newRating,
      this.oldRating,
      this.message});

  @override
  List<Object> get props => [isVictory, time, newRating, message];

  factory GameResult.fromJson(Map<String, dynamic> json) {
    return GameResult(
        isVictory: json["isVictory"],
        time: json["time"],
        newRating: json["newDuelRating"]);
  }

  GameResult copyWith(
      {bool isVictory,
      int time,
      int newRating,
      int oldRating,
      String message}) {
    return GameResult(
        isVictory: isVictory ?? this.isVictory,
        time: time ?? this.time,
        newRating: newRating ?? this.newRating,
        oldRating: oldRating ?? this.oldRating,
        message: message ?? this.message);
  }

  @override
  String toString() {
    return "GameResult(isVictory: $isVictory, time: $time, "
        "newRating: $newRating, oldRating: $oldRating, message: $message)";
  }
}
