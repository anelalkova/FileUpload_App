import 'package:bloc/bloc.dart';
import 'package:file_upload_app_part2/network/data_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../network/api_service.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc() : super(const AccountStateInitial()) {
    on<UpdateAccount>(userWantsToUpdateAccount);
    on<DeleteAccount>(userWantsToDeleteAccount);
    on<DeactivateAccount>(userWantsToDeactivateAccount);
    on<LogoutButtonPressed>(userWantsToLogout);
    on<ReturnAccountInitialState>(returnInitialState);
  }

  Future<void> userWantsToUpdateAccount(UpdateAccount event, Emitter<AccountState> emit) async {
    try {
      await DataService().updateUser(event.id, event.user);
      emit(state.copyWith(updateSuccess: true));
    } catch (e) {
      emit(state.copyWith(updateSuccess: false));
    } finally {
      emit(state.copyWith(wantsToUpdateAccount: false));
    }
  }

  Future<void> userWantsToDeleteAccount(DeleteAccount event, Emitter<AccountState> emit) async {
    try {
      await DataService().deleteUser(event.id);
      emit(state.copyWith(deleteSuccess: true));
    } catch (e) {
      emit(state.copyWith(deleteSuccess: false));
    } finally {
      emit(state.copyWith(wantsToDeleteAccount: false));
    }
  }

  Future<void> userWantsToDeactivateAccount(DeactivateAccount event, Emitter<AccountState> emit) async {
    try {
      await DataService().updateUser(event.id, UpdateUser(active: false));
      emit(state.copyWith(deactivateSuccess: true));
    } catch (e) {
      emit(state.copyWith(deactivateSuccess: false));
    } finally {
      emit(state.copyWith(wantsToDeactivateAccount: false));
    }
  }

  Future<void> userWantsToLogout(LogoutButtonPressed event, Emitter<AccountState> emit) async {
    try {
      const storage = FlutterSecureStorage();
      await storage.deleteAll();
      emit(state.copyWith(logoutSuccess: true));
    } catch (e) {
      emit(state.copyWith(logoutSuccess: false));
    } finally {
      emit(state.copyWith(logoutSuccess: false));
    }
  }

  void returnInitialState(ReturnAccountInitialState event, Emitter<AccountState>emit){
    emit(AccountStateInitial());
  }
}
