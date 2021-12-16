import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';
import 'package:sudoku_game/helpers/logger_helper.dart';
import 'package:sudoku_game/helpers/utils.dart';

part 'duel_page_state.dart';

class DuelPageCubit extends Cubit<DuelPageState> {
  Logger _logger;

  DuelPageCubit(GameMode initialGameMode)
      : super(DuelPageState(initialGameMode)) {
    _logger = getLogger(this.runtimeType);
    _logger.v("Created.");
  }

  void setGameMode(GameMode gameMode) {
    emit(DuelPageState(gameMode));
  }

  @override
  void onChange(Change<DuelPageState> change) {
    _logger.v(change.toString());
    super.onChange(change);
  }

  @override
  Future<void> close() {
    _logger.v("Closed.");
    return super.close();
  }
}
