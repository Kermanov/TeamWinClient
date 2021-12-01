import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sudoku_game/helpers/utils.dart';

part 'duel_page_state.dart';

class DuelPageCubit extends Cubit<DuelPageState> {
  DuelPageCubit(GameMode initialGameMode)
      : super(DuelPageState(initialGameMode));

  void setGameMode(GameMode gameMode) {
    emit(DuelPageState(gameMode));
  }
}
