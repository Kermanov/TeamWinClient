import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sudoku_game/blocs/rating_game_bloc/rating_game_bloc.dart';
import 'package:sudoku_game/blocs/timer_cubit/timer_cubit.dart';
import 'package:sudoku_game/pages/duel_game_result_page.dart';
import 'package:sudoku_game/widgets/board_view.dart';
import 'package:sudoku_game/widgets/game_aborted_dialog.dart';
import 'package:sudoku_game/widgets/game_leave_dialog.dart';
import 'package:sudoku_game/widgets/user_game_info.dart';

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

  Future<void> _showGameAbortedDialog(BuildContext context) async {
    return await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => GameAbortedDialog());
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
                        context, DuelGameResultPage.route(state.gameResult));
                  } else if (state is GameAborted) {
                    await _showGameAbortedDialog(context);
                  }
                },
                builder: (context, state) {
                  if (state is GameWaiting || state is GameInitial) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return Container();
                },
              ),
              BlocBuilder<TimerCubit, TimerState>(
                bloc: _timerCubit,
                buildWhen: (_, state) {
                  return state is TimerTimeChanged;
                },
                builder: (context, state) {
                  if (state is TimerTimeChanged) {
                    var date =
                        DateTime.fromMillisecondsSinceEpoch(state.milliseconds);
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
                  }
                  return Container();
                },
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(height: 50),
                  BlocBuilder<RatingGameBloc, RatingGameState>(
                    bloc: _gameBloc,
                    buildWhen: (previousState, state) {
                      return state is GamePlayersInfoRetrieved;
                    },
                    builder: (context, state) {
                      if (state is GamePlayersInfoRetrieved) {
                        var playersInfo = state.playersInfo;
                        return Container(
                          padding: EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Expanded(
                                child: UserGameInfo(
                                  userName: playersInfo[0].name,
                                  value: playersInfo[0].rating.toString(),
                                ),
                              ),
                              SizedBox(width: 20),
                              BlocBuilder<RatingGameBloc, RatingGameState>(
                                  bloc: _gameBloc,
                                  buildWhen: (previousState, state) {
                                    return state
                                        is GameOpponentCompletionPercentRetrieved;
                                  },
                                  builder: (context, state) {
                                    var completionPercent = 0.0;
                                    if (state
                                        is GameOpponentCompletionPercentRetrieved) {
                                      completionPercent =
                                          state.opponentCompletionPercent /
                                              100.0;
                                    }
                                    return Expanded(
                                      child: UserGameInfo(
                                        userName: playersInfo[1].name,
                                        value: playersInfo[1].rating.toString(),
                                        completionPercent: completionPercent,
                                      ),
                                    );
                                  })
                            ],
                          ),
                        );
                      }
                      return Container();
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
                      }
                      return Container();
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
