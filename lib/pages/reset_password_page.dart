import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudoku_game/blocs/password_reset_cubit/password_reset_cubit.dart';
import 'package:sudoku_game/repositories/auth_repository.dart';
import 'package:formz/formz.dart';
import 'package:sudoku_game/widgets/context_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sudoku_game/helpers/error_helper.dart';
import 'package:sudoku_game/widgets/custom_icon_button.dart';

class ResetPasswordPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => ResetPasswordPage(),
      settings: RouteSettings(name: "ResetPasswordPage"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocProvider(
          create: (_) => PasswordResetCubit(context.read<AuthRepository>()),
          child: BlocListener<PasswordResetCubit, PasswordResetState>(
            listener: (context, state) async {
              if (state.status.isSubmissionFailure) {
                showErrorSnackBar(context, state.errorMessage);
              } else if (state.status.isSubmissionSuccess) {
                await showInfoDialog(
                    context: context,
                    message: "password_reset_email_sent".tr());
                Navigator.pop(context);
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
                Center(
                  child: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      SizedBox(height: 50),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            "password_reset_title".tr(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 32,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      _EmailInput(),
                      SizedBox(height: 20),
                      _SendEmailButton(),
                      SizedBox(height: 50),
                    ],
                  ),
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
    return BlocBuilder<PasswordResetCubit, PasswordResetState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return Container(
          height: state.email.invalid ? 70 : 50,
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: TextField(
            onChanged: (email) =>
                context.read<PasswordResetCubit>().emailChanged(email),
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

class _SendEmailButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PasswordResetCubit, PasswordResetState>(
      builder: (context, state) {
        return Container(
          height: 50,
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: SizedBox.expand(
            child: ElevatedButton(
              child: Text("password_reset_button".tr(),
                  style: TextStyle(fontSize: 18)),
              onPressed: state.status.isValidated &&
                      !state.status.isSubmissionInProgress
                  ? () => context
                      .read<PasswordResetCubit>()
                      .sendPasswordResetEmail(
                          state.email.value, context.locale.languageCode)
                  : () {},
            ),
          ),
        );
      },
    );
  }
}
