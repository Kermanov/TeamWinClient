part of 'rating_100_bloc.dart';

abstract class Rating100State extends Equatable {
  const Rating100State();

  @override
  List<Object> get props => [];
}

class RatingInitial extends Rating100State {}

class RatingError extends Rating100State {}

class RatingLoading extends Rating100State {}

class RatingDataLoaded extends Rating100State {
  final LeaderboardModel ratingData;

  const RatingDataLoaded({this.ratingData});

  @override
  List<Object> get props => [ratingData];

  @override
  String toString() {
    return "RatingDataLoaded(count: ${ratingData.ratings.length})";
  }
}
