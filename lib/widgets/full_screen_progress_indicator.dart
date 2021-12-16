import 'package:flutter/material.dart';

class FullScreenProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        color: Theme.of(context).colorScheme.primary.withAlpha(32),
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Container(
            width: 100,
            height: 100,
            child: CircularProgressIndicator(strokeWidth: 6),
          ),
        ),
      ),
    );
  }
}
