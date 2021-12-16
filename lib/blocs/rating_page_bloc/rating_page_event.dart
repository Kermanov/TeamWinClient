part of 'rating_page_bloc.dart';

abstract class RatingPageEvent extends Equatable {
  const RatingPageEvent();

  @override
  List<Object> get props => [];
}

class RatingPageLoadSettings extends RatingPageEvent {}

class RatingPageSaveGameModeSettings extends RatingPageEvent {
  final GameMode gameMode;

  RatingPageSaveGameModeSettings(this.gameMode);

  @override
  List<Object> get props => [gameMode];
}

class RatingPageSaveRatingTypeSettings extends RatingPageEvent {
  final RatingType ratingType;

  RatingPageSaveRatingTypeSettings(this.ratingType);

  @override
  List<Object> get props => [ratingType];
}
