import 'package:flutter/material.dart';
import 'package:sudoku_game/blocs/non_rating_game_bloc/non_rating_game_bloc.dart';
import 'package:sudoku_game/helpers/utils.dart';
import 'package:sudoku_game/widgets/tile.dart';
import 'package:easy_localization/easy_localization.dart';

class SingleNonRatingGameResultPage extends StatelessWidget {
  static Route route(SingleNonRatingGameResult gameResult) {
    return MaterialPageRoute(
      builder: (_) => SingleNonRatingGameResultPage(gameResult: gameResult),
      settings: RouteSettings(name: "SingleNonRatingGameResultPage"),
    );
  }

  final SingleNonRatingGameResult gameResult;

  const SingleNonRatingGameResultPage({@required this.gameResult});

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
                "result.puzzle_solved".tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                getGameTypeName(GameType.free) +
                    ", " +
                    getGameModeName(gameResult.gameMode),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 32),
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
                ],
              ),
              Spacer(),
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
