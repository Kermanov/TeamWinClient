import 'package:flutter/material.dart';

class AddUserModel {
  String email;
  String password;
  String name;
  String countryCode;

  AddUserModel(
      {@required this.email,
      @required this.password,
      @required this.name,
      this.countryCode});

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "password": password,
      "name": name,
      "countryCode": countryCode
    };
  }
}
