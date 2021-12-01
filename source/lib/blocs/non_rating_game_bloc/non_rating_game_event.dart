part of 'non_rating_game_bloc.dart';

abstract class NonRatingGameEvent extends Equatable {
  const NonRatingGameEvent();

  @override
  List<Object> get props => [];
}

class NonRatingGameGetPuzzle extends NonRatingGameEvent {
  final GameMode gameMode;

  const NonRatingGameGetPuzzle(this.gameMode);

  @override
  List<Object> get props => [gameMode];

  @override
  String toString() {
    return "NonRatingGameGetPuzzle($gameMode)";
  }
}

class NonRatingGameLoadPuzzle extends NonRatingGameEvent {}

class NonRatingGameBoardChanged extends NonRatingGameEvent {
  final ChangedBoardData changedBoard;

  const NonRatingGameBoardChanged(this.changedBoard);

  @override
  List<Object> get props => [changedBoard];
}

class _NonRatingGameTimeChanged extends NonRatingGameEvent {
  final int time;

  const _NonRatingGameTimeChanged(this.time);

  @override
  List<Object> get props => [time];

  @override
  String toString() {
    return "_NonRatingGameTimeChanged($time)";
  }
}
