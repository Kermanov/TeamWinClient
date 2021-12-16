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
  final List<List<int>> hints;

  BoardData({
    @required this.id,
    @required this.initialValues,
    List<int> filledValues,
    final List<List<int>> hints,
  })  : assert(id != null),
        this.filledValues = filledValues ?? List<int>.filled(81, 0),
        this.hints = hints ?? List<List<int>>.generate(81, (_) => <int>[]);
}

class ChangedBoardData extends BoardData {
  final List<int> allValues;

  ChangedBoardData(
      {@required int id,
      List<int> initialValues,
      List<int> filledValues,
      this.allValues,
      List<List<int>> hints})
      : super(
          id: id,
          initialValues: initialValues,
          filledValues: filledValues,
          hints: hints,
        );
}

class BoardCubit extends Cubit<BoardState> {
  final BoardData boardData;
  final void Function(ChangedBoardData) onBoardChanges;
  Logger _logger;

  BoardCubit({@required this.boardData, this.onBoardChanges})
      : assert(boardData != null),
        super(BoardState.initial(
          initialValues: boardData.initialValues,
          mutableValues: boardData.filledValues,
          hints: boardData.hints,
        )) {
    _logger = getLogger(this.runtimeType);
    _logger.v("Created.");
    emit(state.copyWith(
      errorIndices: _getErrorIndices(state.mutableValues, state.allValues),
      action: BoardAction.errorsChanged,
    ));
  }

  void setHintMode(bool hintMode) {
    emit(state.copyWith(
      hintMode: hintMode,
      action: BoardAction.hintModeChanged,
    ));
  }

  void cellSelected(CellPosition selectedCell) {
    if (selectedCell != state.selectedCell) {
      emit(state.copyWith(
        selectedCell: selectedCell,
        action: BoardAction.cellSelected,
      ));
    }
  }

  void numberSelected(int number) {
    if (state.selectedCell != null && _isMutable) {
      if (state.hintMode) {
        _updateNumber(0);
        _updateHint(number);
      } else {
        _updateHint(0);
        _updateNumber(number);
      }
    }
  }

  void _updateNumber(int number) {
    bool numberChanged =
        state.mutableValues[state.selectedCell.index] != number;
    if (numberChanged) {
      state.mutableValues[state.selectedCell.index] = number;
      emit(state.copyWith(action: BoardAction.mutableValuesChanged));
      emit(state.copyWith(
        errorIndices: _getErrorIndices(state.mutableValues, state.allValues),
        action: BoardAction.errorsChanged,
      ));
      onBoardChanges?.call(ChangedBoardData(
        id: boardData.id,
        initialValues: boardData.initialValues,
        filledValues: state.mutableValues,
        allValues: state.allValues,
      ));
    }
  }

  void _updateHint(int value) {
    var hint = state.hints[state.selectedCell.index];
    var hintChanged = true;
    if (value == 0) {
      hintChanged = hint.isNotEmpty;
      hint.clear();
    } else if (hint.contains(value)) {
      hint.remove(value);
    } else {
      hint.add(value);
    }
    if (hintChanged) {
      emit(state.copyWith(action: BoardAction.hintChanged));
      onBoardChanges?.call(ChangedBoardData(
        id: boardData.id,
        hints: state.hints,
      ));
    }
  }

  List<int> _getErrorIndices(List<int> mutableValues, List<int> allValues) {
    var errorIndicies = Set<int>();
    for (int i = 0; i < mutableValues.length; ++i) {
      if (mutableValues[i] != 0) {
        errorIndicies.addAll(_getErrorIndicesByIndex(i, allValues));
      }
    }
    return errorIndicies.toList();
  }

  List<int> _getErrorIndicesByIndex(int index, List<int> boardValues) {
    var errorIndices = <int>[];
    var relatedCells = _getRelaltedCells(index);
    for (var relatedCell in relatedCells) {
      if (boardValues[index] == boardValues[relatedCell.index]) {
        errorIndices.add(relatedCell.index);
      }
    }
    if (errorIndices.isNotEmpty) {
      errorIndices.add(index);
    }
    return errorIndices;
  }

  List<CellPosition> _getRelaltedCells(int index) {
    var cellPosition = CellPosition.fromIndex(index);
    return _getSameCol(cellPosition) +
        _getSameRow(cellPosition) +
        _getSameSquare(cellPosition);
  }

  List<CellPosition> _getSameRow(CellPosition cell) {
    var sameRowCells =
        List.generate(9, (index) => CellPosition(index, cell.row));
    sameRowCells.removeAt(cell.col);
    return sameRowCells;
  }

  List<CellPosition> _getSameCol(CellPosition cell) {
    var sameRowCells =
        List.generate(9, (index) => CellPosition(cell.col, index));
    sameRowCells.removeAt(cell.row);
    return sameRowCells;
  }

  List<CellPosition> _getSameSquare(CellPosition cell) {
    var sameRectCells = <CellPosition>[];
    int rectTopLeftRow = cell.row ~/ 3 * 3;
    int rectTopLeftCol = cell.col ~/ 3 * 3;
    for (int i = 0; i < 3; ++i) {
      for (int k = 0; k < 3; ++k) {
        sameRectCells.add(CellPosition(rectTopLeftCol + k, rectTopLeftRow + i));
      }
    }
    sameRectCells.remove(cell);
    return sameRectCells;
  }

  bool get _isMutable {
    return state.initialValues[state.selectedCell.index] == 0;
  }

  @override
  void onChange(Change<BoardState> change) {
    _logger.v(change.toString());
    super.onChange(change);
  }

  @override
  Future<void> close() {
    _logger.v("Closed.");
    return super.close();
  }
}
