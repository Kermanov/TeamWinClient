part of 'rating_game_bloc.dart';

abstract class RatingGameState extends Equatable {
  const RatingGameState();

  @override
  List<Object> get props => [];
}

class GameInitial extends RatingGameState {}

class GameWaiting extends RatingGameState {}

class GamePuzzlesRetrieved extends RatingGameState {
  final List<BoardData> boards;

  const GamePuzzlesRetrieved(this.boards);

  @override
  List<Object> get props => [boards];
}

class GameOpponentCompletionPercentRetrieved extends RatingGameState {
  final int opponentCompletionPercent;

  const GameOpponentCompletionPercentRetrieved(this.opponentCompletionPercent);

  @override
  List<Object> get props => [opponentCompletionPercent];

  @override
  String toString() {
    return "GameOpponentCompletionPercentRetrieved($opponentCompletionPercent)";
  }
}

class GameFinished extends RatingGameState {
  final GameResult gameResult;

  const GameFinished(this.gameResult);

  @override
  List<Object> get props => [gameResult];

  @override
  String toString() {
    return "GameFinished($gameResult)";
  }
}

class GameError extends RatingGameState {}

class GamePlayersInfoRetrieved extends RatingGameState {
  final List<PlayerInfo> playersInfo;

  const GamePlayersInfoRetrieved(this.playersInfo);

  @override
  List<Object> get props => [playersInfo];
}

class GameAborted extends RatingGameState {}
