import 'package:flutter/material.dart';
import 'package:sudoku_game/blocs/board_cubit/board_cubit.dart';

import 'board.dart';

class BoardView extends StatelessWidget {
  final List<BoardData> boards;
  final void Function(ChangedBoardData) onBoardChanges;

  const BoardView({@required this.boards, this.onBoardChanges});

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: PageController(initialPage: 0),
      children: boards
          .map((board) => Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Board(
                  boardData: board,
                  onBoardChanges: onBoardChanges,
                ),
              ))
          .toList(),
    );
  }
}
