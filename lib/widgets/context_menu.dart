import 'package:flutter/material.dart';

Future<T> showContextMenu<T>(
    {@required BuildContext context, @required List<ContextMenuItem> items}) {
  return showModalBottomSheet<T>(
    context: context,
    builder: (_) => ContextMenu(items: items),
  );
}

class ContextMenu extends StatelessWidget {
  final List<ContextMenuItem> items;

  const ContextMenu({@required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 16),
          ListView(
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            children: items,
          ),
          SizedBox(height: 16)
        ],
      ),
    );
  }
}

class ContextMenuItem extends StatelessWidget {
  final Widget child;
  final void Function() onTap;

  const ContextMenuItem({@required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
