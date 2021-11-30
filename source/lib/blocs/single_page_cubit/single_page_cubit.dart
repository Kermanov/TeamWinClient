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

  SinglePageCubit(
      {@required GameMode initialGameMode,
      @required bool initialIsRatingGame,
      @required this.repository})
      : assert(repository != null),
        super(SinglePageState(initialGameMode, initialIsRatingGame, false)) {
    _logger = getLogger(this.runtimeType);
    _logger.v("Created.");
    checkForSave();
  }

  void checkForSave() {
    emit(state.copyWith(isSaveAvailable: repository.isSaveAvailable));
  }

  void setGameMode(GameMode gameMode) {
    emit(state.copyWith(gameMode: gameMode));
  }

  void setIsRatingGame(bool isRatingGame) {
    emit(state.copyWith(isRatingGame: isRatingGame));
  }

  @override
  void onChange(Change<SinglePageState> change) {
    _logger.v(change.toString());
    super.onChange(change);
  }
}
