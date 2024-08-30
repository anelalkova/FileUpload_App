import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_upload_app_part2/network/api_service.dart';
import 'package:file_upload_app_part2/network/data_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:permission_handler/permission_handler.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState>{
  AuthBloc() : super(const AuthStateInitial()){
    on<LoginButtonPressed>(login);
    on<RegisterAndSendVerificationCode>(signup);
    on<ReturnAuthInitialState>(returnToInitialState);
    on<AutoLogin>(autoLogin);
    on<RequestPermissions>(requestPermissions);
    on<SetEmail>(setEmailEvent);
    on<VerifyAccount>(verifyAccount);
  }

  Future<void> returnToInitialState(ReturnAuthInitialState event, Emitter<AuthState> emit)async{
    emit(const AuthStateInitial());
  }

  FutureOr<void> signup(RegisterAndSendVerificationCode event, Emitter <AuthState> emit)async{
    emit(state.copyWith(loading: true));
    var response = await DataService().registerUser(RegisterUserRequest(email: event.email, name: event.name, password: event.password));
    var storage = const FlutterSecureStorage();

    if(response.success) {
      emit(state.copyWith(isUserRegistered: true));
      await storage.write(key: 'email', value: event.email);
      await storage.write(key: 'password', value: event.password);
    }else{
      emit(state.copyWith(registrationErrorMessage: 'The user already exists, please login or try to register with a different email.', loading: false, isUserRegistered: false));
    }
  }

  FutureOr<void> login(LoginButtonPressed event, Emitter<AuthState> emit) async {
    emit(state.copyWith(loading: true));

    try {
      var response = await DataService().userLogin(UserLogin(email: event.email, password: event.password));
      var storage = const FlutterSecureStorage();

      if (response.success) {
        await storage.write(key: 'email', value: event.email);
        await storage.write(key: 'password', value: event.password);
        await storage.write(key: 'user_id', value: response.result.toString());

        emit(state.copyWith(
          loginIsValid: true,
          loginErrorMessage: "",
          loading: false,
        ));
      } else {
        emit(state.copyWith(
          loginErrorMessage: response.error ?? 'Unknown error occurred',
          loginIsValid: false,
          loading: false,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        loginErrorMessage: 'Failed to connect to the server.',
        loginIsValid: false,
        loading: false,
      ));
    }
  }


  FutureOr<void>autoLogin(AutoLogin event, Emitter <AuthState> emit)async{
    const storage = FlutterSecureStorage();

    String? email = await storage.read(key: 'email');
    String? password = await storage.read(key: 'password');
    bool userLoggedIn = email !=  null && password != null;

    if(!userLoggedIn){
      emit(state.copyWith(triedToAutoLogin: true));
      return;
    }

    var response = await DataService().userLogin(UserLogin(email: email, password: password));

    if(response.success){
      await storage.write(key: 'email', value: email);
      await storage.write(key: 'password', value: password);

      emit(state.copyWith(isAutoLoginSuccess: true));
    }else{
      emit(state.copyWith(triedToAutoLogin: true, isAutoLoginSuccess: false));
    }
  }

  Future<void> requestPermissions(RequestPermissions event, Emitter<AuthState> emit) async {
    final cameraStatus = await Permission.camera.status;
    final storageStatus = await Permission.storage.status;

    if (cameraStatus.isDenied || storageStatus.isDenied) {
      if (cameraStatus.isDenied) {
        await Permission.camera.request();
      }
      if (storageStatus.isDenied) {
        await Permission.storage.request();
      }

      Map<Permission, PermissionStatus> statuses = await [
        Permission.camera,
        Permission.storage,
      ].request();

      print("Camera permission: ${statuses[Permission.camera]}");
      print("Storage permission: ${statuses[Permission.storage]}");

      if (statuses[Permission.camera]!.isGranted && statuses[Permission.storage]!.isGranted) {
        emit(state.copyWith(permissionGranted: true));
      } else {
        emit(state.copyWith(permissionGranted: false));
      }
    } else {
      emit(state.copyWith(permissionGranted: true));
    }
  }


  Future<void> verifyAccount(VerifyAccount event, Emitter<AuthState>emit)async{
    emit(state.copyWith(isUserAccountActive: false, accountVerificationSuccess: false));
    try{
      var result = await DataService().verifyAccount(event.code, state.email);
      if(result.success){
        emit(state.copyWith(isUserAccountActive: true, accountVerificationSuccess: true));
      }else{
        emit(state.copyWith(isUserAccountActive: false, accountVerificationSuccess: false));
      }
    }catch(e){
      emit(state.copyWith(isUserAccountActive: false, accountVerificationSuccess: false));
    }
  }

  void setEmailEvent(SetEmail event, Emitter<AuthState>emit)async{
    emit(state.copyWith(email: event.email));
  }
}