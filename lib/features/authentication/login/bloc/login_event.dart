part of 'login_bloc.dart';

@immutable
abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginEmailAddressChanged extends LoginEvent {
  const LoginEmailAddressChanged(this.emailAddress);

  final String emailAddress;

  @override
  List<Object> get props => [emailAddress];
}

class LoginPasswordChanged extends LoginEvent {
  const LoginPasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

class LoginShowPasswordChanged extends LoginEvent {
  const LoginShowPasswordChanged(this.showPassword);

  final bool showPassword;

  @override
  List<Object> get props => [showPassword];
}

class LoginSubmitted extends LoginEvent {
  const LoginSubmitted();
}
