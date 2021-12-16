part of 'non_rating_game_bloc.dart';

abstract class NonRatingGameState extends Equatable {
  const NonRatingGameState();

  @override
  List<Object> get props => [];
}

class NonRatingGameInitial extends NonRatingGameState {}

class NonRatingGamePuzzleRetrieved extends NonRatingGameState {
  final List<BoardData> boards;
  final GameMode gameMode;

  const NonRatingGamePuzzleRetrieved(this.boards, this.gameMode);

  @override
  List<Object> get props => [boards, gameMode];
}

class NonRatingGameLoading extends NonRatingGameState {}

class NonRatingGameFinished extends NonRatingGameState {
  final SingleNonRatingGameResult gameResult;

  const NonRatingGameFinished(this.gameResult);

  @override
  List<Object> get props => [gameResult];

  @override
  String toString() {
    return "NonRatingGameFinished($gameResult)";
  }
}

class NonRatingGameError extends NonRatingGameState {}
