import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sudoku_game/helpers/utils.dart';
import 'package:sudoku_game/models/rating_model.dart';

class RatingRow extends StatelessWidget {
  final RatingModel ratingModel;
  final RatingType ratingType;

  const RatingRow({@required this.ratingModel, @required this.ratingType});

  String _getValueText() {
    if (ratingType == RatingType.duel) {
      return ratingModel.value.toString();
    } else if (ratingType == RatingType.solving) {
      return DateFormat.ms()
          .format(DateTime.fromMillisecondsSinceEpoch(ratingModel.value));
    } else {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(ratingModel.name),
          ratingModel.countryCode != null
              ? Text(ratingModel.countryCode)
              : Container(),
          Text(_getValueText())
        ],
      ),
    );
  }
}
