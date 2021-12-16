import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sudoku_game/helpers/logger_helper.dart';
import 'package:sudoku_game/helpers/utils.dart';
import 'package:sudoku_game/models/leaderboard_model.dart';
import 'package:sudoku_game/repositories/rating_repository.dart';

part 'rating_100_event.dart';
part 'rating_100_state.dart';

class Rating100Bloc extends Bloc<Rating100Event, Rating100State> {
  final RatingRepository ratingRepository;
  Logger _logger;

  Rating100Bloc({@required this.ratingRepository})
      : assert(ratingRepository != null),
        super(RatingInitial()) {
    _logger = getLogger(this.runtimeType);
    _logger.v("Created.");
  }

  @override
  Stream<Rating100State> mapEventToState(
    Rating100Event event,
  ) async* {
    if (event is GetRating) {
      yield* _mapRatingGetRatingToState(event);
    }
  }

  Stream<Rating100State> _mapRatingGetRatingToState(GetRating event) async* {
    try {
      yield RatingLoading();
      var ratingData =
          await ratingRepository.getRating100(event.gameMode, event.ratingType);
      yield RatingDataLoaded(ratingData: ratingData);
    } on Exception catch (ex) {
      _logger.w(ex.toString());
      yield RatingError();
    }
  }

  @override
  Future<void> close() {
    _logger.v("Closed.");
    return super.close();
  }

  @override
  void onTransition(Transition<Rating100Event, Rating100State> transition) {
    _logger.d(transition.toString());
    super.onTransition(transition);
  }
}
