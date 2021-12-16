import 'package:flutter/material.dart';
import 'package:sudoku_game/widgets/context_menu.dart';
import 'package:easy_localization/easy_localization.dart';

Future<bool> showQuestionDialog(
    {@required BuildContext context, @required String question}) {
  return showModalBottomSheet<bool>(
    context: context,
    builder: (_) => ContextDialog(
      message: question,
      items: [
        ContextMenuItem(
          child: Text("yes".tr(), style: TextStyle(fontSize: 16)),
          onTap: () => Navigator.pop(context, true),
        ),
        ContextMenuItem(
          child: Text("no".tr(), style: TextStyle(fontSize: 16)),
          onTap: () => Navigator.pop(context, false),
        )
      ],
    ),
  );
}

Future<void> showInfoDialog(
    {@required BuildContext context,
    @required String message,
    String buttonText}) {
  return showModalBottomSheet<bool>(
    context: context,
    builder: (_) => ContextDialog(
      message: message,
      items: [
        ContextMenuItem(
          child: Text(buttonText ?? "ok".tr(), style: TextStyle(fontSize: 16)),
          onTap: () => Navigator.pop(context),
        ),
      ],
    ),
  );
}

class ContextDialog extends StatelessWidget {
  final String message;
  final List<ContextMenuItem> items;

  ContextDialog({@required this.message, this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
          child: Text(message,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
        ),
        ContextMenu(
          items: items,
        ),
      ],
    );
  }
}
