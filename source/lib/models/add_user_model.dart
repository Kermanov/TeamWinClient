import 'package:flutter/material.dart';

class AddUserModel {
  String id;
  String name;
  String countryCode;

  AddUserModel({@required this.id, @required this.name, this.countryCode});

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "countryCode": countryCode
    };
  }
}
