import 'package:flutter/material.dart';

class UserGameInfo extends StatelessWidget {
  final String userName;
  final String value;
  final double completionPercent;

  UserGameInfo(
      {@required this.userName,
      @required this.value,
      this.completionPercent = 0});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        LinearProgressIndicator(
          value: completionPercent,
          minHeight: 35,
          backgroundColor: Colors.white,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
        ),
        Container(
          height: 35,
          padding: EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            border: Border.all(width: 1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(userName), Text(value)],
          ),
        )
      ],
    );
  }
}
