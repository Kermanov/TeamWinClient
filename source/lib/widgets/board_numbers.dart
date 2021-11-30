import 'package:flutter/material.dart';
import 'package:sudoku_game/helpers/utils.dart';

class BoardNumbers extends StatelessWidget {
  final List<int> numbers;
  final Color color;

  const BoardNumbers({@required this.numbers, this.color = Colors.black});

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
                                textScaleFactor: 1.5,
                                style: TextStyle(color: color),
                              ))
                            : Container(),
                      ));
                    }).toList()));
          }).toList(),
        ));
  }
}
