import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sudoku_game/data_providers/api_data_provider.dart';
import 'package:sudoku_game/models/add_user_model.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final ApiDataProvider _apiDataProvider;

  AuthRepository(
      {FirebaseAuth firebaseAuth, ApiDataProvider apiDataProvider})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _apiDataProvider = apiDataProvider ?? ApiDataProvider.instance;

  Future<void> signUp(
      {@required email,
      @required password,
      @required name,
      countryCode}) async {
    var userCred = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    var addUserModel = AddUserModel(
        id: userCred.user.uid, name: name, countryCode: countryCode);
    try {
      await _apiDataProvider.addUser(addUserModel);
    } on Exception catch (ex) {
      await _firebaseAuth.currentUser.delete();
      rethrow;
    }
  }

  Future<void> signIn({@required email, @required password}) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Stream<AuthStatus> get status {
    return _firebaseAuth.authStateChanges().map((user) {
      return user != null
          ? AuthStatus.authenticated
          : AuthStatus.unauthenticated;
    });
  }
}
