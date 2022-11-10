part of 'account_bloc.dart';

class AccountState extends Equatable{
  final List<String> accounts;
  final List<String> selectedAccounts;
  final List<String> appliedAccounts;

  AccountState({this.accounts, this.selectedAccounts, this.appliedAccounts});

  @override
  List<Object> get props => [...accounts, ...selectedAccounts, ...appliedAccounts];
}