import 'package:flutter/material.dart';
import 'package:sudoku_game/helpers/utils.dart';

class BoardCells extends StatelessWidget {
  final CellPosition selectedCell;
  final void Function(CellPosition cellPosition) onCellSelected;

  const BoardCells({@required this.selectedCell, this.onCellSelected});

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
                      return Expanded(
                          child: GestureDetector(
                        child:
                            row == selectedCell?.row && col == selectedCell?.col
                                ? Container(color: Colors.grey[300])
                                : Container(color: Colors.white),
                        onTap: () =>
                            onCellSelected?.call(CellPosition(col, row)),
                      ));
                    }).toList()));
          }).toList(),
        ));
  }
}
