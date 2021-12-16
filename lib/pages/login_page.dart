import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sudoku_game/blocs/login/login_cubit.dart';
import 'package:sudoku_game/pages/reset_password_page.dart';
import 'package:sudoku_game/pages/signup_page.dart';
import 'package:sudoku_game/repositories/auth_repository.dart';
import 'package:formz/formz.dart';
import 'package:sudoku_game/widgets/full_screen_progress_indicator.dart';
import 'package:sudoku_game/helpers/error_helper.dart';
import 'package:easy_localization/easy_localization.dart';

class LoginPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => LoginPage(),
      settings: RouteSettings(name: "LoginPage"),
    );
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: BlocProvider(
        create: (_) => LoginCubit(context.read<AuthRepository>()),
        child: BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state.status.isSubmissionFailure) {
              showErrorSnackBarByKey(scaffoldKey, state.errorMessage);
            }
          },
          child: Stack(
            children: [
              Center(
                child: ListView(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    SizedBox(height: 16),
                    Padding(
                      padding: EdgeInsets.only(left: 50),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "log_in_title".tr(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 40,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    _EmailInput(),
                    SizedBox(height: 10),
                    _PasswordInput(),
                    SizedBox(height: 10),
                    _ForgotPasswordButton(),
                    SizedBox(height: 10),
                    _LoginButton(),
                    SizedBox(height: 10),
                    _LoginWithGoogleButton(),
                    SizedBox(height: 10),
                    _SignUpButton(),
                    SizedBox(height: 16),
                  ],
                ),
              ),
              BlocBuilder<LoginCubit, LoginState>(
                buildWhen: (previous, current) =>
                    previous.status != current.status,
                builder: (context, state) {
                  if (state.status.isSubmissionInProgress) {
                    return FullScreenProgressIndicator();
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return Container(
          height: state.email.invalid ? 70 : 50,
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: TextField(
            key: const Key('loginForm_emailInput_textField'),
            onChanged: (email) =>
                context.read<LoginCubit>().emailChanged(email),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              isDense: true,
              labelText: "field.email.title".tr(),
              errorText: state.email.invalid ? "field.email.error".tr() : null,
            ),
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return Container(
          height: state.password.invalid ? 70 : 50,
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: TextField(
            key: const Key('loginForm_passwordInput_textField'),
            onChanged: (password) =>
                context.read<LoginCubit>().passwordChanged(password),
            obscureText: true,
            decoration: InputDecoration(
              isDense: true,
              labelText: "field.password.title".tr(),
              errorText:
                  state.password.invalid ? "field.password.error".tr() : null,
            ),
          ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return Container(
          height: 50,
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: SizedBox.expand(
            child: ElevatedButton(
              key: const Key('loginForm_continue_raisedButton'),
              child: Text("log_in".tr(), style: TextStyle(fontSize: 18)),
              onPressed: state.status.isValidated &&
                      !state.status.isSubmissionInProgress
                  ? () => context.read<LoginCubit>().signInWithCredentials()
                  : () {},
            ),
          ),
        );
      },
    );
  }
}

class _LoginWithGoogleButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return Container(
          height: 50,
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: SizedBox.expand(
            child: ElevatedButton.icon(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.surface),
                foregroundColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.onSurface),
              ),
              key: const Key('loginWithGoogle_continue_raisedButton'),
              icon: FaIcon(FontAwesomeIcons.google),
              label: Text(
                "google_log_in".tr(),
                style: TextStyle(fontSize: 18),
              ),
              onPressed: () => context.read<LoginCubit>().signInWithGoogle(),
            ),
          ),
        );
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: SizedBox.expand(
        child: OutlinedButton(
          key: const Key('loginForm_createAccount_flatButton'),
          child: Text("create_account".tr(), style: TextStyle(fontSize: 18)),
          onPressed: () => Navigator.of(context).push<void>(SignUpPage.route()),
        ),
      ),
    );
  }
}

class _ForgotPasswordButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 50),
      child: GestureDetector(
        onTap: () async =>
            await Navigator.push(context, ResetPasswordPage.route()),
        child: Text(
          "forgot_password".tr(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.secondary,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
