import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_game/blocs/single_page_cubit/single_page_cubit.dart';
import 'package:sudoku_game/helpers/utils.dart';
import 'package:sudoku_game/pages/single_non_rating_game_page.dart';
import 'package:sudoku_game/repositories/single_non_rating_game_repository.dart';
import 'package:sudoku_game/widgets/play_button.dart';

import 'info_page.dart';

class FreePlayPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FreePlayPageState();
  }
}

class _FreePlayPageState extends State<FreePlayPage>
    with AutomaticKeepAliveClientMixin<FreePlayPage> {
  SinglePageCubit _singlePageCubit;
  SingleNonRatingGameRepository _repository;
  Future<void> _initSinglePageCubitFuture;

  Future<void> _initSinglePageCubit() async {
    var sharedPrefs = await SharedPreferences.getInstance();
    _repository = SingleNonRatingGameRepository(sharedPreferences: sharedPrefs);
    _singlePageCubit = SinglePageCubit(repository: _repository);
    _singlePageCubit.loadSettingsAndSaveInfo();
  }

  @override
  void initState() {
    _initSinglePageCubitFuture = _initSinglePageCubit();
    super.initState();
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await _singlePageCubit.close();
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
                    "Free Play",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: FutureBuilder(
                future: _initSinglePageCubitFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
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
                              title: "START GAME",
                              subtitle: state.gameMode != GameMode.none
                                  ? "Difficulty: ${getGameModeName(state.gameMode)}"
                                  : "",
                              selectedValue: state.gameMode != GameMode.none
                                  ? state.gameMode
                                  : null,
                              selectorTitle: "Choose difficulty level.",
                              options: getGameModeOptions(),
                            );
                          },
                        ),
                        SizedBox(height: 10),
                        BlocBuilder<SinglePageCubit, SinglePageState>(
                          bloc: _singlePageCubit,
                          buildWhen: (previous, current) {
                            return previous.savedGameInfo !=
                                current.savedGameInfo;
                          },
                          builder: (context, state) {
                            if (state.savedGameInfo != SavedGameInfo.empty()) {
                              return SizedBox(
                                width: 280,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await Navigator.push(
                                        context,
                                        SingleNonRatingGamePage.route(
                                            GameMode.none, _repository));
                                    _singlePageCubit.loadSettingsAndSaveInfo();
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "CONTINUE",
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                      Text(
                                        _getContinueButtonSubTitle(
                                            state.savedGameInfo),
                                        style: TextStyle(
                                          color: Colors.grey[200],
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            return Container();
                          },
                        ),
                      ],
                    );
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _getContinueButtonSubTitle(SavedGameInfo savedGameInfo) {
    return getGameModeName(savedGameInfo.gameMode) +
        " - " +
        formatTime(savedGameInfo.time);
  }

  @override
  bool get wantKeepAlive => true;
}
