import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:formz/formz.dart';
import 'package:logger/logger.dart';
import 'package:sudoku_game/data_providers/api_data_provider.dart';
import 'package:sudoku_game/helpers/error_helper.dart';
import 'package:sudoku_game/helpers/logger_helper.dart';
import 'package:sudoku_game/helpers/validators/email_validator.dart';
import 'package:sudoku_game/helpers/validators/password_validator.dart';
import 'package:sudoku_game/repositories/auth_repository.dart';
import 'package:easy_localization/easy_localization.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final FirebaseAnalytics _analytics = FirebaseAnalytics();
  final AuthRepository _authRepository;
  Logger _logger;

  LoginCubit(this._authRepository)
      : assert(_authRepository != null),
        super(const LoginState()) {
    _logger = getLogger(this.runtimeType);
    _logger.v("Created.");
  }

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(
      email: email,
      status: Formz.validate([email, state.password]),
    ));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    emit(state.copyWith(
      password: password,
      status: Formz.validate([state.email, password]),
    ));
  }

  Future<void> signInWithCredentials() async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await _authRepository.signIn(
        email: state.email.value,
        password: state.password.value,
      );
      await _analytics.logLogin(loginMethod: "email");
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception catch (ex) {
      handleException(ex);
    }
  }

  Future<void> signInWithGoogle() async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await _authRepository.signInWithGoogle();
      await _analytics.logLogin(loginMethod: "google");
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception catch (ex) {
      handleException(ex);
    }
  }

  void handleException(Exception ex) {
    _logger.w(ex.toString());
    String errorMessage = "error.unknown".tr();
    if (ex is FirebaseAuthException) {
      errorMessage = getErrorMessageByCode(ex.code, "error.login");
    } else if (ex is ApiDataProviderException) {
      errorMessage = getErrorMessageByCode(ex.errorCode, "error.login");
    } else if (ex is AuthRepositoryException) {
      errorMessage = getErrorMessageByCode(ex.errorCode, "error.login");
    }
    emit(state.copyWith(
      status: FormzStatus.submissionFailure,
      errorMessage: errorMessage,
    ));
  }

  @override
  void onChange(Change<LoginState> change) {
    _logger.d(change.toString());
    super.onChange(change);
  }

  @override
  Future<void> close() {
    _logger.v("Closed.");
    return super.close();
  }
}
