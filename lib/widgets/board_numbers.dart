import 'package:flutter/material.dart';
import 'package:sudoku_game/helpers/utils.dart';
import 'package:sudoku_game/themes/theme.dart';

class BoardNumbers extends StatelessWidget {
  final List<int> numbers;
  final Color color;
  final List<int> errorIndices;
  final CellPosition selectedCell;

  const BoardNumbers({
    @required this.numbers,
    this.color = Colors.black,
    this.errorIndices = const [],
    this.selectedCell,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(9, (index) => index).map((row) {
          return Expanded(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(9, (index) => index).map((col) {
                    var number = numbers[CellPosition(col, row).index];
                    return Expanded(
                        child: IgnorePointer(
                      child: number != 0
                          ? Center(
                              child: Text(
                              number.toString(),
                              style: _getTextStyle(context, row, col),
                            ))
                          : Container(),
                    ));
                  }).toList()));
        }).toList(),
      ),
    );
  }

  TextStyle _getTextStyle(BuildContext context, int row, int col) {
    if (_isSelectedCell(row, col)) {
      return TextStyle(
        color: Theme.of(context).colorScheme.selectedValue,
        fontSize: 22,
      );
    } else if (_isCellWithError(row, col)) {
      return TextStyle(
        color: Theme.of(context).colorScheme.errorValue,
        fontSize: 22,
      );
    }
    return TextStyle(
      color: color,
      fontSize: 22,
    );
  }

  bool _isCellWithError(int row, int col) {
    var index = CellPosition(col, row).index;
    return errorIndices.contains(index);
  }

  bool _isSelectedCell(int row, int col) {
    return selectedCell == CellPosition(col, row);
  }
}
