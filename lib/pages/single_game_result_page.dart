import 'package:flutter/material.dart';
import 'package:sudoku_game/helpers/utils.dart';
import 'package:sudoku_game/models/game_result_model.dart';
import 'package:sudoku_game/widgets/tile.dart';
import 'package:easy_localization/easy_localization.dart';

import 'game_search_page.dart';

class SingleGameResultPage extends StatelessWidget {
  static Route route(GameResult gameResult) {
    return MaterialPageRoute(
      builder: (_) => SingleGameResultPage(gameResult: gameResult),
      settings: RouteSettings(name: "SingleGameResultPage"),
    );
  }

  final GameResult gameResult;

  const SingleGameResultPage({@required this.gameResult});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        return Future.value(false);
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Text(
                getGameResultTypeName(gameResult.gameResultType),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                getGameTypeName(GameType.single) +
                    ", " +
                    getGameModeName(gameResult.gameMode),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 64),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Tile(
                      child: Column(
                        children: [
                          Text("result.solved".tr(),
                              style: TextStyle(fontSize: 16)),
                          Text(
                            (gameResult.completionPercent / 100.0).toString() +
                                "%",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Tile(
                      child: Column(
                        children: [
                          Text(
                            "result.time".tr(),
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            gameResult.time != -1
                                ? formatTime(gameResult.time)
                                : "--",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Tile(
                      child: Column(
                        children: [
                          Text("result.best_time".tr(),
                              style: TextStyle(fontSize: 16)),
                          Text(
                            gameResult.bestTime != -1
                                ? formatTime(gameResult.bestTime)
                                : "--",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              gameResult.isNewBestTime
                  ? Column(
                      children: [
                        SizedBox(height: 16),
                        Text(
                          "result.set_best_time".tr(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  : Container(),
              Spacer(),
              SizedBox(
                width: 280,
                height: 50,
                child: ElevatedButton(
                  child: Text("result.play_again".tr(),
                      style: TextStyle(fontSize: 22)),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        GameSearchPage.route(
                            GameType.single, gameResult.gameMode));
                  },
                ),
              ),
              SizedBox(height: 8),
              SizedBox(
                width: 280,
                height: 50,
                child: OutlinedButton(
                  child:
                      Text("result.home".tr(), style: TextStyle(fontSize: 22)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
