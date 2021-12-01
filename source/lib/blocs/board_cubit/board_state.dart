part of 'board_cubit.dart';

enum BoardAction { initialValuesRetrieved, cellSelected, mutableValuesChanged }

class BoardState {
  final List<int> initialValues;
  final List<int> mutableValues;
  final CellPosition selectedCell;
  final BoardAction action;

  const BoardState(
      {this.initialValues, this.mutableValues, this.selectedCell, this.action});

  BoardState copyWith(
      {List<int> initialValues,
      List<int> mutableValues,
      CellPosition selectedCell,
      BoardAction action}) {
    return BoardState(
        initialValues: initialValues ?? this.initialValues,
        mutableValues: mutableValues ?? this.mutableValues,
        selectedCell: selectedCell ?? this.selectedCell,
        action: action ?? this.action);
  }

  @override
  String toString() {
    return "BoardState($action)";
  }
}
