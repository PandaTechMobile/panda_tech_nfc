import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:panda_tech_nfc/features/authentication/login/login.dart';
import 'package:panda_tech_nfc/features/authentication/login/models/models.dart';
import 'package:formz/formz.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  // LoginBloc({
  //   required AuthenticationRepository authenticationRepository,
  // })  : _authenticationRepository = authenticationRepository,
  //       super(const LoginState()) {
  //   on<LoginUsernameChanged>(_onUsernameChanged);
  //   on<LoginPasswordChanged>(_onPasswordChanged);
  //   on<LoginSubmitted>(_onSubmitted);
  // }

  //final AuthenticationRepository _authenticationRepository;

  LoginBloc() : super(const LoginState()) {
    on<LoginEmailAddressChanged>(_onEmailAddressChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginShowPasswordChanged>(_onShowPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
  }

  void _onEmailAddressChanged(
    LoginEmailAddressChanged event,
    Emitter<LoginState> emit,
  ) {
    final emailAddress = EmailAddress.dirty(event.emailAddress);
    emit(state.copyWith(
      emailAddress: emailAddress,
      status: Formz.validate([state.password, emailAddress]),
    ));
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    final password = Password.dirty(event.password);
    emit(state.copyWith(
      password: password,
      status: Formz.validate([password, state.emailAddress]),
    ));
  }

  void _onShowPasswordChanged(
    LoginShowPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    final showPassword = event.showPassword;
    emit(state.copyWith(
      showPassword: showPassword,
    ));
  }

  void _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (state.status.isValidated) {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));
      try {
        await Future.delayed(Duration(seconds: 2));
        // await _authenticationRepository.logIn(
        //   username: state.username.value,
        //   password: state.password.value,
        // );
        if (state.emailAddress.value != 'test@test.com') {
          emit(state.copyWith(status: FormzStatus.submissionFailure));
          return;
        }
        emit(state.copyWith(status: FormzStatus.submissionSuccess));
      } catch (_) {
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    }
  }
}
