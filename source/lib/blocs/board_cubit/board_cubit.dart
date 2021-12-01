import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sudoku_game/helpers/logger_helper.dart';
import 'package:sudoku_game/helpers/utils.dart';

part 'board_state.dart';

class BoardData {
  final int id;
  final List<int> initialValues;
  final List<int> filledValues;

  BoardData(
      {@required this.id, @required this.initialValues, List<int> filledValues})
      : assert(id != null),
        assert(initialValues != null),
        this.filledValues = filledValues ?? List<int>.filled(81, 0);
}

class ChangedBoardData extends BoardData {
  final List<int> allValues;

  ChangedBoardData(
      {@required int id,
      @required List<int> initialValues,
      @required List<int> filledValues,
      @required this.allValues})
      : assert(allValues != null),
        super(id: id, initialValues: initialValues, filledValues: filledValues);
}

class BoardCubit extends Cubit<BoardState> {
  final BoardData boardData;
  final void Function(ChangedBoardData) onBoardChanges;
  Logger _logger;

  BoardCubit({@required this.boardData, this.onBoardChanges})
      : assert(boardData != null),
        super(BoardState(
            initialValues: boardData.initialValues,
            mutableValues: boardData.filledValues,
            action: BoardAction.initialValuesRetrieved)) {
    _logger = getLogger(this.runtimeType);
    _logger.v("Created.");
  }

  void cellSelected(CellPosition selectedCell) {
    if (selectedCell != state.selectedCell) {
      emit(state.copyWith(
          selectedCell: selectedCell, action: BoardAction.cellSelected));
    }
  }

  void numberSelected(int number) {
    if (state.selectedCell != null && _isMutable && _isNumberChanged(number)) {
      state.mutableValues[state.selectedCell.index] = number;
      emit(state.copyWith(action: BoardAction.mutableValuesChanged));
      onBoardChanges?.call(ChangedBoardData(
          id: boardData.id,
          initialValues: boardData.initialValues,
          filledValues: state.mutableValues,
          allValues: _boardList));
    }
  }

  bool _isNumberChanged(int number) {
    return state.mutableValues[state.selectedCell.index] != number;
  }

  bool get _isMutable {
    return state.initialValues[state.selectedCell.index] == 0;
  }

  List<int> get _boardList {
    return List.generate(81, (index) {
      return state.initialValues[index] == 0
          ? state.mutableValues[index]
          : state.initialValues[index];
    });
  }

  @override
  void onChange(Change<BoardState> change) {
    _logger.v(change.toString());
    super.onChange(change);
  }
}
