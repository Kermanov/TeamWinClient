import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sudoku_game/widgets/throbbing_widget.dart';
import 'package:sudoku_game/helpers/utils.dart';

class AnimatedBackground extends StatelessWidget {
  final Random _random = Random();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Alignment>>(
      future: _getRandomAlignments(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return AnimatedOpacity(
            opacity: 1,
            duration: Duration(seconds: 3),
            child: Stack(
              children: [
                Opacity(
                  opacity: 0.1,
                  child: Stack(children: _getNumbers(snapshot.data)),
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Container(color: Colors.transparent),
                )
              ],
            ),
          );
        }
        return Container();
      },
    );
  }

  List<Widget> _getNumbers(List<Alignment> alignments) {
    return alignments
        .map((e) => Align(
              child: ThrobbingWidget(
                child: Material(
                  color: Colors.transparent,
                  child: Text(
                    _random.nextIntFromInterval(1, 10).toString(),
                    style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
                  ),
                ),
                duration: Duration(seconds: _random.nextIntFromInterval(6, 11)),
                minSize: _random.nextDoubleFromInterval(0.1, 1.0),
                maxSize: _random.nextDoubleFromInterval(0.1, 1.0),
              ),
              alignment: e,
            ))
        .cast<Widget>()
        .toList();
  }

  Future<List<Alignment>> _getRandomAlignments() {
    return Future(() {
      var alignments = <Alignment>[];
      while (alignments.length < 24) {
        var alignment = Alignment(_random.nextDoubleFromInterval(-1, 1),
            _random.nextDoubleFromInterval(-1, 1));
        if (alignments
            .every((element) => _getDistance(alignment, element) > 0.35)) {
          alignments.add(alignment);
        }
      }
      return alignments;
    });
  }

  double _getDistance(Alignment first, Alignment second) {
    return sqrt(pow(second.x - first.x, 2) + pow(second.y - first.y, 2));
  }
}
