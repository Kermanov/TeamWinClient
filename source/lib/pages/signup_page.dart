import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudoku_game/blocs/signup/sign_up_cubit.dart';
import 'package:sudoku_game/repositories/auth_repository.dart';
import 'package:formz/formz.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const SignUpPage());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocProvider<SignUpCubit>(
          create: (_) => SignUpCubit(context.read<AuthRepository>()),
          child: BlocListener<SignUpCubit, SignUpState>(
            listener: (context, state) {
              if (state.status.isSubmissionFailure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(content: Text('Sign Up Failure')),
                  );
              }
            },
            child: Stack(
              children: [
                Positioned(
                  left: 15,
                  top: 15,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    iconSize: 32,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 50),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "Sign Up",
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
                    _PasswordInput(),
                    const SizedBox(height: 20),
                    _SignUpButton(),
                    const SizedBox(height: 10),
                    _SignUpWithGoogleButton(),
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
              border: OutlineInputBorder(),
              labelText: 'Name',
              errorText: state.name.invalid ? 'Invalid name.' : null,
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
              child: state.status.isSubmissionInProgress
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      backgroundColor: Colors.transparent,
                    )
                  : Text('SIGN UP'),
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
            child: OutlinedButton(
              key: const Key('signUpWithGoogle_raisedButton'),
              child: const Text('SIGN UP WITH GOOGLE'),
              onPressed: () => context.read<SignUpCubit>().signUpWithGoogle(),
            ),
          ),
        );
      },
    );
  }
}
