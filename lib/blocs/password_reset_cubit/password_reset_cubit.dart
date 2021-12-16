import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:formz/formz.dart';
import 'package:logger/logger.dart';
import 'package:sudoku_game/helpers/error_helper.dart';
import 'package:sudoku_game/helpers/logger_helper.dart';
import 'package:sudoku_game/helpers/validators/email_validator.dart';
import 'package:sudoku_game/repositories/auth_repository.dart';
import 'package:easy_localization/easy_localization.dart';

part 'password_reset_state.dart';

class PasswordResetCubit extends Cubit<PasswordResetState> {
  final AuthRepository _authRepository;
  Logger _logger;

  PasswordResetCubit(this._authRepository)
      : assert(_authRepository != null),
        super(const PasswordResetState()) {
    _logger = getLogger(this.runtimeType);
    _logger.v("Created.");
  }

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(
      email: email,
      status: Formz.validate([email]),
    ));
  }

  Future<void> sendPasswordResetEmail(String email, String languageCode) async {
    try {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));
      await _authRepository.sendPasswordResetEmail(email, languageCode);
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception catch (ex) {
      handleException(ex);
    }
  }

  void handleException(Exception ex) {
    _logger.w(ex.toString());
    String errorMessage = "error.unknown".tr();
    if (ex is FirebaseAuthException) {
      errorMessage = getErrorMessageByCode(ex.code, "error.password_reset");
    }
    emit(state.copyWith(
      status: FormzStatus.submissionFailure,
      errorMessage: errorMessage,
    ));
  }

  @override
  void onChange(Change<PasswordResetState> change) {
    _logger.d(change.toString());
    super.onChange(change);
  }

  @override
  Future<void> close() {
    _logger.v("Closed.");
    return super.close();
  }
}
