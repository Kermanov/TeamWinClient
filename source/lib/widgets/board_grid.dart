import 'package:flutter/material.dart';

class BoardGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(10, (index) => index).map((index) {
              return index % 3 == 0
                  ? Container(width: 1.5, color: Colors.black)
                  : Container(width: 0.5, color: Colors.black);
            }).toList(),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(10, (index) => index).map((index) {
              return index % 3 == 0
                  ? Container(height: 1.5, color: Colors.black)
                  : Container(height: 0.5, color: Colors.black);
            }).toList(),
          )
        ],
      ),
    );
  }
}
