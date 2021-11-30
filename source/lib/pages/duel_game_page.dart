import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sudoku_game/blocs/rating_game_bloc/rating_game_bloc.dart';
import 'package:sudoku_game/blocs/timer_cubit/timer_cubit.dart';
import 'package:sudoku_game/pages/duel_game_result_page.dart';
import 'package:sudoku_game/widgets/board.dart';
import 'package:sudoku_game/widgets/board_view.dart';
import 'package:sudoku_game/widgets/game_aborted_dialog.dart';
import 'package:sudoku_game/widgets/game_leave_dialog.dart';

class DuelGamePage extends StatefulWidget {
  static Route route(String gameId) {
    return MaterialPageRoute<void>(
        builder: (_) => DuelGamePage(gameId: gameId));
  }

  final String gameId;

  DuelGamePage({@required this.gameId}) : assert(gameId != null);

  @override
  State<StatefulWidget> createState() {
    return _DuelGamePageState();
  }
}

class _DuelGamePageState extends State<DuelGamePage> {
  TimerCubit _timerCubit;
  RatingGameBloc _gameBloc;

  @override
  void initState() {
    _timerCubit = TimerCubit(1000);
    _gameBloc = RatingGameBloc(gameId: widget.gameId, timerCubit: _timerCubit);
    _gameBloc.add(GameReadyToStart());
    super.initState();
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await _gameBloc.close();
    await _timerCubit.close();
  }

  Future<bool> _showLeaveDialog(BuildContext context) async {
    return await showDialog<bool>(
        context: context, builder: (_) => GameLeaveDialog());
  }

  Future<void> _showGameAbortedDialog(BuildContext context) async {
    return await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => GameAbortedDialog());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await _showLeaveDialog(context);
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text("Duel Game"),
          ),
          body: Stack(
            children: [
              BlocConsumer<RatingGameBloc, RatingGameState>(
                  cubit: _gameBloc,
                  listener: (context, state) async {
                    if (state is GameFinished) {
                      await Navigator.push(
                          context, DuelGameResultPage.route(state.gameResult));
                    } else if (state is GameAborted) {
                      await _showGameAbortedDialog(context);
                    }
                  },
                  builder: (context, state) {
                    if (state is GameWaiting || state is GameInitial) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      return Container();
                    }
                  }),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BlocBuilder<TimerCubit, TimerState>(
                            cubit: _timerCubit,
                            buildWhen: (_, state) {
                              return state is TimerTimeChanged;
                            },
                            builder: (context, state) {
                              if (state is TimerTimeChanged) {
                                var date = DateTime.fromMillisecondsSinceEpoch(
                                    state.milliseconds);
                                return Text(DateFormat.ms().format(date));
                              } else {
                                return Container();
                              }
                            }),
                        BlocBuilder<RatingGameBloc, RatingGameState>(
                          cubit: _gameBloc,
                          buildWhen: (_, state) {
                            return state is GamePlayersInfoRetrieved;
                          },
                          builder: (context, state) {
                            if (state is GamePlayersInfoRetrieved) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      "${state.playersInfo[0].name} ${state.playersInfo[0].rating}"),
                                  Text("vs"),
                                  Text(
                                      "${state.playersInfo[1].name} ${state.playersInfo[1].rating}"),
                                ],
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                        BlocBuilder<RatingGameBloc, RatingGameState>(
                          cubit: _gameBloc,
                          buildWhen: (_, state) {
                            return state
                                is GameOpponentCompletionPercentRetrieved;
                          },
                          builder: (context, state) {
                            if (state
                                is GameOpponentCompletionPercentRetrieved) {
                              return Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                    state.opponentCompletionPercent.toString() +
                                        "%"),
                              );
                            } else {
                              return Container();
                            }
                          },
                        )
                      ],
                    ),
                  ),
                  BlocBuilder<RatingGameBloc, RatingGameState>(
                    cubit: _gameBloc,
                    buildWhen: (previousState, state) {
                      return state is GamePuzzlesRetrieved;
                    },
                    builder: (context, state) {
                      if (state is GamePuzzlesRetrieved) {
                        return Expanded(
                            child: BoardView(
                                boards: state.boards,
                                onBoardChanges: (changedBoard) {
                                  _gameBloc.add(GameSendProgress(changedBoard));
                                }));
                      } else {
                        return Container();
                      }
                    },
                  )
                ],
              )
            ],
          )),
    );
  }
}
