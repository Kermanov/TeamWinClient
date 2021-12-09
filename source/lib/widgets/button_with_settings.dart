import 'package:flutter/material.dart';

class ButtonWithSettings extends StatelessWidget {
  final double width;
  final double height;
  final Widget buttonChild;
  final Widget settingsButtonChild;
  final void Function() onButtonPressed;
  final void Function() onSettingsButtonPressed;

  ButtonWithSettings(
      {@required this.buttonChild,
      @required this.settingsButtonChild,
      this.width,
      this.height,
      this.onButtonPressed,
      this.onSettingsButtonPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Row(
        children: [
          SizedBox(
            width: width != null ? width - height : null,
            child: ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                  ),
                )),
              ),
              child: buttonChild,
              onPressed: onButtonPressed,
            ),
          ),
          SizedBox(
            width: height,
            height: height,
            child: OutlinedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                )),
                padding: MaterialStateProperty.all(EdgeInsets.zero),
                backgroundColor: MaterialStateProperty.all(Colors.blue),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
              onPressed: onSettingsButtonPressed,
              child: settingsButtonChild,
            ),
          )
        ],
      ),
    );
  }
}
