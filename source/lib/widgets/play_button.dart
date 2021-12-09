import 'package:flutter/material.dart';

import 'button_with_settings.dart';
import 'modal_selector.dart';

class PlayButton<T> extends StatelessWidget {
  final String title;
  final String subtitle;
  final String selectorTitle;
  final List<ModalSelectorItem<T>> options;
  final T selectedValue;
  final void Function() onPressed;
  final void Function(T) onValueSelected;

  PlayButton(
      {@required this.title,
      @required this.subtitle,
      @required this.options,
      this.onPressed,
      this.selectedValue,
      this.selectorTitle,
      this.onValueSelected});

  @override
  Widget build(BuildContext context) {
    return ButtonWithSettings(
      width: 280,
      height: 50,
      buttonChild: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey[200],
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
      settingsButtonChild: Icon(Icons.tune),
      onButtonPressed: onPressed,
      onSettingsButtonPressed: () async {
        var newValue = await showModalSelector(
          context: context,
          selectedValue: selectedValue,
          items: options,
          title: selectorTitle != null ? Text(selectorTitle) : null,
        );
        onValueSelected?.call(newValue);
      },
    );
  }
}
