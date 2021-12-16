import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
  final Widget child;
  final double elevation;
  final Color textColor;
  final Color backGroundColor;

  Tile(
      {@required this.child,
      this.elevation = 2,
      this.textColor,
      this.backGroundColor});

  @override
  Widget build(BuildContext context) {
    return Material(
      textStyle: TextStyle(
        color: textColor ?? Theme.of(context).colorScheme.onSurface,
      ),
      borderRadius: BorderRadius.all(Radius.circular(16)),
      color: backGroundColor ?? Theme.of(context).colorScheme.surface,
      elevation: elevation,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: child,
      ),
    );
  }
}
