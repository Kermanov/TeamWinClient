part of 'rating_game_page_bloc.dart';

abstract class RatingGamePageEvent extends Equatable {
  const RatingGamePageEvent();

  @override
  List<Object> get props => [];
}

class RatingGamePageLoadSettings extends RatingGamePageEvent {}

class RatingGamePageSaveDuelSettings extends RatingGamePageEvent {
  final GameMode gameMode;

  RatingGamePageSaveDuelSettings(this.gameMode);

  @override
  List<Object> get props => [gameMode];
}

class RatingGamePageSaveSingleSettings extends RatingGamePageEvent {
  final GameMode gameMode;

  RatingGamePageSaveSingleSettings(this.gameMode);

  @override
  List<Object> get props => [gameMode];
}
