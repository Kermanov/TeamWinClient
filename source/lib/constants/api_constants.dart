class ApiConstants {
  //static const _baseUrl = "https://10.0.2.2:5001";
  static const _baseUrl = "https://40e303aea25d.eu.ngrok.io";

  static const createUserUrl = "$_baseUrl/api/user";
  static const addUserUrl = "$_baseUrl/api/user/add";
  static const getUserUrl = "$_baseUrl/api/user/{id}";

  static const matchmakerHubUrl = "$_baseUrl/matchmaker";
  static const gameHubUrl = "$_baseUrl/game";

  static const getPuzzleUrl = "$_baseUrl/api/puzzle";

  static const getDuelRatingUrl = "$_baseUrl/api/rating/duel";
  static const getSolvingRatingUrl = "$_baseUrl/api/rating/solving";
}
