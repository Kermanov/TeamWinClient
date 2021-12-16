import 'package:flutter/material.dart';
import 'package:sudoku_game/helpers/utils.dart';
import 'package:sudoku_game/themes/theme.dart';

class BoardHints extends StatelessWidget {
  final List<List<int>> hints;
  final Color color;
  final CellPosition selectedCell;

  BoardHints({
    @required this.hints,
    @required this.color,
    @required this.selectedCell,
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
                    var hint = hints[CellPosition(col, row).index];
                    return Expanded(
                      child: IgnorePointer(
                        child: Hint(
                          hint: hint,
                          color: _getColor(context, row, col),
                        ),
                      ),
                    );
                  }).toList()));
        }).toList(),
      ),
    );
  }

  Color _getColor(BuildContext context, int row, int col) {
    if (selectedCell == CellPosition(col, row)) {
      return Theme.of(context).colorScheme.selectedValue;
    }
    return color;
  }
}

class Hint extends StatelessWidget {
  final List<int> hint;
  final Color color;

  Hint({@required this.hint, @required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: AspectRatio(
        aspectRatio: 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(3, (index) => index).map((row) {
            return Expanded(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(3, (index) => index).map((col) {
                      var index = CellPosition(col, row, 3).index;
                      var number = index + 1;
                      return Expanded(
                        child: IgnorePointer(
                          child: hint.contains(number)
                              ? Center(
                                  child: Text(
                                    number.toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: color,
                                    ),
                                  ),
                                )
                              : Container(),
                        ),
                      );
                    }).toList()));
          }).toList(),
        ),
      ),
    );
  }
}
