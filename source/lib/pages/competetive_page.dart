import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_game/blocs/rating_game_page_bloc/rating_game_page_bloc.dart';
import 'package:sudoku_game/helpers/utils.dart';
import 'package:sudoku_game/pages/game_search_page.dart';
import 'package:sudoku_game/pages/info_page.dart';
import 'package:sudoku_game/repositories/rating_game_page_repository.dart';
import 'package:sudoku_game/widgets/play_button.dart';

class CompetetivePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CompetetivePageState();
  }
}

class _CompetetivePageState extends State<CompetetivePage>
    with AutomaticKeepAliveClientMixin<CompetetivePage> {
  RatingGamePageBloc _pageBloc;
  Future<void> _initPageBlocFuture;

  Future<void> _initPageBloc() async {
    _pageBloc = RatingGamePageBloc(
      repository: RatingGamePageRepository(
        sharedPreferences: await SharedPreferences.getInstance(),
      ),
    );
    _pageBloc.add(RatingGamePageLoadSettings());
  }

  @override
  void initState() {
    _initPageBlocFuture = _initPageBloc();
    super.initState();
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await _pageBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        Positioned(
          right: 15,
          top: 15,
          child: IconButton(
            icon: Icon(Icons.info_outline),
            iconSize: 32,
            onPressed: () {
              showDialog<bool>(
                context: context,
                builder: (_) => InfoPage(
                    message:
                        "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim."),
              );
            },
          ),
        ),
        Column(
          children: [
            Expanded(
              flex: 2,
              child: Center(
                child: Container(
                  width: double.infinity,
                  child: Text(
                    "Play Online",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: FutureBuilder(
                  future: _initPageBlocFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
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
                                title: "FIND DUEL GAME",
                                subtitle: state.duelGameMode != GameMode.none
                                    ? "Difficulty: ${getGameModeName(state.duelGameMode)}"
                                    : "",
                                selectedValue:
                                    state.duelGameMode != GameMode.none
                                        ? state.duelGameMode
                                        : null,
                                selectorTitle: "Choose difficulty level.",
                                options: getGameModeOptions(),
                              );
                            },
                          ),
                          SizedBox(height: 10),
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
                                title: "START SINGLE GAME",
                                subtitle: state.singleGameMode != GameMode.none
                                    ? "Difficulty: ${getGameModeName(state.singleGameMode)}"
                                    : "",
                                selectedValue:
                                    state.singleGameMode != GameMode.none
                                        ? state.singleGameMode
                                        : null,
                                selectorTitle: "Choose difficulty level.",
                                options: getGameModeOptions(),
                              );
                            },
                          ),
                        ],
                      );
                    }
                    return Container();
                  }),
            ),
          ],
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
