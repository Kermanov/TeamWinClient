class PlayerInfo {
  final String name;
  final int rating;

  const PlayerInfo(this.name, this.rating);

  factory PlayerInfo.fromJson(Map<String, dynamic> json) {
    return PlayerInfo(json["name"], json["rating"]);
  }
}
