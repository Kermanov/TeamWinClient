part of 'sign_up_cubit.dart';

class SignUpState extends Equatable {
  const SignUpState(
      {this.email = const Email.pure(),
      this.password = const Password.pure(),
      this.name = const Name.pure(),
      this.countryCode = const CountryCode.pure(),
      this.status = FormzStatus.pure,
      this.errorMessage});

  final Email email;
  final Password password;
  final Name name;
  final CountryCode countryCode;
  final FormzStatus status;
  final String errorMessage;

  @override
  List<Object> get props => [
        email,
        password,
        name,
        countryCode,
        status,
        errorMessage,
      ];

  SignUpState copyWith({
    Email email,
    Password password,
    Name name,
    CountryCode countryCode,
    FormzStatus status,
    String errorMessage,
  }) {
    return SignUpState(
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      countryCode: countryCode ?? this.countryCode,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
