import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sudoku_game/blocs/signup/sign_up_cubit.dart';
import 'package:sudoku_game/repositories/auth_repository.dart';
import 'package:formz/formz.dart';
import 'package:sudoku_game/widgets/country_input.dart';
import 'package:sudoku_game/widgets/custom_icon_button.dart';
import 'package:sudoku_game/widgets/full_screen_progress_indicator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sudoku_game/helpers/error_helper.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({Key key}) : super(key: key);
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => SignUpPage(),
      settings: RouteSettings(name: "SignUpPage"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        body: BlocProvider<SignUpCubit>(
          create: (_) => SignUpCubit(context.read<AuthRepository>()),
          child: BlocListener<SignUpCubit, SignUpState>(
            listener: (context, state) {
              if (state.status.isSubmissionFailure) {
                showErrorSnackBarByKey(scaffoldKey, state.errorMessage);
              }
            },
            child: Stack(
              children: [
                Positioned(
                  left: 15,
                  top: 15,
                  child: CustomIconButton(
                    iconData: Icons.arrow_back,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Stack(
                  children: [
                    Center(
                      child: ListView(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          SizedBox(height: 50),
                          Padding(
                            padding: EdgeInsets.only(left: 50),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                "sign_up_title".tr(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 40,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          _EmailInput(),
                          const SizedBox(height: 10),
                          _NameInput(),
                          const SizedBox(height: 10),
                          _CountryInput(),
                          const SizedBox(height: 10),
                          _PasswordInput(),
                          const SizedBox(height: 20),
                          _SignUpButton(),
                          const SizedBox(height: 10),
                          _SignUpWithGoogleButton(),
                          SizedBox(height: 50),
                        ],
                      ),
                    ),
                    BlocBuilder<SignUpCubit, SignUpState>(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return Container(
          height: state.email.invalid ? 70 : 50,
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: TextField(
            key: const Key('loginForm_emailInput_textField'),
            onChanged: (email) =>
                context.read<SignUpCubit>().emailChanged(email),
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

class _NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) {
        return Container(
          height: state.name.invalid ? 70 : 50,
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: TextField(
            key: const Key('signUpForm_nameInput_textField'),
            onChanged: (name) => context.read<SignUpCubit>().nameChanged(name),
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              isDense: true,
              labelText: "field.name.title".tr(),
              errorText: state.name.invalid ? "field.name.error".tr() : null,
            ),
          ),
        );
      },
    );
  }
}

class _CountryInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: CountryInput(
        onChanged: (country) {
          context.read<SignUpCubit>().countryCodeChanged(country?.code);
        },
      ),
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return Container(
          height: state.password.invalid ? 70 : 50,
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: TextField(
            key: const Key('signUpForm_passwordInput_textField'),
            onChanged: (password) =>
                context.read<SignUpCubit>().passwordChanged(password),
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

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return Container(
          height: 50,
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: SizedBox.expand(
            child: ElevatedButton(
              key: const Key('signUpForm_continue_raisedButton'),
              child: Text("sign_up".tr(), style: TextStyle(fontSize: 18)),
              onPressed: state.status.isValidated &&
                      !state.status.isSubmissionInProgress
                  ? () => context.read<SignUpCubit>().signUpFormSubmitted()
                  : () {},
            ),
          ),
        );
      },
    );
  }
}

class _SignUpWithGoogleButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
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
              key: const Key('signUpWithGoogle_raisedButton'),
              icon: FaIcon(FontAwesomeIcons.google),
              label: Text(
                "google_sign_up".tr(),
                style: TextStyle(fontSize: 18),
              ),
              onPressed: () => context.read<SignUpCubit>().signUpWithGoogle(),
            ),
          ),
        );
      },
    );
  }
}
