import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sudoku_game/helpers/logger_helper.dart';
import 'package:sudoku_game/helpers/utils.dart';
import 'package:sudoku_game/repositories/single_non_rating_game_repository.dart';

part 'single_page_state.dart';

class SinglePageCubit extends Cubit<SinglePageState> {
  final SingleNonRatingGameRepository repository;
  Logger _logger;

  SinglePageCubit({@required this.repository})
      : assert(repository != null),
        super(SinglePageState.initial()) {
    _logger = getLogger(this.runtimeType);
    _logger.v("Created.");
  }

  void loadSettingsAndSaveInfo() {
    Future(() {
      emit(state.copyWith(gameMode: repository.loadGameSettings()));
      if (repository.isSaveAvailable) {
        emit(state.copyWith(
          savedGameInfo: SavedGameInfo(
            gameMode: repository.loadGameMode(),
            time: repository.loadTime(),
          ),
        ));
      } else {
        emit(state.copyWith(savedGameInfo: SavedGameInfo.empty()));
      }
    });
  }

  void setGameMode(GameMode gameMode) {
    emit(state.copyWith(gameMode: gameMode));
    repository.saveGameSettings(gameMode);
  }

  @override
  void onChange(Change<SinglePageState> change) {
    _logger.v(change.toString());
    super.onChange(change);
  }
}
