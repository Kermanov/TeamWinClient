import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sudoku_game/data_providers/api_data_provider.dart';
import 'package:sudoku_game/helpers/application_exception.dart';
import 'package:sudoku_game/models/add_user_model.dart';
import 'package:sudoku_game/models/create_user_model.dart';

class AuthRepositoryException extends ApplicationException {
  String errorCode;
  AuthRepositoryException(
      [String message, this.errorCode, Exception innerException])
      : super(message, innerException);
}

class AuthUser {
  final String id;

  const AuthUser(this.id);
}

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final ApiDataProvider _apiDataProvider;
  final GoogleSignIn _googleSignIn;

  AuthRepository(
      {FirebaseAuth firebaseAuth,
      ApiDataProvider apiDataProvider,
      GoogleSignIn googleSignIn})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _apiDataProvider = apiDataProvider ?? ApiDataProvider.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard();

  Future<void> signUp(
      {@required email,
      @required password,
      @required name,
      countryCode}) async {
    await _apiDataProvider.createUser(CreateUserModel(
        email: email,
        password: password,
        name: name,
        countryCode: countryCode));
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signUpWithGoogle() async {
    try {
      var googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return;
      }
      var signInMethods =
          await _firebaseAuth.fetchSignInMethodsForEmail(googleUser.email);
      if (signInMethods.isNotEmpty) {
        throw AuthRepositoryException(
          "User with email '${googleUser.email}' already exists.",
          "user-already-exists",
        );
      }
      var googleAuth = await googleUser.authentication;
      var userCredential = await _firebaseAuth
          .signInWithCredential(GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      ));
      await _apiDataProvider.addUser(AddUserModel(
        email: userCredential.user.email,
      ));
    } on ApiDataProviderException {
      _firebaseAuth.currentUser?.delete();
      await _googleSignIn.signOut();
      rethrow;
    } on Exception {
      await _googleSignIn.signOut();
      rethrow;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      var googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return;
      }
      var signInMethods =
          await _firebaseAuth.fetchSignInMethodsForEmail(googleUser.email);
      var googleAuth = await googleUser.authentication;
      var userCredential = await _firebaseAuth
          .signInWithCredential(GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      ));
      if (signInMethods.isEmpty) {
        await _apiDataProvider.addUser(AddUserModel(
          email: userCredential.user.email,
        ));
      }
    } on ApiDataProviderException {
      _firebaseAuth.currentUser?.delete();
      await _googleSignIn.signOut();
      rethrow;
    } on Exception {
      await _googleSignIn.signOut();
      rethrow;
    }
  }

  Future<void> signIn({@required email, @required password}) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }

  Future<void> sendPasswordResetEmail(String email, String languageCode) async {
    await _firebaseAuth.setLanguageCode(languageCode);
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Stream<AuthUser> get user {
    return _firebaseAuth.authStateChanges().map((user) {
      return user != null ? AuthUser(user.uid) : null;
    });
  }
}
