import 'package:firebase_auth/firebase_auth.dart';
import 'package:sudoku_game/data_providers/api_data_provider.dart';
import 'package:sudoku_game/helpers/application_exception.dart';
import 'package:sudoku_game/models/user_model.dart';

class UserRepositoryException extends ApplicationException {
  UserRepositoryException([String message, Exception innerException])
      : super(message, innerException);
}

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final ApiDataProvider _apiDataProvider;

  UserRepository(
      {FirebaseAuth firebaseAuth, ApiDataProvider apiDataProvider})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _apiDataProvider = apiDataProvider ?? ApiDataProvider.instance;

  Future<UserModel> getCurrentUser() async {
    var firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) {
      throw UserRepositoryException("Can't get user from firebase.");
    }
    var userModel =  await _apiDataProvider.getUser(firebaseUser.uid);
    userModel.email = firebaseUser.email;
    return userModel;
  }
}
