part of 'rating_game_bloc.dart';

abstract class RatingGameEvent extends Equatable {
  const RatingGameEvent();

  @override
  List<Object> get props => [];
}

class GameReadyToStart extends RatingGameEvent {}

class _GameStarted extends RatingGameEvent {
  final List<BoardModel> boards;

  const _GameStarted(this.boards);

  @override
  List<Object> get props => [boards];
}

class _OpponentCompletionPercentRetrieved extends RatingGameEvent {
  final int completionPercent;

  const _OpponentCompletionPercentRetrieved(this.completionPercent);

  @override
  List<Object> get props => [completionPercent];

  @override
  String toString() {
    return "_OpponentCompletionPercentRetrieved($completionPercent)";
  }
}

class _GameResultRetrieved extends RatingGameEvent {
  final GameResult gameResult;

  const _GameResultRetrieved(this.gameResult);

  @override
  List<Object> get props => [gameResult];

  @override
  String toString() {
    return "_GameResultRetrieved($gameResult)";
  }
}

class GameSendProgress extends RatingGameEvent {
  final ChangedBoardData changedBoard;

  const GameSendProgress(this.changedBoard);

  @override
  List<Object> get props => [changedBoard];
}

class _GameTimeExpired extends RatingGameEvent {
  final int newRating;

  const _GameTimeExpired(this.newRating);

  @override
  List<Object> get props => [newRating];

  @override
  String toString() {
    return "_GameTimeExpired(newRating: $newRating)";
  }
}

class _PlayersInfoRetrieved extends RatingGameEvent {
  final List<PlayerInfo> playersInfo;

  const _PlayersInfoRetrieved(this.playersInfo);
}

class _GameAborted extends RatingGameEvent {}
