import 'package:sudoku_game/data_providers/api_data_provider.dart';
import 'package:sudoku_game/helpers/application_exception.dart';
import 'package:sudoku_game/helpers/utils.dart';
import 'package:sudoku_game/models/update_user_model.dart';
import 'package:sudoku_game/models/user_model.dart';
import 'package:sudoku_game/models/user_stats_item_model.dart';

class UserRepositoryException extends ApplicationException {
  UserRepositoryException([String message, Exception innerException])
      : super(message, innerException);
}

class UserRepository {
  final ApiDataProvider _apiDataProvider;

  UserRepository({ApiDataProvider apiDataProvider})
      : _apiDataProvider = apiDataProvider ?? ApiDataProvider.instance;

  Future<UserModel> getCurrentUser() {
    return _apiDataProvider.getCurrentUser();
  }

  Future<void> updateUser(UpdateUserModel updateUserModel) {
    return _apiDataProvider.updateUser(updateUserModel);
  }

  Future<void> deleteUser() {
    return _apiDataProvider.deleteUser();
  }

  Future<Map<GameMode, UserStatsItem>> getCurrentUserStats() {
    return _apiDataProvider.getCurrentUserStats();
  }
}
