import 'package:flutter/material.dart';

import 'modal_selector.dart';

class ValueSelector<T> extends StatelessWidget {
  final Widget title;
  final List<ModalSelectorItem<T>> options;
  final T selectedValue;
  final void Function(T) onValueSelected;
  final double width;
  final double height;

  ValueSelector(
      {@required this.title,
      @required this.options,
      @required this.selectedValue,
      this.onValueSelected,
      this.width,
      this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title,
          SizedBox(height: 3),
          InkWell(
            borderRadius: BorderRadius.all(Radius.circular(3)),
            onTap: () async {
              var newValue = await showModalSelector(
                context: context,
                selectedValue: selectedValue,
                items: options,
                title: title,
              );
              onValueSelected?.call(newValue);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Transform.scale(
                  scale: 1.5,
                  alignment: Alignment.centerLeft,
                  child: options
                      .firstWhere((element) => element.value == selectedValue)
                      .child,
                ),
                Icon(Icons.expand_more)
              ],
            ),
          )
        ],
      ),
    );
  }
}
