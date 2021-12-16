import 'package:flutter/material.dart';

class BoardBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        color: Theme.of(context).colorScheme.surface,
        elevation: 4,
        type: MaterialType.canvas,
      ),
    );
  }
}
