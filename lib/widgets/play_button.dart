import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sudoku_game/blocs/connectivity_bloc/connectivity_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sudoku_game/helpers/error_helper.dart';
import 'package:sudoku_game/themes/theme.dart';

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
    return SizedBox(
      height: 56,
      width: 256,
      child: BlocBuilder<ConnectivityBloc, ConnectivityState>(
        builder: (context, state) {
          return ButtonWithSettings(
            buttonChild: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
            settingsButtonChild: FaIcon(
              FontAwesomeIcons.plus,
              color: Theme.of(context).colorScheme.accent,
            ),
            onButtonPressed: state.connected
                ? onPressed
                : () {
                    showErrorSnackBar(
                        context, "error.no_internet_connection".tr());
                  },
            onSettingsButtonPressed: () async {
              var newValue = await showModalSelector(
                context: context,
                selectedValue: selectedValue,
                items: options,
                title: selectorTitle != null ? Text(selectorTitle) : null,
              );
              if (newValue != null) {
                onValueSelected?.call(newValue);
              }
            },
          );
        },
      ),
    );
  }
}
