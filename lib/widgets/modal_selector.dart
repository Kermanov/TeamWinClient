import 'package:flutter/material.dart';

Future<T> showModalSelector<T>(
    {@required BuildContext context,
    @required List<ModalSelectorItem<T>> items,
    T selectedValue,
    Widget title}) {
  return showModalBottomSheet<T>(
    context: context,
    builder: (_) => ModalSelector<T>(
      items: items,
      selectedValue: selectedValue,
      title: title,
    ),
  );
}

class ModalSelector<T> extends StatelessWidget {
  final List<ModalSelectorItem<T>> items;
  final T selectedValue;
  final Widget title;

  ModalSelector({@required this.items, this.selectedValue, this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title != null
            ? Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: title,
              )
            : Container(),
        ListView(
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          children: items
              .map<Widget>((e) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    child: Material(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      color: selectedValue == e.value
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                      textStyle: selectedValue == e.value
                          ? TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary)
                          : TextStyle(
                              color:
                                  Theme.of(context).colorScheme.onBackground),
                      child: InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        onTap: () {
                          Navigator.pop(context, e.value);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(9),
                          child: e.child,
                        ),
                      ),
                    ),
                  ))
              .toList()
                ..add(SizedBox(height: 16)),
        ),
      ],
    );
  }
}

class ModalSelectorItem<T> {
  final Widget child;
  final T value;

  ModalSelectorItem({@required this.child, @required this.value});
}
