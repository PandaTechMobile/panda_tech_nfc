import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:panda_tech_nfc/features/authentication/login/login.dart';

import 'login_form.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/animated_background.gif'),
            fit: BoxFit.cover),
      ),
      padding: const EdgeInsets.all(15.0),
      child: Center(
        child: BlocProvider(
          create: (context) {
            // return LoginBloc(
            //   authenticationRepository:
            //   RepositoryProvider.of<AuthenticationRepository>(context),
            // );
            return LoginBloc();
          },
          child: const LoginForm(),
        ),
      ),
    );
  }
}
