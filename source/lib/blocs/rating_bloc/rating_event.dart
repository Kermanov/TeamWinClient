part of 'rating_bloc.dart';

abstract class RatingEvent extends Equatable {
  const RatingEvent();

  @override
  List<Object> get props => [];
}

class RatingFetch extends RatingEvent {}

class RatingRefresh extends RatingEvent {}
