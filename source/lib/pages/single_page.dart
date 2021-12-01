import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_game/blocs/game_search_bloc/game_search_bloc.dart';
import 'package:sudoku_game/blocs/single_page_cubit/single_page_cubit.dart';
import 'package:sudoku_game/helpers/utils.dart';
import 'package:sudoku_game/pages/single_non_rating_game_page.dart';
import 'package:sudoku_game/repositories/single_non_rating_game_repository.dart';

import 'single_game_page.dart';

class SinglePage extends StatefulWidget {
  SinglePage() {
    debugPrint("SinglePage()");
  }

  @override
  State<StatefulWidget> createState() {
    return _SinglePageState();
  }
}

class _SinglePageState extends State<SinglePage> {
  SinglePageCubit _singlePageCubit;
  GameSearchBloc _gameSearchBloc;
  SingleNonRatingGameRepository _repository;
  Future<void> _initSinglePageCubitFuture;

  Future<void> _initSinglePageCubit() async {
    var sharedPrefs = await SharedPreferences.getInstance();
    _repository = SingleNonRatingGameRepository(sharedPreferences: sharedPrefs);
    _singlePageCubit = SinglePageCubit(
        initialGameMode: GameMode.onePuzzleEasy,
        initialIsRatingGame: false,
        repository: _repository);
  }

  @override
  void initState() {
    _initSinglePageCubitFuture = _initSinglePageCubit();
    _gameSearchBloc = GameSearchBloc();
    super.initState();
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await _singlePageCubit.close();
    await _gameSearchBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocConsumer<GameSearchBloc, GameSearchState>(
        cubit: _gameSearchBloc,
        listener: (context, state) {
          if (state is GameSearchComplete) {
            Navigator.push(context, SingleGamePage.route(state.gameId));
            _gameSearchBloc.add(GameSearchReset());
          }
        },
        builder: (context, state) {
          if (state is GameSearchInitial) {
            return FutureBuilder(
                future: _initSinglePageCubitFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return BlocBuilder<SinglePageCubit, SinglePageState>(
                      cubit: _singlePageCubit,
                      builder: (context, state) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                                onPressed: state.isRatingGame
                                    ? () {
                                        _gameSearchBloc.add(GameSearchStarted(
                                            GameType.single, state.gameMode));
                                      }
                                    : () async {
                                        await Navigator.push(
                                            context,
                                            SingleNonRatingGamePage.route(
                                                state.gameMode, _repository));
                                        _singlePageCubit.checkForSave();
                                      },
                                child: Text("Start")),
                            state.isSaveAvailable
                                ? TextButton(
                                    onPressed: () async {
                                      await Navigator.push(
                                          context,
                                          SingleNonRatingGamePage.route(
                                              GameMode.none, _repository));
                                      _singlePageCubit.checkForSave();
                                    },
                                    child: Text("Continue"))
                                : Container(),
                            DropdownButton(
                              items: [
                                DropdownMenuItem<GameMode>(
                                  value: GameMode.onePuzzleEasy,
                                  child: Text("Easy"),
                                ),
                                DropdownMenuItem<GameMode>(
                                  value: GameMode.onePuzzleMedium,
                                  child: Text("Medium"),
                                ),
                                DropdownMenuItem<GameMode>(
                                  value: GameMode.onePuzzleHard,
                                  child: Text("Hard"),
                                ),
                                DropdownMenuItem<GameMode>(
                                  value: GameMode.threePuzzles,
                                  child: Text("All"),
                                )
                              ],
                              value: state.gameMode,
                              onChanged: (gameMode) {
                                _singlePageCubit.setGameMode(gameMode);
                              },
                            ),
                            Switch(
                                value: state.isRatingGame,
                                onChanged: (value) {
                                  _singlePageCubit.setIsRatingGame(value);
                                }),
                            state.isRatingGame
                                ? Text("Rating mode on")
                                : Text("Rating mode off")
                          ],
                        );
                      },
                    );
                  } else {
                    return Container();
                  }
                });
          } else if (state is GameSearchProcessing) {
            return CircularProgressIndicator();
          } else if (state is GameSearchError) {
            return Text("Error occured.");
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
