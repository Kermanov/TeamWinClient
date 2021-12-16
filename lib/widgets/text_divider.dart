import 'package:flutter/material.dart';

class TextDivider extends StatelessWidget {
  final String text;

  TextDivider({@required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(text),
        ),
        Expanded(child: Divider(thickness: 1)),
      ],
    );
  }
}
