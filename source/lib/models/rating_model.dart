class RatingModel {
  final String name;
  final String countryCode;
  final int value;

  const RatingModel(this.name, this.countryCode, this.value);

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(json["name"], json["countryCode"], json["value"]);
  }
}
