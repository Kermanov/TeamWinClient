import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:logger/logger.dart';
import 'package:sudoku_game/helpers/logger_helper.dart';
import 'package:sudoku_game/helpers/validators/email_validator.dart';
import 'package:sudoku_game/helpers/validators/name_validator.dart';
import 'package:sudoku_game/helpers/validators/password_validator.dart';
import 'package:sudoku_game/repositories/auth_repository.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this._authRepository)
      : assert(_authRepository != null),
        super(const SignUpState()) {
    _logger = getLogger(this.runtimeType);
    _logger.v("Created.");
  }

  final AuthRepository _authRepository;
  Logger _logger;

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(
      email: email,
      status: Formz.validate([email, state.password, state.name]),
    ));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    emit(state.copyWith(
      password: password,
      status: Formz.validate([state.email, password, state.name]),
    ));
  }

  void nameChanged(String value) {
    final name = Name.dirty(value);
    emit(state.copyWith(
      name: name,
      status: Formz.validate([state.email, state.password, name]),
    ));
  }

  Future<void> signUpFormSubmitted() async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await _authRepository.signUp(
          email: state.email.value,
          password: state.password.value,
          name: state.name.value);
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception catch (ex) {
      _logger.w(ex.toString());
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

  Future<void> signUpWithGoogle() async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await _authRepository.signUpWithGoogle();
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception catch (ex) {
      _logger.w(ex.toString());
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

  @override
  void onChange(Change<SignUpState> change) {
    _logger.d(change.toString());
    super.onChange(change);
  }
}
