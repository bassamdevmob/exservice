part of 'account_bloc.dart';

@immutable
abstract class AccountState {}

class AccountInitial extends AccountState {}

class AccountChangeTabState extends AccountState {}

class AccountAwaitState extends AccountState {}

class AccountAccessibleState extends AccountState {}

class AccountErrorState extends AccountState {
  final String message;

  AccountErrorState(this.message);
}

/// video
class AccountAwaitVideoUploadState extends AccountState {}

class AccountVideoState extends AccountState {}

class AccountErrorVideoUploadState extends AccountState {
  final String message;

  AccountErrorVideoUploadState(this.message);
}

/// image
class AccountAwaitImageUploadState extends AccountState {}

class AccountImageState extends AccountState {}

class AccountErrorImageUploadState extends AccountState {
  final String message;

  AccountErrorImageUploadState(this.message);
}
