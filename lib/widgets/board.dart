import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudoku_game/blocs/board_cubit/board_cubit.dart';
import 'package:sudoku_game/widgets/board_cells.dart';
import 'package:sudoku_game/widgets/board_grid.dart';
import 'package:sudoku_game/widgets/board_numbers.dart';
import 'package:sudoku_game/themes/theme.dart';

import 'board_background.dart';
import 'board_hints.dart';

class Board extends StatelessWidget {
  final BoardCubit boardCubit;

  Board({@required this.boardCubit}) : assert(boardCubit != null);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BoardBackground(),
        BlocBuilder<BoardCubit, BoardState>(
          bloc: boardCubit,
          buildWhen: (previousState, state) {
            return state.action == BoardAction.cellSelected ||
                state.action == BoardAction.mutableValuesChanged ||
                state.action == BoardAction.errorsChanged;
          },
          builder: (context, state) {
            return BoardCells(
              allValues: state.allValues,
              errorIndices: state.errorIndices,
              selectedCell: state.selectedCell,
              onCellSelected: (selectedCell) {
                boardCubit.cellSelected(selectedCell);
              },
            );
          },
        ),
        BlocBuilder<BoardCubit, BoardState>(
          bloc: boardCubit,
          buildWhen: (previousState, state) {
            return state.action == BoardAction.hintChanged ||
                state.action == BoardAction.cellSelected;
          },
          builder: (context, state) {
            return BoardHints(
              hints: state.hints,
              selectedCell: state.selectedCell,
              color: Theme.of(context).colorScheme.accent,
            );
          },
        ),
        BlocBuilder<BoardCubit, BoardState>(
          bloc: boardCubit,
          buildWhen: (previousState, state) {
            return state.action == BoardAction.initialValuesRetrieved;
          },
          builder: (context, state) {
            return BoardNumbers(
              numbers: state.initialValues,
              color: Theme.of(context).colorScheme.onSurface,
            );
          },
        ),
        BlocBuilder<BoardCubit, BoardState>(
          bloc: boardCubit,
          buildWhen: (previousState, state) {
            return state.action == BoardAction.cellSelected ||
                state.action == BoardAction.mutableValuesChanged ||
                state.action == BoardAction.errorsChanged;
          },
          builder: (context, state) {
            return BoardNumbers(
              selectedCell: state.selectedCell,
              errorIndices: state.errorIndices,
              numbers: state.mutableValues,
              color: Theme.of(context).colorScheme.accent,
            );
          },
        ),
        BoardGrid()
      ],
    );
  }
}
