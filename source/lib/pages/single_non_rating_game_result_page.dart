import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sudoku_game/blocs/non_rating_game_bloc/non_rating_game_bloc.dart';

class SingleNonRatingGameResultPage extends StatelessWidget {
  static Route route(SingleNonRatingGameResult gameResult) {
    return PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, __, ___) =>
            SingleNonRatingGameResultPage(gameResult: gameResult));
  }

  final SingleNonRatingGameResult gameResult;

  const SingleNonRatingGameResultPage({@required this.gameResult});

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
                Text(
                  "Solved!",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textScaleFactor: 1.5,
                ),
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
