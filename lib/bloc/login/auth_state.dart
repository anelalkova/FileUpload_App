part of 'auth_bloc.dart';

class AuthState{
  final bool loginIsValid;
  final bool isUserAccountActive;
  final bool isUserRegistered;
  final bool triedToAutoLogin;

  const AuthState({
    this.loginIsValid = false,
    this.isUserAccountActive = false,
    this.isUserRegistered = false,
    this.triedToAutoLogin = false,
  });
}

final class AuthInitial extends AuthState{
  const AuthInitial({
    super.loginIsValid,
    super.isUserAccountActive,
    super.isUserRegistered,
    super.triedToAutoLogin,
  });
}

final class AuthLoading extends AuthState {}

final class AuthRegisteredSuccessfully extends AuthState {}

final class AuthVerify extends AuthState {}

final class AuthVerifySuccess extends AuthState {}

final class AuthVerifyFailure extends AuthState {}

final class AuthSuccess extends AuthState {}

final class AuthFailure extends AuthState{
  final String error;

  const AuthFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

final class AutoLoginSuccess extends AuthState {}