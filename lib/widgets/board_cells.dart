import 'package:flutter/material.dart';
import 'package:sudoku_game/helpers/utils.dart';
import 'package:sudoku_game/themes/theme.dart';

class BoardCells extends StatelessWidget {
  final CellPosition selectedCell;
  final void Function(CellPosition cellPosition) onCellSelected;
  final List<int> errorIndices;
  final List<int> allValues;

  const BoardCells({
    @required this.selectedCell,
    this.onCellSelected,
    @required this.errorIndices,
    @required this.allValues,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(16)),
      child: AspectRatio(
        aspectRatio: 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(9, (index) => index).map((row) {
            return Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(9, (index) => index).map((col) {
                  return Expanded(
                    child: GestureDetector(
                      child: _buildCell(context, row, col),
                      onTapDown: (_) =>
                          onCellSelected?.call(CellPosition(col, row)),
                    ),
                  );
                }).toList(),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCell(BuildContext context, int row, int col) {
    if (row == selectedCell?.row && col == selectedCell?.col) {
      return Container(
        color: Theme.of(context).colorScheme.selectedCell,
      );
    } else if (_markAsError(row, col)) {
      return Container(
        color: Theme.of(context).colorScheme.errorCell,
      );
    } else if (_isSameValueAsSelected(row, col)) {
      return Container(
        color: Theme.of(context).colorScheme.cellWithSameValue,
      );
    } else if (_isSameSquareRowCol(row, col)) {
      return Container(
        color: Theme.of(context).colorScheme.relatedCell,
      );
    }
    return Container(color: Colors.transparent);
  }

  bool _isSameSquareRowCol(int row, int col) {
    if (selectedCell != null) {
      return (row == selectedCell.row ||
              col == selectedCell.col ||
              row ~/ 3 == selectedCell.row ~/ 3 &&
                  col ~/ 3 == selectedCell.col ~/ 3) &&
          !(row == selectedCell.row && col == selectedCell.col);
    }
    return false;
  }

  bool _isCellWithError(int row, int col) {
    var index = CellPosition(col, row).index;
    return errorIndices.contains(index);
  }

  bool _isSameValueAsSelected(int row, int col) {
    return selectedCell != null &&
        allValues[selectedCell.index] != 0 &&
        allValues[selectedCell.index] ==
            allValues[CellPosition(col, row).index];
  }

  bool _markAsError(int row, int col) {
    return _isSameSquareRowCol(row, col) &&
        _isCellWithError(row, col) &&
        _isSameValueAsSelected(row, col);
  }
}
