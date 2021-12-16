import 'package:flutter/material.dart';
import 'package:sudoku_game/themes/theme.dart';

class GameInfo extends StatelessWidget {
  final String primaryValue;
  final String secondaryValue;
  final double completionPercent;
  final CrossAxisAlignment alignment;
  final bool isOpponent;

  GameInfo({
    @required this.primaryValue,
    @required this.secondaryValue,
    this.completionPercent = 0,
    this.alignment = CrossAxisAlignment.start,
    this.isOpponent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isOpponent
          ? Theme.of(context).colorScheme.secondary.withAlpha(128)
          : Theme.of(context).colorScheme.primary,
      borderRadius: BorderRadius.all(Radius.circular(16)),
      textStyle: TextStyle(
          color: isOpponent
              ? Theme.of(context).colorScheme.onSecondary
              : Theme.of(context).colorScheme.onPrimary),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: FractionallySizedBox(
                widthFactor: completionPercent,
                child: Container(
                  decoration: BoxDecoration(
                    color: completionPercent < 1
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).colorScheme.accent,
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
              ),
            ),
            Align(
              alignment: alignment == CrossAxisAlignment.start
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                child: Column(
                  crossAxisAlignment: alignment,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      primaryValue,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            isOpponent ? FontWeight.normal : FontWeight.bold,
                      ),
                    ),
                    Text(secondaryValue),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
