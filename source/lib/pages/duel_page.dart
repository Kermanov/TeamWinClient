import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudoku_game/blocs/duel_page_cubit/duel_page_cubit.dart';
import 'package:sudoku_game/blocs/game_search_bloc/game_search_bloc.dart';
import 'package:sudoku_game/helpers/utils.dart';

import 'duel_game_page.dart';

class DuelPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DuelPageState();
  }
}

class _DuelPageState extends State<DuelPage> {
  GameSearchBloc _gameSearchBloc;
  DuelPageCubit _duelPageCubit;

  @override
  void initState() {
    _gameSearchBloc = GameSearchBloc();
    _duelPageCubit = DuelPageCubit(GameMode.onePuzzleEasy);
    super.initState();
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await _gameSearchBloc.close();
    await _duelPageCubit.close();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocConsumer<GameSearchBloc, GameSearchState>(
          bloc: _gameSearchBloc,
          listener: (context, state) {
            if (state is GameSearchComplete) {
              Navigator.push(context, DuelGamePage.route(state.gameId));
              _gameSearchBloc.add(GameSearchReset());
            }
          },
          builder: (context, state) {
            if (state is GameSearchInitial) {
              return BlocBuilder<DuelPageCubit, DuelPageState>(
                bloc: _duelPageCubit,
                builder: (context, state) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          onPressed: () {
                            _gameSearchBloc.add(GameSearchStarted(
                                GameType.duel, state.gameMode));
                          },
                          child: Text("Find Game")),
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
                          _duelPageCubit.setGameMode(gameMode);
                        },
                      ),
                    ],
                  );
                },
              );
            } else if (state is GameSearchProcessing) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  TextButton(
                      onPressed: () {
                        _gameSearchBloc.add(GameSearchAbort());
                      },
                      child: Text("Cancel"))
                ],
              );
            } else if (state is GameSearchAborting) {
              return CircularProgressIndicator();
            } else if (state is GameSearchComplete) {
              return Text("Game found!");
            } else if (state is GameSearchError) {
              return Text("Error occurred.");
            } else {
              return Text("Unknown state.");
            }
          }),
    );
  }
}
