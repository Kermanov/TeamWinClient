import 'package:flutter/material.dart';

class BoardInput extends StatelessWidget {
  final void Function(int number) onNumberSelected;

  BoardInput({@required this.onNumberSelected});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(10, (index) => index)
          .map((e) => GestureDetector(
                child: e != 0
                    ? Text(e.toString(), textScaleFactor: 2)
                    : Icon(Icons.highlight_remove_outlined),
                onTap: () => onNumberSelected.call(e),
              ))
          .toList(),
    );
  }
}
