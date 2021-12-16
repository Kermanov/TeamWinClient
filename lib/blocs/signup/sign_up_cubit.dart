import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:formz/formz.dart';
import 'package:logger/logger.dart';
import 'package:sudoku_game/data_providers/api_data_provider.dart';
import 'package:sudoku_game/helpers/error_helper.dart';
import 'package:sudoku_game/helpers/logger_helper.dart';
import 'package:sudoku_game/helpers/validators/country_code_validator.dart';
import 'package:sudoku_game/helpers/validators/email_validator.dart';
import 'package:sudoku_game/helpers/validators/name_validator.dart';
import 'package:sudoku_game/helpers/validators/password_validator.dart';
import 'package:sudoku_game/repositories/auth_repository.dart';
import 'package:easy_localization/easy_localization.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this._authRepository)
      : assert(_authRepository != null),
        super(const SignUpState()) {
    _logger = getLogger(this.runtimeType);
    _logger.v("Created.");
  }

  final FirebaseAnalytics _analytics = FirebaseAnalytics();
  final AuthRepository _authRepository;
  Logger _logger;

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(
      email: email,
      status: Formz.validate(
          [email, state.password, state.name, state.countryCode]),
    ));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    emit(state.copyWith(
      password: password,
      status: Formz.validate(
          [state.email, password, state.name, state.countryCode]),
    ));
  }

  void nameChanged(String value) {
    final name = Name.dirty(value);
    emit(state.copyWith(
      name: name,
      status: Formz.validate(
          [state.email, state.password, name, state.countryCode]),
    ));
  }

  void countryCodeChanged(String value) {
    final countryCode = CountryCode.dirty(value);
    emit(state.copyWith(
      countryCode: countryCode,
      status: Formz.validate(
          [state.email, state.password, state.name, countryCode]),
    ));
  }

  Future<void> signUpFormSubmitted() async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await _authRepository.signUp(
          email: state.email.value,
          password: state.password.value,
          name: state.name.value,
          countryCode: state.countryCode.value);
      await _analytics.logSignUp(signUpMethod: "email");
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception catch (ex) {
      handleException(ex);
    }
  }

  Future<void> signUpWithGoogle() async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await _authRepository.signUpWithGoogle();
      await _analytics.logSignUp(signUpMethod: "google");
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception catch (ex) {
      handleException(ex);
    }
  }

  void handleException(Exception ex) {
    _logger.w(ex.toString());
    String errorMessage = "error.unknown".tr();
    if (ex is FirebaseAuthException) {
      errorMessage = getErrorMessageByCode(ex.code, "error.sign_up");
    } else if (ex is ApiDataProviderException) {
      errorMessage = getErrorMessageByCode(ex.errorCode, "error.sign_up");
    } else if (ex is AuthRepositoryException) {
      errorMessage = getErrorMessageByCode(ex.errorCode, "error.sign_up");
    }
    emit(state.copyWith(
      status: FormzStatus.submissionFailure,
      errorMessage: errorMessage,
    ));
  }

  @override
  void onChange(Change<SignUpState> change) {
    _logger.d(change.toString());
    super.onChange(change);
  }

  @override
  Future<void> close() {
    _logger.v("Closed.");
    return super.close();
  }
}
