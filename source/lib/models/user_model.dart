class UserModel {
  String id;
  String email;
  String name;
  String countryCode;

  UserModel({this.id, this.email, this.name, this.countryCode});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      email: json["email"],
      name: json["name"],
      countryCode: json["countryCode"] ?? ""
    );
  }
}
