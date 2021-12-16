import 'package:flutter/material.dart';

Future<T> showInfoPage<T>(
    {@required BuildContext context, @required String message, String title}) {
  return showModalBottomSheet<T>(
    context: context,
    builder: (_) => InfoPage(message: message, title: title),
  );
}

class InfoPage extends StatelessWidget {
  static Route route(String message, String title) {
    return MaterialPageRoute<void>(
      builder: (_) => InfoPage(
        message: message,
        title: title,
      ),
    );
  }

  final String message;
  final String title;

  InfoPage({@required this.message, this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          title != null
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.info_outline),
                      SizedBox(width: 4),
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),
          Text(message, textAlign: TextAlign.justify),
        ],
      ),
    );
  }
}
