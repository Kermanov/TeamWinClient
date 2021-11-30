import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sudoku_game/models/game_result_model.dart';

class SingleGameResultPage extends StatelessWidget {
  static Route route(GameResult gameResult) {
    return PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, __, ___) =>
            SingleGameResultPage(gameResult: gameResult));
  }

  final GameResult gameResult;

  const SingleGameResultPage({@required this.gameResult});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.5),
      body: Center(
          child: Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 10),
        color: Colors.white,
        child: FittedBox(
          child: Column(
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                gameResult.isVictory
                    ? Text(
                        "Solved!",
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textScaleFactor: 1.5,
                      )
                    : Text(
                        "Time is over!",
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textScaleFactor: 1.5,
                      ),
                gameResult.message != null
                    ? Text(gameResult.message)
                    : Container(),
                SizedBox(height: 5),
                gameResult.time != null
                    ? Text("Your time: ${_getFormattedTime()}")
                    : Container(),
              ]),
              MaterialButton(
                child: Text("Close"),
                onPressed: () {
                  Navigator.popUntil(context, ModalRoute.withName("HomePage"));
                },
              )
            ],
          ),
        ),
      )),
    );
  }

  String _getFormattedTime() {
    var time = DateTime.fromMillisecondsSinceEpoch(gameResult.time);
    return DateFormat.ms().format(time);
  }
}
