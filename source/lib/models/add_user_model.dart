import 'package:flutter/material.dart';

class AddUserModel {
  String email;

  AddUserModel({@required this.email});

  Map<String, dynamic> toJson() {
    return {"email": email};
  }
}
