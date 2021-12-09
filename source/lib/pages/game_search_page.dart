import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudoku_game/blocs/game_search_bloc/game_search_bloc.dart';
import 'package:sudoku_game/helpers/utils.dart';

import 'duel_game_page.dart';
import 'info_page.dart';
import 'single_game_page.dart';

class GameSearchPage extends StatefulWidget {
  static Route route(GameType gameType, GameMode gameMode) {
    return MaterialPageRoute<void>(
      builder: (_) => GameSearchPage(
        gameType: gameType,
        gameMode: gameMode,
      ),
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

  @override
  void initState() {
    _gameSearchBloc.add(GameSearchStarted(widget.gameType, widget.gameMode));
    super.initState();
  }

  @override
  void dispose() {
    _gameSearchBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GameSearchBloc, GameSearchState>(
      bloc: _gameSearchBloc,
      listener: (context, state) {
        if (state is GameSearchComplete) {
          if (widget.gameType == GameType.single) {
            Navigator.push(context, SingleGamePage.route(state.gameId));
          } else if (widget.gameType == GameType.duel) {
            Navigator.push(context, DuelGamePage.route(state.gameId));
          }
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: Stack(
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
              Positioned(
                left: 15,
                top: 15,
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  iconSize: 32,
                  onPressed: () {
                    _gameSearchBloc.add(GameSearchAbort());
                    Navigator.pop(context);
                  },
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Creating game.",
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      height: 75,
                      width: 75,
                      child: CircularProgressIndicator(strokeWidth: 6),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      height: 40,
                      width: 120,
                      child: ElevatedButton(
                        onPressed: () {
                          _gameSearchBloc.add(GameSearchAbort());
                          Navigator.pop(context);
                        },
                        child: Text("CANCEL"),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
