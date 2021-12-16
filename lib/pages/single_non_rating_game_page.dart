import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudoku_game/blocs/non_rating_game_bloc/non_rating_game_bloc.dart';
import 'package:sudoku_game/blocs/timer_cubit/timer_cubit.dart';
import 'package:sudoku_game/helpers/ads_helper.dart';
import 'package:sudoku_game/helpers/utils.dart';
import 'package:sudoku_game/pages/single_non_rating_game_result_page.dart';
import 'package:sudoku_game/repositories/single_non_rating_game_repository.dart';
import 'package:sudoku_game/widgets/board_view.dart';
import 'package:sudoku_game/widgets/game_page_header.dart';
import 'package:sudoku_game/widgets/user_game_info.dart';

class SingleNonRatingGamePage extends StatefulWidget {
  static Route route(
      GameMode gameMode, SingleNonRatingGameRepository repository) {
    return MaterialPageRoute<void>(
      builder: (_) =>
          SingleNonRatingGamePage(gameMode: gameMode, repository: repository),
      settings: RouteSettings(name: "SingleNonRatingGamePage"),
    );
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
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _timerCubit),
        BlocProvider.value(value: _gameBloc),
      ],
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              BlocConsumer<NonRatingGameBloc, NonRatingGameState>(
                bloc: _gameBloc,
                listener: (context, state) async {
                  if (state is NonRatingGameFinished) {
                    AdsHelper.instance.showInterstitialAd(() {
                      Navigator.pushReplacement(
                          context,
                          SingleNonRatingGameResultPage.route(
                              state.gameResult));
                    });
                  }
                },
                builder: (context, state) {
                  if (state is NonRatingGameLoading ||
                      state is NonRatingGameInitial) {
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
              BlocBuilder<NonRatingGameBloc, NonRatingGameState>(
                bloc: _gameBloc,
                buildWhen: (previousState, state) {
                  return state is NonRatingGamePuzzleRetrieved;
                },
                builder: (context, state) {
                  if (state is NonRatingGamePuzzleRetrieved) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GamePageHeader(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: SizedBox(
                            height: 50,
                            child: GameInfo(
                              primaryValue: getGameTypeName(GameType.free),
                              secondaryValue: getGameModeName(state.gameMode),
                            ),
                          ),
                        ),
                        BoardView(
                            boards: state.boards,
                            onBoardChanges: (changedBoard) {
                              _gameBloc
                                  .add(NonRatingGameBoardChanged(changedBoard));
                            }),
                      ],
                    );
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
