import 'package:sudoku_game/data_providers/api_data_provider.dart';
import 'package:sudoku_game/helpers/application_exception.dart';
import 'package:sudoku_game/helpers/utils.dart';
import 'package:sudoku_game/models/rating_model.dart';

class RatingRepositoryException extends ApplicationException {
  RatingRepositoryException([String message, Exception innerException])
      : super(message, innerException);
}

class RatingRepository {
  final ApiDataProvider _apiDataProvider;

  RatingRepository({ApiDataProvider apiDataProvider})
      : _apiDataProvider = apiDataProvider ?? ApiDataProvider.instance;

  Future<List<RatingModel>> getRating(
      GameMode gameMode, RatingType ratingType, int index, int count) {
    return _apiDataProvider.getRating(gameMode, ratingType, index, count);
  }
}
