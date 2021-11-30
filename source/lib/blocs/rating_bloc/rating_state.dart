part of 'rating_bloc.dart';

abstract class RatingState extends Equatable {
  const RatingState();

  @override
  List<Object> get props => [];
}

class RatingInitial extends RatingState {}

class RatingError extends RatingState {}

class RatingDataLoaded extends RatingState {
  final List<RatingModel> ratingData;
  final bool hasReachedMax;

  const RatingDataLoaded({this.ratingData, this.hasReachedMax});

  @override
  List<Object> get props => [ratingData, hasReachedMax];

  RatingDataLoaded copyWith(
      {List<RatingModel> ratingData, bool hasReachedMax}) {
    return RatingDataLoaded(
        ratingData: ratingData ?? this.ratingData,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax);
  }

  @override
  String toString() {
    return "RatingDataLoaded(hasReachedMax: $hasReachedMax, "
        "count: ${ratingData.length})";
  }
}
