import 'package:flutter/material.dart';

Future<T> showModalSelector<T>(
    {@required BuildContext context,
    @required List<ModalSelectorItem<T>> items,
    T selectedValue,
    Widget title}) {
  return showDialog<T>(
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
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: Colors.white,
        child: Column(
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
                  .map<Widget>((e) => GestureDetector(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          color: selectedValue == e.value
                              ? Colors.grey[200]
                              : Colors.white,
                          child: e.child,
                        ),
                        onTap: () {
                          Navigator.pop(context, e.value);
                        },
                      ))
                  .toList()
                    ..add(SizedBox(height: 30)),
            ),
          ],
        ),
      ),
    );
  }
}

class ModalSelectorItem<T> {
  final Widget child;
  final T value;

  ModalSelectorItem({@required this.child, @required this.value});
}
