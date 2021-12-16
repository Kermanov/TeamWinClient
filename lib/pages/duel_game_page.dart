import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudoku_game/blocs/rating_game_bloc/rating_game_bloc.dart';
import 'package:sudoku_game/blocs/timer_cubit/timer_cubit.dart';
import 'package:sudoku_game/helpers/ads_helper.dart';
import 'package:sudoku_game/pages/duel_game_result_page.dart';
import 'package:sudoku_game/widgets/board_view.dart';
import 'package:sudoku_game/widgets/context_dialog.dart';
import 'package:sudoku_game/widgets/game_page_header.dart';
import 'package:sudoku_game/widgets/user_game_info.dart';
import 'package:easy_localization/easy_localization.dart';

class DuelGamePage extends StatefulWidget {
  static Route route(String gameId) {
    return MaterialPageRoute<void>(
      builder: (_) => DuelGamePage(gameId: gameId),
      settings: RouteSettings(name: "DuelGamePage"),
    );
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
                            DuelGameResultPage.route(state.gameResult));
                      });
                    } else if (state is GameAborted) {
                      await showInfoDialog(
                          context: context,
                          message: "opponent_did_not_connect".tr());
                      Navigator.pop(context);
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
                    }
                    return Container();
                  },
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BlocBuilder<RatingGameBloc, RatingGameState>(
                      bloc: _gameBloc,
                      buildWhen: (previousState, state) {
                        return state is GamePuzzlesRetrieved;
                      },
                      builder: (context, state) {
                        if (state is GamePuzzlesRetrieved) {
                          return GamePageHeader(
                            showDuration: true,
                            askOnExit: true,
                          );
                        }
                        return Container();
                      },
                    ),
                    BlocBuilder<RatingGameBloc, RatingGameState>(
                      bloc: _gameBloc,
                      buildWhen: (previousState, state) {
                        return state is GamePlayersInfoRetrieved;
                      },
                      builder: (context, state) {
                        if (state is GamePlayersInfoRetrieved) {
                          var playersInfo = state.playersInfo;
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            height: 50,
                            child: Row(
                              children: [
                                Expanded(
                                  child: GameInfo(
                                    primaryValue: playersInfo[0].name,
                                    secondaryValue:
                                        playersInfo[0].rating.toString(),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: BlocBuilder<RatingGameBloc,
                                          RatingGameState>(
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
                                              state.opponentCompletionPercent;
                                        }
                                        return GameInfo(
                                          primaryValue: playersInfo[1].name,
                                          secondaryValue:
                                              playersInfo[1].rating.toString(),
                                          completionPercent: completionPercent,
                                          alignment: CrossAxisAlignment.end,
                                          isOpponent: true,
                                        );
                                      }),
                                )
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
                          return BoardView(
                            boards: state.boards,
                            onBoardChanges: (changedBoard) {
                              _gameBloc.add(GameSendProgress(changedBoard));
                            },
                          );
                        }
                        return Container();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
