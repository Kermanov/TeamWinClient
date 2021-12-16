part of 'update_profile_cubit.dart';

class UpdateProfileState extends Equatable {
  const UpdateProfileState({
    this.name = const Name.pure(),
    this.countryCode = const CountryCode.pure(),
    this.status = FormzStatus.pure,
    this.profileDeleted = false,
    this.errorMessage,
  });

  final Name name;
  final CountryCode countryCode;
  final FormzStatus status;
  final bool profileDeleted;
  final String errorMessage;

  @override
  List<Object> get props => [
        name,
        countryCode,
        status,
        profileDeleted,
        errorMessage,
      ];

  UpdateProfileState copyWith({
    Name name,
    CountryCode countryCode,
    FormzStatus status,
    bool profileDeleted,
    String errorMessage,
  }) {
    return UpdateProfileState(
      name: name ?? this.name,
      countryCode: countryCode ?? this.countryCode,
      status: status ?? this.status,
      profileDeleted: profileDeleted ?? this.profileDeleted,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
