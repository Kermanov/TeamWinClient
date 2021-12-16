import 'package:flutter/material.dart';

class UpdateUserModel {
  String name;
  String countryCode;

  UpdateUserModel({@required this.name, this.countryCode});

  Map<String, dynamic> toJson() {
    return {"name": name, "countryCode": countryCode};
  }
}
