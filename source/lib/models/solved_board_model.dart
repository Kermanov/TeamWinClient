import 'package:flutter/material.dart';

class SolvedBoardModel {
  int id;
  List<int> boardList;
  List<int> solutionList;

  SolvedBoardModel(
      {@required this.id,
      @required this.boardList,
      @required this.solutionList});

  factory SolvedBoardModel.fromJson(Map<String, dynamic> json) {
    return SolvedBoardModel(
        id: json["id"],
        boardList:
            List<int>.from(json["boardArray"].map((e) => e as int).toList()),
        solutionList: List<int>.from(
            json["solutionArray"].map((e) => e as int).toList()));
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "boardArray": boardList, "solutionArray": solutionList};
  }
}
