import 'package:flutter/material.dart';

class GameAbortedDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.delayed(Duration.zero, () => false),
      child: AlertDialog(
        title: Text("Game aborted"),
        content: Text("Opponent didn not connect."),
        actions: [
          TextButton(
              child: Text("Leave"),
              onPressed: () =>
                  Navigator.popUntil(context, ModalRoute.withName("HomePage")))
        ],
      ),
    );
  }
}
