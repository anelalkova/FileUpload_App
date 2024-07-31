//Events are actions that can occur in the app. They are inputs to the BLoC.

abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent({required this.email, required this.password});
}

class RegisterEvent extends AuthEvent {
  final String email;
  final String name;
  final String password;

  RegisterEvent({required this.email, required this.name, required this.password});
}

class ResendVerificationLinkEvent extends AuthEvent {
  final String email;

  ResendVerificationLinkEvent({required this.email});
}