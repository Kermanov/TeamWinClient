class RatingModel {
  final String id;
  final String name;
  final String countryCode;
  final int value;

  const RatingModel(this.id, this.name, this.countryCode, this.value);

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
        json["id"], json["name"], json["countryCode"], json["value"]);
  }
}
