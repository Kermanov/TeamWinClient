import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sudoku_game/blocs/rating_100_bloc/rating_100_bloc.dart';
import 'package:sudoku_game/helpers/logger_helper.dart';
import 'package:sudoku_game/helpers/utils.dart';
import 'package:sudoku_game/repositories/rating_page_repository.dart';

part 'rating_page_event.dart';
part 'rating_page_state.dart';

class RatingPageBloc extends Bloc<RatingPageEvent, RatingPageState> {
  final RatingPageRepository repository;
  final Rating100Bloc ratingBloc;
  Logger _logger;

  RatingPageBloc({@required this.repository, @required this.ratingBloc})
      : assert(repository != null),
        assert(ratingBloc != null),
        super(RatingPageState.initial()) {
    _logger = getLogger(this.runtimeType);
    _logger.v("Created.");
  }

  @override
  Stream<RatingPageState> mapEventToState(
    RatingPageEvent event,
  ) async* {
    if (event is RatingPageLoadSettings) {
      yield* _mapLoadSettingsEventToState();
    } else if (event is RatingPageSaveGameModeSettings) {
      yield* _mapSaveGameModeEventToState(event);
    } else if (event is RatingPageSaveRatingTypeSettings) {
      yield* _mapSaveRatingTypeEventToState(event);
    }
  }

  Stream<RatingPageState> _mapLoadSettingsEventToState() async* {
    try {
      var newState = state.copyWith(
        gameMode: repository.loadGameModeSettings(),
        ratingType: repository.loadRatingTypeSettings(),
      );
      yield newState;
      ratingBloc?.add(GetRating(newState.gameMode, newState.ratingType));
    } on Exception catch (ex) {
      _logger.w(ex.toString());
      yield state.copyWith(isError: true);
    }
  }

  Stream<RatingPageState> _mapSaveGameModeEventToState(
      RatingPageSaveGameModeSettings event) async* {
    yield state.copyWith(gameMode: event.gameMode);
    try {
      await repository.saveGameModeSettings(event.gameMode);
    } on Exception catch (ex) {
      _logger.w(ex.toString());
      yield state.copyWith(isError: true);
    }
  }

  Stream<RatingPageState> _mapSaveRatingTypeEventToState(
      RatingPageSaveRatingTypeSettings event) async* {
    yield state.copyWith(ratingType: event.ratingType);
    try {
      await repository.saveRatingTypeSettings(event.ratingType);
    } on Exception catch (ex) {
      _logger.w(ex.toString());
      yield state.copyWith(isError: true);
    }
  }

  @override
  Future<void> close() {
    _logger.v("Closed.");
    return super.close();
  }

  @override
  void onTransition(Transition<RatingPageEvent, RatingPageState> transition) {
    _logger.v(transition.toString());
    super.onTransition(transition);
  }
}
