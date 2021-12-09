import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  static Route route(String message) {
    return MaterialPageRoute<void>(builder: (_) => InfoPage(message: message));
  }

  final String message;

  InfoPage({@required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.5),
      body: Center(
          child: Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 10),
        color: Colors.white,
        child: FittedBox(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 300),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Info",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(message, textAlign: TextAlign.justify),
                  ],
                ),
                TextButton(
                  child: Text("Close"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}
