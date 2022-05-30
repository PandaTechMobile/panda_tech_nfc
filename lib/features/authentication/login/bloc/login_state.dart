part of 'login_bloc.dart';

class LoginState extends Equatable {
  const LoginState({
    this.status = FormzStatus.pure,
    this.emailAddress = const EmailAddress.pure(),
    this.password = const Password.pure(),
    this.showPassword = false,
  });

  final FormzStatus status;
  final EmailAddress emailAddress;
  final Password password;
  final bool showPassword;

  LoginState copyWith({
    FormzStatus? status,
    EmailAddress? emailAddress,
    Password? password,
    bool? showPassword,
  }) {
    return LoginState(
      status: status ?? this.status,
      emailAddress: emailAddress ?? this.emailAddress,
      password: password ?? this.password,
      showPassword: showPassword ?? this.showPassword,
    );
  }

  @override
  List<Object> get props => [status, emailAddress, password, showPassword];
}
