import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudoku_game/blocs/login/login_cubit.dart';
import 'package:sudoku_game/pages/signup_page.dart';
import 'package:sudoku_game/repositories/auth_repository.dart';
import 'package:formz/formz.dart';

class LoginPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => LoginCubit(context.read<AuthRepository>()),
        child: BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state.status.isSubmissionFailure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(content: Text('Authentication Failure')),
                );
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 50),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Log In",
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
              SizedBox(height: 20),
              _LoginButton(),
              SizedBox(height: 10),
              _LoginWithGoogleButton(),
              SizedBox(height: 20),
              _SignUpButton(),
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
              border: OutlineInputBorder(),
              labelText: 'Email',
              errorText: state.email.invalid ? 'Invalid email.' : null,
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
              border: OutlineInputBorder(),
              labelText: 'Password',
              errorText: state.password.invalid ? 'Invalid password.' : null,
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
              child: state.status.isSubmissionInProgress
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      backgroundColor: Colors.transparent,
                    )
                  : Text('LOG IN'),
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
            child: OutlinedButton(
              key: const Key('loginWithGoogle_continue_raisedButton'),
              child: const Text('LOG IN WITH GOOGLE'),
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
          child: Text('CREATE ACCOUNT'),
          onPressed: () => Navigator.of(context).push<void>(SignUpPage.route()),
        ),
      ),
    );
  }
}
