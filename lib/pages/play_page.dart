import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_game/blocs/rating_game_page_bloc/rating_game_page_bloc.dart';
import 'package:sudoku_game/blocs/single_page_cubit/single_page_cubit.dart';
import 'package:sudoku_game/blocs/theme_mode_cubit/theme_mode_cubit.dart';
import 'package:sudoku_game/helpers/utils.dart';
import 'package:sudoku_game/pages/game_search_page.dart';
import 'package:sudoku_game/pages/info_page.dart';
import 'package:sudoku_game/repositories/rating_game_page_repository.dart';
import 'package:sudoku_game/repositories/single_non_rating_game_repository.dart';
import 'package:sudoku_game/widgets/play_button.dart';
import 'package:easy_localization/easy_localization.dart';

import 'single_non_rating_game_page.dart';

class PlayPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PlayPageState();
  }
}

class _PlayPageState extends State<PlayPage>
    with AutomaticKeepAliveClientMixin<PlayPage> {
  RatingGamePageBloc _pageBloc;
  SinglePageCubit _singlePageCubit;
  SingleNonRatingGameRepository _repository;
  Future<void> _initPageBlocFuture;

  Future<void> _initPageBloc() async {
    var sharedPrefs = await SharedPreferences.getInstance();

    _pageBloc = RatingGamePageBloc(
      repository: RatingGamePageRepository(
        sharedPreferences: sharedPrefs,
      ),
    );
    _pageBloc.add(RatingGamePageLoadSettings());

    _repository = SingleNonRatingGameRepository(sharedPreferences: sharedPrefs);
    _singlePageCubit = SinglePageCubit(repository: _repository);
    _singlePageCubit.loadSettingsAndSaveInfo();
  }

  @override
  void initState() {
    _initPageBlocFuture = _initPageBloc();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _pageBloc.close();
    _singlePageCubit.close();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
        future: _initPageBlocFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: BlocBuilder<ThemeModeCubit, ThemeModeState>(
                        builder: (context, state) {
                          var imageName = state.themeMode == ThemeMode.dark
                              ? "app_logo_dark.png"
                              : "app_logo_light.png";
                          return Image(
                            image: AssetImage('assets/images/$imageName'),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "competetive".tr(),
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        LittleInfoButton(
                          message: "info.competetive".tr(),
                          title: "competetive".tr(),
                        )
                      ],
                    ),
                    SizedBox(height: 4),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      child: Column(
                        children: [
                          BlocBuilder<RatingGamePageBloc, RatingGamePageState>(
                            bloc: _pageBloc,
                            buildWhen: (previous, current) {
                              return previous.duelGameMode !=
                                  current.duelGameMode;
                            },
                            builder: (context, state) {
                              return PlayButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      GameSearchPage.route(
                                          GameType.duel, state.duelGameMode));
                                },
                                onValueSelected: (gameMode) {
                                  _pageBloc.add(
                                      RatingGamePageSaveDuelSettings(gameMode));
                                },
                                title: "duel_button_text".tr(),
                                subtitle: state.duelGameMode != GameMode.none
                                    ? "difficulty".tr(args: [
                                        getGameModeName(state.duelGameMode)
                                      ])
                                    : "",
                                selectedValue:
                                    state.duelGameMode != GameMode.none
                                        ? state.duelGameMode
                                        : null,
                                selectorTitle: "difficulty_selector_title".tr(),
                                options: getGameModeOptions(),
                              );
                            },
                          ),
                          SizedBox(height: 8),
                          BlocBuilder<RatingGamePageBloc, RatingGamePageState>(
                            bloc: _pageBloc,
                            buildWhen: (previous, current) {
                              return previous.singleGameMode !=
                                  current.singleGameMode;
                            },
                            builder: (context, state) {
                              return PlayButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      GameSearchPage.route(GameType.single,
                                          state.singleGameMode));
                                },
                                onValueSelected: (gameMode) {
                                  _pageBloc.add(
                                      RatingGamePageSaveSingleSettings(
                                          gameMode));
                                },
                                title: "single_button_text".tr(),
                                subtitle: state.singleGameMode != GameMode.none
                                    ? "difficulty".tr(args: [
                                        getGameModeName(state.singleGameMode)
                                      ])
                                    : "",
                                selectedValue:
                                    state.singleGameMode != GameMode.none
                                        ? state.singleGameMode
                                        : null,
                                selectorTitle: "difficulty_selector_title".tr(),
                                options: getGameModeOptions(),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "free_play".tr(),
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          LittleInfoButton(
                            message: "info.free_play".tr(),
                            title: "free_play".tr(),
                          )
                        ],
                      ),
                      SizedBox(height: 4),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        child: Column(
                          children: [
                            BlocBuilder<SinglePageCubit, SinglePageState>(
                              bloc: _singlePageCubit,
                              buildWhen: (previous, current) {
                                return previous.gameMode != current.gameMode;
                              },
                              builder: (context, state) {
                                return PlayButton(
                                  onPressed: () async {
                                    await Navigator.push(
                                        context,
                                        SingleNonRatingGamePage.route(
                                            state.gameMode, _repository));
                                    _singlePageCubit.loadSettingsAndSaveInfo();
                                  },
                                  onValueSelected: (gameMode) {
                                    _singlePageCubit.setGameMode(gameMode);
                                  },
                                  title: "local_button_text".tr(),
                                  subtitle: state.gameMode != GameMode.none
                                      ? "difficulty".tr(args: [
                                          getGameModeName(state.gameMode)
                                        ])
                                      : "",
                                  selectedValue: state.gameMode != GameMode.none
                                      ? state.gameMode
                                      : null,
                                  selectorTitle:
                                      "difficulty_selector_title".tr(),
                                  options: getGameModeOptions(),
                                );
                              },
                            ),
                            BlocBuilder<SinglePageCubit, SinglePageState>(
                              bloc: _singlePageCubit,
                              buildWhen: (previous, current) {
                                return previous.savedGameInfo !=
                                    current.savedGameInfo;
                              },
                              builder: (context, state) {
                                if (state.savedGameInfo !=
                                    SavedGameInfo.empty()) {
                                  return Container(
                                    padding: EdgeInsets.only(top: 8),
                                    width: 256,
                                    height: 56,
                                    child: OutlinedButton(
                                      onPressed: () async {
                                        await Navigator.push(
                                            context,
                                            SingleNonRatingGamePage.route(
                                                GameMode.none, _repository));
                                        _singlePageCubit
                                            .loadSettingsAndSaveInfo();
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "continue".tr(),
                                            style: TextStyle(
                                              fontSize: 22,
                                            ),
                                          ),
                                          Text(
                                            _getContinueButtonSubTitle(
                                                state.savedGameInfo),
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                                return SizedBox();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return Container();
        });
  }

  String _getContinueButtonSubTitle(SavedGameInfo savedGameInfo) {
    return getGameModeName(savedGameInfo.gameMode) +
        " - " +
        formatTime(savedGameInfo.time);
  }

  @override
  bool get wantKeepAlive => true;
}

class LittleInfoButton extends StatelessWidget {
  final String message;
  final String title;

  LittleInfoButton({@required this.message, this.title});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.info_outline),
      iconSize: 20,
      splashRadius: 14,
      padding: EdgeInsets.all(2),
      constraints: BoxConstraints(
        maxHeight: 32,
        maxWidth: 32,
      ),
      color: Theme.of(context).colorScheme.secondary,
      highlightColor: Theme.of(context).colorScheme.secondary.withAlpha(64),
      splashColor: Theme.of(context).colorScheme.secondary.withAlpha(64),
      onPressed: () {
        showInfoPage(context: context, message: message, title: title);
      },
    );
  }
}
