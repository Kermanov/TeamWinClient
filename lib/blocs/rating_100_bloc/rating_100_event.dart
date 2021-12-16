part of 'rating_100_bloc.dart';

abstract class Rating100Event extends Equatable {
  const Rating100Event();

  @override
  List<Object> get props => [];
}

class GetRating extends Rating100Event {
  final GameMode gameMode;
  final RatingType ratingType;

  GetRating(this.gameMode, this.ratingType);

  @override
  List<Object> get props => [gameMode, ratingType];
}
