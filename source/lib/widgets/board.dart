import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudoku_game/blocs/board_cubit/board_cubit.dart';
import 'package:sudoku_game/widgets/board_cells.dart';
import 'package:sudoku_game/widgets/board_grid.dart';
import 'package:sudoku_game/widgets/board_numbers.dart';
import 'package:sudoku_game/widgets/board_input.dart';

class Board extends StatelessWidget {
  final BoardCubit _boardCubit;
  final void Function(ChangedBoardData) onBoardChanges;

  Board({@required BoardData boardData, this.onBoardChanges})
      : assert(boardData != null),
        _boardCubit =
            BoardCubit(boardData: boardData, onBoardChanges: onBoardChanges);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Stack(
          children: [
            BlocBuilder<BoardCubit, BoardState>(
              bloc: _boardCubit,
              buildWhen: (previousState, state) {
                return state.action == BoardAction.cellSelected;
              },
              builder: (context, state) {
                return BoardCells(
                  selectedCell: state.selectedCell,
                  onCellSelected: (selectedCell) {
                    _boardCubit.cellSelected(selectedCell);
                  },
                );
              },
            ),
            BlocBuilder<BoardCubit, BoardState>(
              bloc: _boardCubit,
              buildWhen: (previousState, state) {
                return state.action == BoardAction.initialValuesRetrieved;
              },
              builder: (context, state) {
                return BoardNumbers(numbers: state.initialValues);
              },
            ),
            BlocBuilder<BoardCubit, BoardState>(
              bloc: _boardCubit,
              buildWhen: (previousState, state) {
                return state.action == BoardAction.mutableValuesChanged;
              },
              builder: (context, state) {
                return BoardNumbers(
                  numbers: state.mutableValues,
                  color: Colors.cyan,
                );
              },
            ),
            BoardGrid()
          ],
        ),
        SizedBox(height: 15),
        BoardInput(onNumberSelected: (number) {
          _boardCubit.numberSelected(number);
        }),
        SizedBox(
          height: 50,
        )
      ],
    );
  }
}
