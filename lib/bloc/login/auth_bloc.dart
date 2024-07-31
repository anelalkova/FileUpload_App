//The BLoC class handles the business logic by mapping events to states.

import 'package:bloc/bloc.dart';
import '../../network/api_service.dart';
import '../../network/data_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final DataService dataService;

  AuthBloc({required this.dataService}) : super(AuthInitial()) {
    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        var response = await dataService.getUserByEmailFromAPI(event.email);
        if (response.success) {
          var user = response.result;
          if (user != null && user.password == event.password) {
            emit(AuthSuccess(message: "Login successful"));
          } else {
            emit(AuthFailure(error: "Incorrect password"));
          }
        } else {
          emit(AuthFailure(error: "Email not found"));
        }
      } catch (e) {
        emit(AuthFailure(error: e.toString()));
      }
    });

    on<RegisterEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        var registerUserRequest = RegisterUserRequest(
          email: event.email,
          name: event.name,
          password: event.password,
        );
        final result = await dataService.registerUser(registerUserRequest);
        if (result.success) {
          emit(AuthSuccess(message: "Registration successful. Please check your email for verification link."));
        } else {
          emit(AuthFailure(error: result.error!));
        }
      } catch (e) {
        emit(AuthFailure(error: e.toString()));
      }
    });

    on<ResendVerificationLinkEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        var result = await dataService.resendVerificationLink(event.email);
        if (result.success) {
          emit(AuthSuccess(message: "Verification link resent!"));
        } else {
          emit(AuthFailure(error: "Failed to resend verification link."));
        }
      } catch (e) {
        emit(AuthFailure(error: e.toString()));
      }
    });
  }
}
