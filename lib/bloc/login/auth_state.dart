/*part of 'auth_bloc.dart';

class AuthState extends Equatable{
  final bool loginIsValid;
  final bool isUserAccountActive;
  final bool isUserRegistered;
  final bool triedToAutoLogin;
  final bool permissionGranted;
  final bool loading;
  final String registrationErrorMessage;
  final String loginErrorMessage;
  final bool isAutoLoginSuccess;

  const AuthState({
    this.loginIsValid = false,
    this.isUserAccountActive = false,
    this.isUserRegistered = false,
    this.triedToAutoLogin = false,
    this.permissionGranted = false,
    this.loading = false,
    this.registrationErrorMessage = "",
    this.loginErrorMessage = "",
    this.isAutoLoginSuccess = false
  });

  AuthState copyWith({
    bool? loginIsValid,
    bool? isUserAccountActive,
    bool? isUserRegistered,
    bool? triedToAutoLogin,
    bool? permissionGranted,
    bool? loading,
    String? registrationErrorMessage,
    String? loginErrorMessage,
    bool? isAutoLoginSuccess
  }) {
    return AuthState(
        loginIsValid: loginIsValid ?? this.loginIsValid,
        isUserAccountActive: isUserAccountActive ?? this.isUserAccountActive,
        isUserRegistered: isUserRegistered ?? this.isUserRegistered,
        triedToAutoLogin: triedToAutoLogin ?? this.triedToAutoLogin,
        permissionGranted: permissionGranted ?? this.permissionGranted,
        loading: loading ?? this.loading,
        registrationErrorMessage: registrationErrorMessage ??
            this.registrationErrorMessage,
        loginErrorMessage: loginErrorMessage ?? this.loginErrorMessage,
        isAutoLoginSuccess: isAutoLoginSuccess ?? this.isAutoLoginSuccess
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
    loginIsValid,
    isUserRegistered,
    isUserAccountActive,
    triedToAutoLogin,
    permissionGranted,
    loading,
    registrationErrorMessage,
    loginErrorMessage,
    isAutoLoginSuccess
  ];
}

final class AuthStateInitial extends AuthState{
  const AuthStateInitial();
}*/
part of 'auth_bloc.dart';

class AuthState{
  final bool loginIsValid;
  final bool isUserAccountActive;
  final bool isUserRegistered;
  final bool triedToAutoLogin;
  final bool permissionGranted;

  const AuthState({
    this.loginIsValid = false,
    this.isUserAccountActive = false,
    this.isUserRegistered = false,
    this.triedToAutoLogin = false,
    this.permissionGranted = false
  });
}

final class AuthInitial extends AuthState{
  const AuthInitial({
    super.loginIsValid,
    super.isUserAccountActive,
    super.isUserRegistered,
    super.triedToAutoLogin,
    super.permissionGranted
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
