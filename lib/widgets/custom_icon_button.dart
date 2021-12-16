import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final IconData iconData;
  final void Function() onTap;
  final double size;
  final double iconSize;
  final double borderRadius;
  final double padding;
  final Color iconColor;

  CustomIconButton({
    @required this.iconData,
    this.onTap,
    this.size = 64,
    this.iconSize = 32,
    this.borderRadius = 99,
    this.padding = 8,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Icon(iconData, size: iconSize, color: iconColor),
          onTap: onTap,
        ),
      ),
    );
  }
}
