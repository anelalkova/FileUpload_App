part of 'account_bloc.dart';

class AccountState extends Equatable {
  final bool wantsToUpdateAccount;
  final bool wantsToDeleteAccount;
  final bool wantsToDeactivateAccount;
  final bool updateSuccess;
  final bool deleteSuccess;
  final bool deactivateSuccess;

  const AccountState({
    this.wantsToUpdateAccount = false,
    this.wantsToDeleteAccount = false,
    this.wantsToDeactivateAccount = false,
    this.updateSuccess = false,
    this.deleteSuccess = false,
    this.deactivateSuccess = false,
  });

  AccountState copyWith({
    bool? wantsToUpdateAccount,
    bool? wantsToDeleteAccount,
    bool? wantsToDeactivateAccount,
    bool? updateSuccess,
    bool? deleteSuccess,
    bool? deactivateSuccess,
  }) {
    return AccountState(
      wantsToUpdateAccount: wantsToUpdateAccount ?? this.wantsToUpdateAccount,
      wantsToDeleteAccount: wantsToDeleteAccount ?? this.wantsToDeleteAccount,
      wantsToDeactivateAccount: wantsToDeactivateAccount ?? this.wantsToDeactivateAccount,
      updateSuccess: updateSuccess ?? this.updateSuccess,
      deleteSuccess: deleteSuccess ?? this.deleteSuccess,
      deactivateSuccess: deactivateSuccess ?? this.deactivateSuccess,
    );
  }

  @override
  List<Object?> get props => [
    wantsToUpdateAccount,
    wantsToDeleteAccount,
    wantsToDeactivateAccount,
    updateSuccess,
    deleteSuccess,
    deactivateSuccess,
  ];
}

final class AccountStateInitial extends AccountState {
  const AccountStateInitial();
}
