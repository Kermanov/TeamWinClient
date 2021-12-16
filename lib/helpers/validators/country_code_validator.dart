import 'package:formz/formz.dart';

enum CountryCodeValidationError { invalid }

class CountryCode extends FormzInput<String, CountryCodeValidationError> {
  const CountryCode.pure() : super.pure(null);
  const CountryCode.dirty([String value]) : super.dirty(value);

  @override
  CountryCodeValidationError validator(String value) {
    return null;
  }
}
