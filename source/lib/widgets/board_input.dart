import 'package:flutter/material.dart';

class BoardInput extends StatelessWidget {
  final void Function(int number) onNumberSelected;

  BoardInput({@required this.onNumberSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) => index)
              .map((e) => e != 0
                  ? BoardInputItem(
                      child: Text(e.toString(), textScaleFactor: 2),
                      onTap: () => onNumberSelected.call(e),
                    )
                  : BoardInputItem(
                      child: Icon(Icons.highlight_remove_outlined),
                      onTap: () => onNumberSelected.call(e)))
              .toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) => index + 5)
              .map((e) => BoardInputItem(
                    child: Text(e.toString(), textScaleFactor: 2),
                    onTap: () => onNumberSelected.call(e),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class BoardInputItem extends StatelessWidget {
  final Widget child;
  final void Function() onTap;

  BoardInputItem({@required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        child: Center(child: child),
      ),
    );
  }
}
