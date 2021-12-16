import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudoku_game/blocs/rating_game_bloc/rating_game_bloc.dart';
import 'package:sudoku_game/blocs/timer_cubit/timer_cubit.dart';
import 'package:sudoku_game/helpers/utils.dart';
import 'package:easy_localization/easy_localization.dart';

import 'context_dialog.dart';
import 'custom_icon_button.dart';

class GamePageHeader extends StatelessWidget {
  final bool showDuration;
  final bool askOnExit;

  GamePageHeader({this.showDuration = false, this.askOnExit = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomIconButton(
          iconData: Icons.arrow_back,
          onTap: askOnExit
              ? () async {
                  var leaveGame = await showQuestionDialog(
                      context: context, question: "leave_dialog_message".tr());
                  if (leaveGame ?? false) {
                    Navigator.pop(context);
                  }
                }
              : () => Navigator.pop(context),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            showDuration
                ? Opacity(
                    opacity: 0,
                    child: Text(
                      "minutes".tr(args: ["00"]),
                      style: TextStyle(fontSize: 12),
                    ),
                  )
                : SizedBox(),
            SizedBox(width: 2),
            BlocBuilder<TimerCubit, TimerState>(
              buildWhen: (_, state) {
                return state is TimerTimeChanged;
              },
              builder: (context, state) {
                if (state is TimerTimeChanged) {
                  return Text(
                    formatTime(state.milliseconds),
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  );
                }
                return Container();
              },
            ),
            SizedBox(width: 2),
            showDuration
                ? BlocBuilder<RatingGameBloc, RatingGameState>(
                    buildWhen: (previousState, state) {
                      return state is GameDurationRetrieved;
                    },
                    builder: (context, state) {
                      if (state is GameDurationRetrieved &&
                          state.duration != null) {
                        return Text(
                          "minutes".tr(args: [state.minutes.toString()]),
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                Theme.of(context).colorScheme.secondaryVariant,
                          ),
                        );
                      }
                      return Opacity(
                        opacity: 0,
                        child: Text(
                          "minutes".tr(args: ["00"]),
                          style: TextStyle(fontSize: 12),
                        ),
                      );
                    },
                  )
                : SizedBox(),
          ],
        ),
        SizedBox(width: 64, height: 64),
      ],
    );
  }
}
