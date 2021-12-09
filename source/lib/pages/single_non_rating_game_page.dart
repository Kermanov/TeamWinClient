import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sudoku_game/blocs/non_rating_game_bloc/non_rating_game_bloc.dart';
import 'package:sudoku_game/blocs/timer_cubit/timer_cubit.dart';
import 'package:sudoku_game/helpers/utils.dart';
import 'package:sudoku_game/pages/single_non_rating_game_result_page.dart';
import 'package:sudoku_game/repositories/single_non_rating_game_repository.dart';
import 'package:sudoku_game/widgets/board_view.dart';
import 'package:sudoku_game/widgets/game_leave_dialog.dart';

class SingleNonRatingGamePage extends StatefulWidget {
  static Route route(
      GameMode gameMode, SingleNonRatingGameRepository repository) {
    return MaterialPageRoute<void>(
        builder: (_) => SingleNonRatingGamePage(
            gameMode: gameMode, repository: repository));
  }

  final GameMode gameMode;
  final SingleNonRatingGameRepository repository;

  SingleNonRatingGamePage({@required this.gameMode, @required this.repository})
      : assert(repository != null),
        assert(gameMode != null);

  @override
  State<StatefulWidget> createState() {
    return _SingleNonRatingGamePageState();
  }
}

class _SingleNonRatingGamePageState extends State<SingleNonRatingGamePage> {
  TimerCubit _timerCubit;
  NonRatingGameBloc _gameBloc;

  @override
  void initState() {
    super.initState();
    _timerCubit = TimerCubit(1000);
    _gameBloc = NonRatingGameBloc(
        gameMode: widget.gameMode,
        gameRepository: widget.repository,
        timerCubit: _timerCubit);
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
          return await showDialog(
              context: context, builder: (_) => GameLeaveDialog());
        },
        child: Scaffold(
          body: Stack(
            children: [
              BlocConsumer<NonRatingGameBloc, NonRatingGameState>(
                bloc: _gameBloc,
                listener: (context, state) async {
                  if (state is NonRatingGameFinished) {
                    await Navigator.push(context,
                        SingleNonRatingGameResultPage.route(state.gameResult));
                  }
                },
                builder: (context, state) {
                  if (state is NonRatingGameLoading ||
                      state is NonRatingGameInitial) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Container();
                  }
                },
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  BlocBuilder<NonRatingGameBloc, NonRatingGameState>(
                    bloc: _gameBloc,
                    buildWhen: (previousState, state) {
                      return state is NonRatingGamePuzzleRetrieved;
                    },
                    builder: (context, state) {
                      if (state is NonRatingGamePuzzleRetrieved) {
                        return Expanded(
                            child: BoardView(
                                boards: state.boards,
                                onBoardChanges: (changedBoard) {
                                  _gameBloc.add(
                                      NonRatingGameBoardChanged(changedBoard));
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
