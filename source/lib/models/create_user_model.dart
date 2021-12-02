import 'package:flutter/material.dart';

class CreateUserModel {
  String email;
  String password;
  String name;
  String countryCode;

  CreateUserModel(
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
