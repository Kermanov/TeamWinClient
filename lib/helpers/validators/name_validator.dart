import 'package:formz/formz.dart';

enum NameValidationError { invalid }

class Name extends FormzInput<String, NameValidationError> {
  const Name.pure() : super.pure('');
  const Name.dirty([String value = '']) : super.dirty(value);

  static final _regExp = RegExp(r"^[A-Za-z0-9]{3,16}$");

  @override
  NameValidationError validator(String value) {
    return _regExp.hasMatch(value) ? null : NameValidationError.invalid;
  }
}
