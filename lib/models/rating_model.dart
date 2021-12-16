class RatingModel {
  final String id;
  final String name;
  final String countryCode;
  final int value;
  final int place;

  const RatingModel(
      this.id, this.name, this.countryCode, this.value, this.place);

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(json["id"], json["name"], json["countryCode"],
        json["value"], json["place"]);
  }
}
