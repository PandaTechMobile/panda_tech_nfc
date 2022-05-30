import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../login.dart';

import '../../../dashboard/screens/dashboard_page.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                  content:
                      Text('Authentication Failure - use \'test@test.com\'')),
            );
        } else if (state.status.isSubmissionSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    DashboardPage(email: state.emailAddress.value)),
          );
        }
      },
      child: Container(
        height: 350,
        padding: const EdgeInsets.all(15.0),
        decoration: const BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const _TitleText(titleText: 'Welcome to Weather App'),
            _EmailAddressInput(),
            _PasswordInput(),
            _LoginButton(),
          ],
        ),
      ),
    );
  }
}

class _TitleText extends StatelessWidget {
  final String titleText;
  const _TitleText({required this.titleText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        titleText,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _EmailAddressInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) =>
          previous.emailAddress != current.emailAddress,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: TextField(
            key: const Key('loginForm_emailAddressInput_textField'),
            onChanged: (username) => context
                .read<LoginBloc>()
                .add(LoginEmailAddressChanged(username)),
            decoration: InputDecoration(
              labelText: 'Email Address',
              errorText:
                  state.emailAddress.invalid ? 'Invalid Email Address' : null,
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
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) {
        return previous.password != current.password ||
            previous.showPassword != current.showPassword;
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: TextField(
            key: const Key('loginForm_passwordInput_textField'),
            onChanged: (password) =>
                context.read<LoginBloc>().add(LoginPasswordChanged(password)),
            obscureText: !state.showPassword,
            decoration: InputDecoration(
              labelText: 'Password',
              errorText: state.password.invalid ? 'Invalid Password' : null,
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.remove_red_eye,
                  color: state.showPassword ? Colors.blue : Colors.grey,
                ),
                onPressed: () {
                  context
                      .read<LoginBloc>()
                      .add(LoginShowPasswordChanged(!state.showPassword));
                },
              ),
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
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : Container(
                width: double.infinity,
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ElevatedButton(
                  key: const Key('loginForm_continue_raisedButton'),
                  child: const Text('Login'),
                  onPressed: state.status.isValidated
                      ? () {
                          FocusScope.of(context).unfocus();
                          context.read<LoginBloc>().add(const LoginSubmitted());
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
              );
      },
    );
  }
}
