import 'package:sudoku_game/data_providers/api_data_provider.dart';
import 'package:sudoku_game/models/country_model.dart';

class CountryRepository {
  final ApiDataProvider _apiDataProvider;
  CountryRepository({ApiDataProvider apiDataProvider})
      : _apiDataProvider = apiDataProvider ?? ApiDataProvider.instance;

  Future<List<Country>> getAllCountries() async {
    try {
      return await _apiDataProvider.getAllCountries();
    } on ApiDataProviderException {
      return null;
    }
  }
}
