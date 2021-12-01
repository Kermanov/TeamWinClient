import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:logger/logger.dart';
import 'package:sudoku_game/helpers/logger_helper.dart';
import 'package:sudoku_game/helpers/validators/email_validator.dart';
import 'package:sudoku_game/helpers/validators/password_validator.dart';
import 'package:sudoku_game/repositories/auth_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
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
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception catch (ex) {
      _logger.w(ex.toString());
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

  @override
  void onChange(Change<LoginState> change) {
    _logger.d(change.toString());
    super.onChange(change);
  }
}
