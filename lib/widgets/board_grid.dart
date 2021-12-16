import 'package:flutter/material.dart';

class BoardGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(8, (index) => index).map((index) {
              return (index + 1) % 3 == 0
                  ? Container(
                      width: 1.5,
                      color: Theme.of(context).colorScheme.secondaryVariant)
                  : Container(
                      width: 0.5,
                      color: Theme.of(context).colorScheme.secondaryVariant);
            }).toList(),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(8, (index) => index).map((index) {
              return (index + 1) % 3 == 0
                  ? Container(
                      height: 1.5,
                      color: Theme.of(context).colorScheme.secondaryVariant)
                  : Container(
                      height: 0.5,
                      color: Theme.of(context).colorScheme.secondaryVariant);
            }).toList(),
          )
        ],
      ),
    );
  }
}
