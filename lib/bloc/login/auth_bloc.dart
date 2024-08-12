import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:file_upload_app_part2/network/api_service.dart';
import 'package:file_upload_app_part2/network/data_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:permission_handler/permission_handler.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState>{
  AuthBloc() : super(const AuthInitial()){
    on<LoginButtonPressed>(login);
    on<RegisterAndSendVerificationCode>(signup);
    on<ReturnInitialState>(returnToInitialState);
    on<AutoLogin>(autoLogin);
    on<RequestPermissions>(requestPermissions);
  }

  Future<void> returnToInitialState(ReturnInitialState event, Emitter<AuthState> emit)async{
    emit(const AuthInitial());
  }

  FutureOr<void> signup(RegisterAndSendVerificationCode event, Emitter <AuthState> emit)async{
    emit(AuthLoading());
    var response = await DataService().registerUser(RegisterUserRequest(email: event.email, name: event.name, password: event.password));
    var storage = const FlutterSecureStorage();

    if(response.success) {
      emit(AuthRegisteredSuccessfully());
      await storage.write(key: 'email', value: event.email);
      await storage.write(key: 'password', value: event.password);
    }else{
      emit(const AuthFailure(error: 'The user already exists, please login or try to register with a different email.'));
    }
  }

  FutureOr<void> login(LoginButtonPressed event, Emitter <AuthState> emit)async{
    emit(AuthLoading());
    var response = await DataService().userLogin(UserLogin(email: event.email, password: event.password));
    var storage = const FlutterSecureStorage();

    if(response.success){
      emit(AuthSuccess());
      await storage.write(key: 'email', value: event.email);
      await storage.write(key: 'password', value: event.password);
    }else{
      emit(const AuthFailure(error: 'Incorrect email or password. Please try again.'));
    }
  }

  FutureOr<void>autoLogin(AutoLogin event, Emitter <AuthState> emit)async{
    const storage = FlutterSecureStorage();

    //Check if the user is already logged in
    String? email = await storage.read(key: 'email');
    String? password = await storage.read(key: 'password');
    bool userLoggedIn = email !=  null && password != null;

    if(!userLoggedIn){
      emit(const AuthInitial(triedToAutoLogin: true));
      return;
    }

    var response = await DataService().userLogin(UserLogin(email: email, password: password));

    if(response.success){
      await storage.write(key: 'email', value: email);
      await storage.write(key: 'password', value: password);

      if(state is AuthState){
        return;
      }

      emit(AutoLoginSuccess());
    }else{
      emit(const AuthInitial(triedToAutoLogin: true));
    }
  }

  Future<void> requestPermissions(RequestPermissions event, Emitter<AuthState> emit)async {
    var requests = await[
      Permission.camera,
    ].request();
  }
}