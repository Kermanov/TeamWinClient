import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sudoku_game/helpers/utils.dart';
import 'package:sudoku_game/models/rating_model.dart';
import 'package:sudoku_game/repositories/rating_repository.dart';
import 'package:sudoku_game/helpers/logger_helper.dart';

part 'rating_event.dart';
part 'rating_state.dart';

class RatingBloc extends Bloc<RatingEvent, RatingState> {
  final RatingRepository ratingRepository;
  final GameMode gameMode;
  final RatingType ratingType;
  final int recordsPerRequest = 20;
  Logger _logger;

  RatingBloc(
      {@required this.ratingRepository,
      @required this.gameMode,
      @required this.ratingType})
      : assert(ratingRepository != null),
        assert(gameMode != null),
        assert(ratingType != null),
        super(RatingInitial()) {
    _logger = getLogger(this.runtimeType);
    _logger.v("Created.");
    add(RatingFetch());
  }

  @override
  Stream<RatingState> mapEventToState(
    RatingEvent event,
  ) async* {
    if (event is RatingFetch) {
      yield* _mapRatingFetchToState();
    } else if (event is RatingRefresh) {
      yield* _mapRatingRefreshToState();
    }
  }

  Stream<RatingState> _mapRatingFetchToState() async* {
    try {
      if (state is RatingInitial) {
        var ratingData = await ratingRepository.getRating(
            gameMode, ratingType, 0, recordsPerRequest);
        yield RatingDataLoaded(ratingData: ratingData, hasReachedMax: false);
      } else if (state is RatingDataLoaded) {
        var currentState = state as RatingDataLoaded;
        var ratingData = await ratingRepository.getRating(gameMode, ratingType,
            currentState.ratingData.length, recordsPerRequest);
        yield RatingDataLoaded(
            ratingData: currentState.ratingData + ratingData,
            hasReachedMax: ratingData.isEmpty);
      }
    } on Exception catch (ex) {
      _logger.w(ex.toString());
      yield RatingError();
    }
  }

  Stream<RatingState> _mapRatingRefreshToState() async* {
    try {
      var ratingData = await ratingRepository.getRating(
          gameMode, ratingType, 0, recordsPerRequest);
      yield RatingDataLoaded(ratingData: ratingData, hasReachedMax: false);
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
  void onTransition(Transition<RatingEvent, RatingState> transition) {
    _logger.d(transition.toString());
    super.onTransition(transition);
  }
}
