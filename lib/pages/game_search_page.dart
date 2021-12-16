import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudoku_game/blocs/connectivity_bloc/connectivity_bloc.dart';
import 'package:sudoku_game/blocs/game_search_bloc/game_search_bloc.dart';
import 'package:sudoku_game/blocs/timer_cubit/timer_cubit.dart';
import 'package:sudoku_game/helpers/utils.dart';
import 'package:sudoku_game/helpers/error_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sudoku_game/widgets/custom_icon_button.dart';

import 'duel_game_page.dart';
import 'single_game_page.dart';

class GameSearchPage extends StatefulWidget {
  static Route route(GameType gameType, GameMode gameMode) {
    return MaterialPageRoute<void>(
      builder: (_) => GameSearchPage(
        gameType: gameType,
        gameMode: gameMode,
      ),
      settings: RouteSettings(name: "GameSearchPage." + gameType.toString()),
    );
  }

  final GameType gameType;
  final GameMode gameMode;

  GameSearchPage({@required this.gameType, @required this.gameMode})
      : assert(gameType != null),
        assert(gameMode != null);

  @override
  _GameSearchPageState createState() => _GameSearchPageState();
}

class _GameSearchPageState extends State<GameSearchPage> {
  final GameSearchBloc _gameSearchBloc = GameSearchBloc();
  TimerCubit _timerCubit;

  @override
  void initState() {
    _gameSearchBloc.add(GameSearchStarted(widget.gameType, widget.gameMode));
    if (widget.gameType == GameType.duel) {
      _timerCubit = TimerCubit(1000);
      _timerCubit.start();
    }
    super.initState();
  }

  @override
  void dispose() {
    _gameSearchBloc.close();
    _timerCubit?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<GameSearchBloc, GameSearchState>(
          bloc: _gameSearchBloc,
          listener: (context, state) {
            if (state is GameSearchComplete) {
              if (widget.gameType == GameType.single) {
                Navigator.pushReplacement(
                  context,
                  SingleGamePage.route(
                    state.gameId,
                    widget.gameMode,
                  ),
                );
              } else if (widget.gameType == GameType.duel) {
                Navigator.pushReplacement(
                  context,
                  DuelGamePage.route(state.gameId),
                );
              }
            } else if (state is GameSearchCancelled) {
              Navigator.pop(context);
            }
          },
        ),
        BlocListener<ConnectivityBloc, ConnectivityState>(
          listener: (context, state) {
            if (!state.connected) {
              showErrorSnackBar(context, "error.connection_lost".tr());
              Navigator.pop(context);
            }
          },
        ),
      ],
      child: WillPopScope(
        onWillPop: () {
          _gameSearchBloc.add(GameSearchAbort(widget.gameType));
          return Future.value(false);
        },
        child: SafeArea(
          child: Scaffold(
            body: Stack(
              children: [
                Positioned(
                  left: 15,
                  top: 15,
                  child: CustomIconButton(
                    iconData: Icons.arrow_back,
                    onTap: () {
                      _gameSearchBloc.add(GameSearchAbort(widget.gameType));
                    },
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BlocBuilder<GameSearchBloc, GameSearchState>(
                        bloc: _gameSearchBloc,
                        builder: (context, state) {
                          if (state is GameSearchAborting ||
                              state is GameSearchCancelled) {
                            return Text(
                              "search.cancelling".tr(),
                              style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                          return Text(
                            widget.gameType == GameType.single
                                ? "search.creating".tr()
                                : "search.searching".tr(),
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                      Text(getGameTypeName(widget.gameType) +
                          ", " +
                          getGameModeName(widget.gameMode)),
                      SizedBox(height: 20),
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CircularProgressIndicator(strokeWidth: 6),
                            widget.gameType == GameType.duel
                                ? Center(
                                    child: BlocBuilder<TimerCubit, TimerState>(
                                      bloc: _timerCubit,
                                      builder: (context, state) {
                                        if (state is TimerTimeChanged) {
                                          return Text(
                                            formatTime(state.milliseconds),
                                            style: TextStyle(
                                              fontSize: 20,
                                            ),
                                          );
                                        }
                                        return Container();
                                      },
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        height: 40,
                        width: 120,
                        child: TextButton(
                          onPressed: () {
                            _gameSearchBloc
                                .add(GameSearchAbort(widget.gameType));
                          },
                          child: Text(
                            "cancel".tr(),
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
