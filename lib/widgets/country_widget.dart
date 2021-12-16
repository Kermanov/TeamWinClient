import 'package:flutter/material.dart';
import 'package:sudoku_game/helpers/utils.dart';
import 'package:sudoku_game/models/country_model.dart';

class CountryWidget extends StatelessWidget {
  final Country country;

  CountryWidget(this.country);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          getFlagEmoji(country.code),
          style: TextStyle(fontSize: 24),
        ),
        SizedBox(width: 8),
        Flexible(
          child: Text(
            country.name,
            style: TextStyle(fontSize: 16),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
