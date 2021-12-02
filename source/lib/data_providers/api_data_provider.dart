import 'dart:convert';

import 'package:sudoku_game/constants/api_constants.dart';
import 'package:sudoku_game/helpers/application_exception.dart';
import 'package:sudoku_game/helpers/http_helper.dart';
import 'package:sudoku_game/helpers/utils.dart';
import 'package:sudoku_game/models/add_user_model.dart';
import 'package:sudoku_game/models/rating_model.dart';
import 'package:sudoku_game/models/solved_board_model.dart';
import 'package:sudoku_game/models/user_model.dart';

class ApiDataProviderException extends ApplicationException {
  int statusCode;

  ApiDataProviderException(
      [String message, this.statusCode, Exception innerException])
      : super(message, innerException);

  @override
  String toString() {
    return "ApiDataProviderException($statusCode, $message)";
  }
}

class ApiDataProvider {
  final HttpHelper _httpHelper = HttpHelper();
  static final ApiDataProvider _apiDataProviderInstance = ApiDataProvider._();

  ApiDataProvider._();

  static ApiDataProvider get instance => _apiDataProviderInstance;

  Future<void> addUser(AddUserModel addUserModel) async {
    var response = await _httpHelper.post(ApiConstants.addUserUrl,
        body: jsonEncode(addUserModel.toJson()));
    if (response.statusCode != 201) {
      throw ApiDataProviderException(
          "Adding user request error.", response.statusCode);
    }
  }

  Future<UserModel> getUser(String id) async {
    var response =
        await _httpHelper.get(ApiConstants.getUserUrl.replaceAll("{id}", id));
    if (response.statusCode != 200) {
      throw ApiDataProviderException(
          "Getting user request error.", response.statusCode);
    }
    return UserModel.fromJson(jsonDecode(response.body));
  }

  Future<List<SolvedBoardModel>> getPuzzle(GameMode gameMode) async {
    var response = await _httpHelper.get(ApiConstants.getPuzzleUrl,
        parameters: {"gameMode": gameMode.index});
    if (response.statusCode != 200) {
      throw ApiDataProviderException(
          "Getting puzzle request error.", response.statusCode);
    }
    return (jsonDecode(response.body) as List<dynamic>)
        .map((board) => SolvedBoardModel.fromJson(board))
        .toList();
  }

  Future<List<RatingModel>> getRating(
      GameMode gameMode, RatingType ratingType, int index, int count) async {
    var url = ApiConstants.getDuelRatingUrl;
    if (ratingType == RatingType.solving) {
      url = ApiConstants.getSolvingRatingUrl;
    }
    var response = await _httpHelper.get(url, parameters: {
      "gameMode": gameMode.index,
      "index": index,
      "count": count
    });
    if (response.statusCode != 200) {
      throw ApiDataProviderException(
          "Getting rating request error.", response.statusCode);
    }
    return (jsonDecode(response.body) as List<dynamic>)
        .map((rating) => RatingModel.fromJson(rating))
        .toList();
  }
}
