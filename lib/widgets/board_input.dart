import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sudoku_game/themes/theme.dart';
import 'package:easy_localization/easy_localization.dart';

class BoardInput extends StatefulWidget {
  final void Function(int number) onNumberSelected;
  final void Function(bool hintMode) onhintModeChanged;

  BoardInput({
    @required this.onNumberSelected,
    @required this.onhintModeChanged,
  });

  @override
  _BoardInputState createState() => _BoardInputState();
}

class _BoardInputState extends State<BoardInput> {
  bool hintMode = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.all(Radius.circular(16)),
          textStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          child: SizedBox(
            height: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(9, (index) => index + 1).map((e) {
                  return Expanded(
                    child: InkWell(
                      onTap: () => widget.onNumberSelected.call(e),
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      child: Container(
                        child: Center(
                            child: Text(e.toString(), textScaleFactor: 2)),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        SizedBox(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: BoardInputButton(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(FontAwesomeIcons.eraser),
                      Text("erase".tr()),
                    ],
                  ),
                  onTap: () => widget.onNumberSelected.call(0),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: BoardInputButton(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(FontAwesomeIcons.solidEdit),
                      Text("hints_mode".tr()),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      hintMode = !hintMode;
                    });
                    widget.onhintModeChanged.call(hintMode);
                  },
                  active: hintMode,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BoardInputButton extends StatelessWidget {
  final bool active;
  final void Function() onTap;
  final Widget child;

  BoardInputButton({
    this.active = false,
    this.onTap,
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: active
          ? Theme.of(context).colorScheme.selectedCell
          : Colors.transparent,
      borderRadius: BorderRadius.all(Radius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        onTap: onTap,
        child: Center(child: child),
      ),
    );
  }
}
