import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sudoku_game/helpers/utils.dart';
import 'package:sudoku_game/repositories/single_non_rating_game_repository.dart';

part 'single_page_state.dart';

class SinglePageCubit extends Cubit<SinglePageState> {
  final SingleNonRatingGameRepository repository;
  SinglePageCubit(
      {@required GameMode initialGameMode,
      @required bool initialIsRatingGame,
      @required this.repository})
      : assert(repository != null),
        super(SinglePageState(initialGameMode, initialIsRatingGame, false)) {
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
}
