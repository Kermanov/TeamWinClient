import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:sudoku_game/helpers/logger_helper.dart';
import 'package:sudoku_game/helpers/utils.dart';
import 'package:sudoku_game/repositories/rating_game_page_repository.dart';

part 'rating_game_page_event.dart';
part 'rating_game_page_state.dart';

class RatingGamePageBloc
    extends Bloc<RatingGamePageEvent, RatingGamePageState> {
  final RatingGamePageRepository repository;
  Logger _logger;

  RatingGamePageBloc({@required this.repository})
      : assert(repository != null),
        super(RatingGamePageState.initial()) {
    _logger = getLogger(this.runtimeType);
    _logger.v("Created.");
  }

  @override
  Stream<RatingGamePageState> mapEventToState(
    RatingGamePageEvent event,
  ) async* {
    if (event is RatingGamePageLoadSettings) {
      yield* _mapLoadSettingsEventToState();
    } else if (event is RatingGamePageSaveDuelSettings) {
      yield* _mapSaveDuelSettingsEventToState(event);
    } else if (event is RatingGamePageSaveSingleSettings) {
      yield* _mapSaveSingleSettingsEventToState(event);
    }
  }

  Stream<RatingGamePageState> _mapLoadSettingsEventToState() async* {
    try {
      yield state.copyWith(
        duelGameMode: repository.loadDuelGameSettings(),
        singleGameMode: repository.loadSingleGameSettings(),
      );
    } on Exception catch (ex) {
      _logger.w(ex.toString());
      yield state.copyWith(isError: true);
    }
  }

  Stream<RatingGamePageState> _mapSaveDuelSettingsEventToState(
      RatingGamePageSaveDuelSettings event) async* {
    yield state.copyWith(duelGameMode: event.gameMode);
    try {
      await repository.saveDuelGameSettings(event.gameMode);
    } on Exception catch (ex) {
      _logger.w(ex.toString());
      yield state.copyWith(isError: true);
    }
  }

  Stream<RatingGamePageState> _mapSaveSingleSettingsEventToState(
      RatingGamePageSaveSingleSettings event) async* {
    yield state.copyWith(singleGameMode: event.gameMode);
    try {
      await repository.saveSingleGameSettings(event.gameMode);
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
  void onTransition(
      Transition<RatingGamePageEvent, RatingGamePageState> transition) {
    _logger.v(transition.toString());
    super.onTransition(transition);
  }
}
