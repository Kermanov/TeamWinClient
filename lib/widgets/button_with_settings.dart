import 'package:flutter/material.dart';

class ButtonWithSettings extends StatelessWidget {
  final Widget buttonChild;
  final Widget settingsButtonChild;
  final void Function() onButtonPressed;
  final void Function() onSettingsButtonPressed;

  ButtonWithSettings(
      {@required this.buttonChild,
      @required this.settingsButtonChild,
      this.onButtonPressed,
      this.onSettingsButtonPressed});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(16),
                  ),
                )),
              ),
              child: buttonChild,
              onPressed: onButtonPressed,
            ),
          ),
          Expanded(
            child: Container(
              constraints: BoxConstraints.expand(),
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(16),
                      ),
                    ),
                  ),
                  padding: MaterialStateProperty.all(EdgeInsets.zero),
                ),
                onPressed: onSettingsButtonPressed,
                child: settingsButtonChild,
              ),
            ),
          )
        ],
      ),
    );
  }
}
