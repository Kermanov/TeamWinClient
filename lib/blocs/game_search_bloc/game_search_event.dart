part of 'game_search_bloc.dart';

abstract class GameSearchEvent extends Equatable {
  const GameSearchEvent();

  @override
  List<Object> get props => [];
}

class GameSearchStarted extends GameSearchEvent {
  final GameType gameType;
  final GameMode gameMode;

  const GameSearchStarted(this.gameType, this.gameMode);

  @override
  List<Object> get props => [gameType, gameMode];

  @override
  String toString() {
    return "GameSearchStarted($gameType, $gameMode)";
  }
}

class _GameSearchGameFound extends GameSearchEvent {
  final String gameId;

  const _GameSearchGameFound(this.gameId);

  @override
  List<Object> get props => [gameId];

  @override
  String toString() {
    return "_GameSearchGameFound($gameId)";
  }
}

class GameSearchAbort extends GameSearchEvent {
  final GameType gameType;

  GameSearchAbort(this.gameType);

  @override
  List<Object> get props => [gameType];
}

class GameSearchReset extends GameSearchEvent {}
