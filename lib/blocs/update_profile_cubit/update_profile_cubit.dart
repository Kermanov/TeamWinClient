import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:logger/logger.dart';
import 'package:sudoku_game/blocs/auth/auth_bloc.dart';
import 'package:sudoku_game/data_providers/api_data_provider.dart';
import 'package:sudoku_game/helpers/error_helper.dart';
import 'package:sudoku_game/helpers/logger_helper.dart';
import 'package:sudoku_game/helpers/validators/country_code_validator.dart';
import 'package:sudoku_game/helpers/validators/name_validator.dart';
import 'package:sudoku_game/models/update_user_model.dart';
import 'package:sudoku_game/repositories/user_repository.dart';
import 'package:easy_localization/easy_localization.dart';

part 'update_profile_state.dart';

class UpdateProfileCubit extends Cubit<UpdateProfileState> {
  UpdateProfileCubit(this._userRepository)
      : assert(_userRepository != null),
        super(const UpdateProfileState()) {
    _logger = getLogger(this.runtimeType);
    _logger.v("Created.");
  }

  final UserRepository _userRepository;
  Logger _logger;

  void nameChanged(String value) {
    final name = Name.dirty(value);
    emit(state.copyWith(
      name: name,
      status: Formz.validate([name, state.countryCode]),
    ));
  }

  void countryCodeChanged(String value) {
    final countryCode = CountryCode.dirty(value);
    emit(state.copyWith(
      countryCode: countryCode,
      status: Formz.validate([state.name, countryCode]),
    ));
  }

  Future<void> updateUser() async {
    if (!state.status.isValidated) return;
    try {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));
      await _userRepository.updateUser(UpdateUserModel(
          name: state.name.value, countryCode: state.countryCode.value));
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception catch (ex) {
      _handleException(ex);
    }
  }

  Future<void> deleteUser(AuthBloc authBloc) async {
    try {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));
      await _userRepository.deleteUser();
      emit(state.copyWith(
        status: FormzStatus.submissionSuccess,
        profileDeleted: true,
      ));
      authBloc?.add(AuthSignOutRequested());
    } on Exception catch (ex) {
      _handleException(ex);
    }
  }

  void _handleException(Exception ex) {
    _logger.w(ex.toString());
    String errorMessage = "error.unknown".tr();
    if (ex is ApiDataProviderException) {
      errorMessage = getErrorMessageByCode(ex.errorCode, "error.profile_edit");
    }
    emit(state.copyWith(
      status: FormzStatus.submissionFailure,
      errorMessage: errorMessage,
    ));
  }

  @override
  void onChange(Change<UpdateProfileState> change) {
    _logger.d(change.toString());
    super.onChange(change);
  }

  @override
  Future<void> close() {
    _logger.v("Closed.");
    return super.close();
  }
}
