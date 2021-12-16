part of 'board_cubit.dart';

enum BoardAction {
  initialValuesRetrieved,
  cellSelected,
  mutableValuesChanged,
  hintChanged,
  errorsChanged,
  hintModeChanged,
}

class BoardState {
  final List<int> initialValues;
  final List<int> mutableValues;
  final CellPosition selectedCell;
  final BoardAction action;
  final List<int> errorIndices;
  final bool hintMode;
  final List<List<int>> hints;

  const BoardState({
    this.initialValues,
    this.mutableValues,
    this.selectedCell,
    this.action,
    this.errorIndices,
    this.hintMode,
    this.hints,
  });

  const BoardState.initial({
    @required this.initialValues,
    @required this.mutableValues,
    @required this.hints,
  })  : selectedCell = null,
        action = BoardAction.initialValuesRetrieved,
        errorIndices = const [],
        hintMode = false;

  BoardState copyWith({
    List<int> initialValues,
    List<int> mutableValues,
    CellPosition selectedCell,
    BoardAction action,
    List<int> errorIndices,
    bool hintMode,
    List<List<int>> hints,
  }) {
    return BoardState(
      initialValues: initialValues ?? this.initialValues,
      mutableValues: mutableValues ?? this.mutableValues,
      selectedCell: selectedCell ?? this.selectedCell,
      action: action ?? this.action,
      errorIndices: errorIndices ?? this.errorIndices,
      hintMode: hintMode ?? this.hintMode,
      hints: hints ?? this.hints,
    );
  }

  List<int> get allValues {
    return List.generate(81, (index) {
      return initialValues[index] == 0
          ? mutableValues[index]
          : initialValues[index];
    });
  }

  @override
  String toString() {
    return "BoardState($action)";
  }
}
