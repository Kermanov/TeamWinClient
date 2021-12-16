import 'package:equatable/equatable.dart';
import 'package:sudoku_game/models/country_model.dart';

class UserModel extends Equatable {
  final String id;
  final String name;
  final Country country;

  UserModel({this.id, this.name, this.country});

  factory UserModel.empty() {
    return UserModel();
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      name: json["name"],
      country:
          json["country"] != null ? Country.fromJson(json["country"]) : null,
    );
  }

  @override
  List<Object> get props => [id, name, country];
}
