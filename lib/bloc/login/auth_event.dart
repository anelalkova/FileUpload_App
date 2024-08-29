part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class LoginButtonPressed extends AuthEvent{
  final String email;
  final String password;

  LoginButtonPressed({
    required this.email,
    required this.password,
  });
}

class RegisterAndSendVerificationCode extends AuthEvent{
  final String email;
  final String password;
  final String name;

  RegisterAndSendVerificationCode({
    required this.email,
    required this.password,
    required this.name,
  });
}

class ReturnAuthInitialState extends AuthEvent {}

class AutoLogin extends AuthEvent {}

class ForgotPassword extends AuthEvent {
  final String email;

  ForgotPassword({
    required this.email,
  });
}

class RequestPermissions extends AuthEvent {}

class VerifyAccount extends AuthEvent{}