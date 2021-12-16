import 'dart:convert';

import 'package:sudoku_game/constants/api_constants.dart';
import 'package:sudoku_game/helpers/application_exception.dart';
import 'package:sudoku_game/helpers/http_helper.dart';
import 'package:sudoku_game/helpers/utils.dart';
import 'package:sudoku_game/models/add_user_model.dart';
import 'package:sudoku_game/models/country_model.dart';
import 'package:sudoku_game/models/create_user_model.dart';
import 'package:sudoku_game/models/leaderboard_model.dart';
import 'package:sudoku_game/models/solved_board_model.dart';
import 'package:sudoku_game/models/update_user_model.dart';
import 'package:sudoku_game/models/user_model.dart';
import 'package:sudoku_game/models/user_stats_item_model.dart';

class ApiDataProviderException extends ApplicationException {
  int statusCode;
  String errorCode;

  ApiDataProviderException(
      [String message, this.statusCode, this.errorCode, innerException])
      : super(message, innerException);

  @override
  String toString() {
    return "ApiDataProviderException($statusCode, $message, $errorCode)";
  }
}

class ApiDataProvider {
  final HttpHelper _httpHelper = HttpHelper();
  static final ApiDataProvider _apiDataProviderInstance = ApiDataProvider._();

  ApiDataProvider._();

  static ApiDataProvider get instance => _apiDataProviderInstance;

  Future<void> createUser(CreateUserModel createUserModel) async {
    var response = await _httpHelper.post(ApiConstants.createUserUrl,
        body: jsonEncode(createUserModel.toJson()));
    if (response.statusCode != 201) {
      throw ApiDataProviderException(
        "Create user request error.",
        response.statusCode,
        _getErrorCodeFromJson(jsonDecode(response.body)),
      );
    }
  }

  Future<void> addUser(AddUserModel addUserModel) async {
    var response = await _httpHelper.post(ApiConstants.addUserUrl,
        body: jsonEncode(addUserModel.toJson()));
    if (response.statusCode != 201) {
      throw ApiDataProviderException(
        "Add user request error.",
        response.statusCode,
        _getErrorCodeFromJson(jsonDecode(response.body)),
      );
    }
  }

  Future<UserModel> getCurrentUser() async {
    var response = await _httpHelper.get(ApiConstants.getUserUrl, attempts: 3);
    if (response.statusCode != 200) {
      throw ApiDataProviderException(
          "Getting user request error.", response.statusCode);
    }
    return UserModel.fromJson(jsonDecode(response.body));
  }

  Future<void> updateUser(UpdateUserModel updateUserModel) async {
    var response = await _httpHelper.put(ApiConstants.updateUserUrl,
        body: jsonEncode(updateUserModel.toJson()));
    if (response.statusCode != 200) {
      throw ApiDataProviderException(
        "Update user request error.",
        response.statusCode,
        _getErrorCodeFromJson(jsonDecode(response.body)),
      );
    }
  }

  Future<void> deleteUser() async {
    var response = await _httpHelper.delete(ApiConstants.deleteUserUrl);
    if (response.statusCode != 200) {
      throw ApiDataProviderException(
          "Delete user request error.", response.statusCode);
    }
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

  Future<LeaderboardModel> getRating(
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
    return LeaderboardModel.fromJson(jsonDecode(response.body));
  }

  Future<LeaderboardModel> getRating100(
      GameMode gameMode, RatingType ratingType) async {
    var url = ApiConstants.getDuelRatingUrl;
    if (ratingType == RatingType.solving) {
      url = ApiConstants.getSolvingRatingUrl;
    }
    var response = await _httpHelper.get(url, parameters: {
      "gameMode": gameMode.index,
    });
    if (response.statusCode != 200) {
      throw ApiDataProviderException(
          "Getting rating request error.", response.statusCode);
    }
    return LeaderboardModel.fromJson(jsonDecode(response.body));
  }

  Future<Map<GameMode, UserStatsItem>> getCurrentUserStats() async {
    var response = await _httpHelper.get(ApiConstants.getUserStatsUrl);
    if (response.statusCode != 200) {
      throw ApiDataProviderException(
          "Getting user stats request error.", response.statusCode);
    }
    return userStatsFromJson(jsonDecode(response.body));
  }

  Future<List<Country>> getAllCountries() async {
    var response = await _httpHelper.get(ApiConstants.getAllCountriesUrl);
    if (response.statusCode != 200) {
      throw ApiDataProviderException(
          "Getting all countries request error.", response.statusCode);
    }
    return (jsonDecode(response.body) as List<dynamic>)
        .map((country) => Country.fromJson(country))
        .toList();
  }

  String _getErrorCodeFromJson(Map<String, dynamic> json) {
    var errors = json["errors"] as Map<String, dynamic>;
    if (errors != null && errors.values.isNotEmpty) {
      var errorCodes = errors.values.first as List<dynamic>;
      if (errorCodes != null && errorCodes.isNotEmpty) {
        if (errorCodes.first is String) {
          return errorCodes.first;
        }
      }
    }
    return null;
  }
}
