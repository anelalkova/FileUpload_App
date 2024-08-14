part of 'account_bloc.dart';

class AccountEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserWantsToUpdateAccount extends AccountEvent {
  final bool wantsToUpdateAccount;

  UserWantsToUpdateAccount({required this.wantsToUpdateAccount});

  @override
  List<Object?> get props => [wantsToUpdateAccount];
}

class UserWantsToDeactivateAccount extends AccountEvent {
  final bool wantsToDeactivateAccount;

  UserWantsToDeactivateAccount({required this.wantsToDeactivateAccount});

  @override
  List<Object?> get props => [wantsToDeactivateAccount];
}

class DeleteAccount extends AccountEvent {
  final int id;

  DeleteAccount({required this.id});

  @override
  List<Object?> get props => [id];
}

class DeactivateAccount extends AccountEvent {
  final int id;

  DeactivateAccount({required this.id});

  @override
  List<Object?> get props => [id];
}

class UpdateAccount extends AccountEvent {
  final int id;
  final UpdateUser user;

  UpdateAccount({required this.id, required this.user});

  @override
  List<Object?> get props => [id, user];
}

class LogoutButtonPressed extends AccountEvent{
  bool userWantsToLogout;

  LogoutButtonPressed({required this.userWantsToLogout});

  @override
  List<Object?> get props => [userWantsToLogout];
}
