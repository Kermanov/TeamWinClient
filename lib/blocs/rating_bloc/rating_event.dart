part of 'rating_bloc.dart';

abstract class RatingEvent extends Equatable {
  final GameMode gameMode;
  final RatingType ratingType;

  const RatingEvent(this.gameMode, this.ratingType);

  @override
  List<Object> get props => [];
}

class RatingFetch extends RatingEvent {
  const RatingFetch(GameMode gameMode, RatingType ratingType)
      : super(gameMode, ratingType);
}

class RatingRefresh extends RatingEvent {
  const RatingRefresh(GameMode gameMode, RatingType ratingType)
      : super(gameMode, ratingType);
}
