import 'package:flutter/material.dart';

class GameLeaveDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Leave game"),
      content: Text("Do you want to leave?"),
      actions: [
        TextButton(
            child: Text("No"), onPressed: () => Navigator.pop(context, false)),
        TextButton(
            child: Text("Yes"),
            onPressed: () async {
              Navigator.pop(context, true);
            })
      ],
    );
  }
}
