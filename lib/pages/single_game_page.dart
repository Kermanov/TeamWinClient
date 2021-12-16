import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudoku_game/blocs/rating_game_bloc/rating_game_bloc.dart';
import 'package:sudoku_game/blocs/timer_cubit/timer_cubit.dart';
import 'package:sudoku_game/helpers/ads_helper.dart';
import 'package:sudoku_game/helpers/utils.dart';
import 'package:sudoku_game/widgets/board_view.dart';
import 'package:sudoku_game/widgets/context_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sudoku_game/widgets/game_page_header.dart';
import 'package:sudoku_game/widgets/user_game_info.dart';

import 'single_game_result_page.dart';

class SingleGamePage extends StatefulWidget {
  static Route route(String gameId, GameMode gameMode) {
    return MaterialPageRoute<void>(
      builder: (_) => SingleGamePage(gameId: gameId, gameMode: gameMode),
      settings: RouteSettings(name: "SingleGamePage"),
    );
  }

  final String gameId;
  final GameMode gameMode;

  SingleGamePage({@required this.gameId, @required this.gameMode})
      : assert(gameId != null),
        assert(gameMode != null);

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
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _timerCubit),
        BlocProvider.value(value: _gameBloc),
      ],
      child: SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            var leaveGame = await showQuestionDialog(
                context: context, question: "leave_dialog_message".tr());
            if (leaveGame) {
              Navigator.pop(context);
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
                      AdsHelper.instance.showInterstitialAd(() {
                        Navigator.pushReplacement(context,
                            SingleGameResultPage.route(state.gameResult));
                      });
                    }
                  },
                  builder: (context, state) {
                    if (state is GameWaiting || state is GameInitial) {
                      return Center(
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: CircularProgressIndicator(strokeWidth: 6),
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
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GamePageHeader(
                            showDuration: true,
                            askOnExit: true,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: SizedBox(
                              height: 50,
                              child: GameInfo(
                                primaryValue: getGameTypeName(GameType.single),
                                secondaryValue:
                                    getGameModeName(widget.gameMode),
                              ),
                            ),
                          ),
                          BoardView(
                            boards: state.boards,
                            onBoardChanges: (changedBoard) {
                              _gameBloc.add(GameSendProgress(changedBoard));
                            },
                          ),
                        ],
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
