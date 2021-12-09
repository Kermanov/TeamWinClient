import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sudoku_game/blocs/rating_game_bloc/rating_game_bloc.dart';
import 'package:sudoku_game/blocs/timer_cubit/timer_cubit.dart';
import 'package:sudoku_game/widgets/board_view.dart';
import 'package:sudoku_game/widgets/game_leave_dialog.dart';

import 'single_game_result_page.dart';

class SingleGamePage extends StatefulWidget {
  static Route route(String gameId) {
    return MaterialPageRoute<void>(
        builder: (_) => SingleGamePage(gameId: gameId));
  }

  final String gameId;

  SingleGamePage({@required this.gameId}) : assert(gameId != null);

  @override
  State<StatefulWidget> createState() {
    return _SingleGamePageState();
  }
}

class _SingleGamePageState extends State<SingleGamePage> {
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          var leaveGame = await showDialog<bool>(
              context: context, builder: (_) => GameLeaveDialog());
          if (leaveGame) {
            Navigator.popUntil(
                context, (route) => route.settings.name == "HomePage");
          }
          return false;
        },
        child: Scaffold(
          body: Stack(
            children: [
              BlocConsumer<RatingGameBloc, RatingGameState>(
                bloc: _gameBloc,
                listener: (context, state) async {
                  if (state is GameFinished) {
                    await Navigator.push(
                        context, SingleGameResultPage.route(state.gameResult));
                  }
                },
                builder: (context, state) {
                  if (state is GameWaiting || state is GameInitial) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Container();
                  }
                },
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  BlocBuilder<TimerCubit, TimerState>(
                    bloc: _timerCubit,
                    buildWhen: (_, state) {
                      return state is TimerTimeChanged;
                    },
                    builder: (context, state) {
                      if (state is TimerTimeChanged) {
                        var date = DateTime.fromMillisecondsSinceEpoch(
                            state.milliseconds);
                        return Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            padding: EdgeInsets.only(top: 20),
                            child: Text(
                              DateFormat.ms().format(date),
                              style: TextStyle(
                                fontSize: 30,
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                  BlocBuilder<RatingGameBloc, RatingGameState>(
                    bloc: _gameBloc,
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
              ),
              Positioned(
                left: 15,
                top: 15,
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  iconSize: 32,
                  onPressed: () async {
                    var leaveGame = await showDialog<bool>(
                        context: context, builder: (_) => GameLeaveDialog());
                    if (leaveGame) {
                      Navigator.popUntil(context,
                          (route) => route.settings.name == "HomePage");
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
