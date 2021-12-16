import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final Map<String, String> _errorMapper = {
  "invalid-email": "error.invalid_email",
  "auth/invalid-email": "error.invalid_email",
  "user-disabled": "error.user_disabled",
  "user-not-found": "error.user_not_found",
  "auth/user-not-found": "error.user_not_found",
  "wrong-password": "error.wrong_password",
  "account-exists-with-different-credential": "error.try_login_via_email",
  "name-in-use": "error.name_in_use",
  "email-in-use": "error.email_in_use",
  "user-already-exists": "error.user_already_exists",
  "password-incorrect-format": "error.password_incorrect_format",
  "name-incorrect-format": "error.name_incorrect_format",
  "invalid-country-code": "error.invalid_country_code",
  "google-account-is-not-registered": "error.google_account_is_not_registered",
};

String getErrorMessageByCode(String errorCode, [String defaultMessageKey]) {
  var message = _errorMapper[errorCode] ?? defaultMessageKey ?? "error.unknown";
  return message.tr();
}

void showErrorSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Theme.of(context).colorScheme.onError),
        ),
        backgroundColor: Theme.of(context).errorColor,
      ),
    );
}

void showErrorSnackBarByKey(
    GlobalKey<ScaffoldState> scaffoldKey, String message) {
  var context = scaffoldKey.currentContext;
  showErrorSnackBar(context, message);
}
