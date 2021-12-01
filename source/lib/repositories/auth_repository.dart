import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sudoku_game/data_providers/api_data_provider.dart';
import 'package:sudoku_game/models/add_user_model.dart';

class AuthUser {
  final String id;

  const AuthUser(this.id);
}

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final ApiDataProvider _apiDataProvider;

  AuthRepository({FirebaseAuth firebaseAuth, ApiDataProvider apiDataProvider})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _apiDataProvider = apiDataProvider ?? ApiDataProvider.instance;

  Future<void> signUp(
      {@required email,
      @required password,
      @required name,
      countryCode}) async {
    await _apiDataProvider.addUser(AddUserModel(
        email: email,
        password: password,
        name: name,
        countryCode: countryCode));
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signIn({@required email, @required password}) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Stream<AuthUser> get user {
    return _firebaseAuth.authStateChanges().map((user) {
      return user != null ? AuthUser(user.uid) : null;
    });
  }
}
