import 'package:equatable/equatable.dart';

class Country extends Equatable {
  final String name;
  final String code;

  Country(this.name, this.code);

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(json["nativeName"], json["alpha2Code"]);
  }

  @override
  List<Object> get props => [name, code];
}
