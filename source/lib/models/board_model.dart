import 'package:flutter/material.dart';

class BoardModel {
  int id;
  List<int> boardList;

  BoardModel({@required this.id, @required this.boardList});

  Map<String, dynamic> toJson() {
    return {"id": id, "boardArray": boardList};
  }

  factory BoardModel.fromJson(Map<String, dynamic> json) {
    return BoardModel(
        id: json["id"],
        boardList:
            List<int>.from(json["boardArray"].map((e) => e as int).toList()));
  }
}
